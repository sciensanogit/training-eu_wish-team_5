############################################################################### #
# Aim ----
#| load, clean and save data
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
#| list of things to do...
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "tidyr", "zoo", "writexl", "flextable", "ggplot2", "quarto")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# load data ----
# Belgian data are available here https://www.geo.be/catalog/details/9eec5acf-a2df-11ed-9952-186571a04de2?l=en
#| Metadata
#| siteName is the name of the treatment plant
#| collDTStart is the date of sampling
#| labName is the name of the lab analysing the sample
#| labProtocolID is the protocol used to analyse the dample
#| flowRate is the flow rate measured at the inlet of the treatment plant during sampling
#| popServ is the population covered by the treatment plant
#| measure is the target measured
#| value is the result

# sars-cov-2 data
df_sc <- read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantscovid&outputFormat=csv")

# pmmv data
df_pmmv <- read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantspmmv&outputFormat=csv")

# join both
df <- df_sc %>%
  rbind(df_pmmv)

# clean data
df <- df %>%
  select(siteName, collDTStart, labName, labProtocolID, flowRate, popServ, measure, value, quality) %>% 
  rename(date = collDTStart) %>% 
  mutate(date = as.Date(date))

# set and subset dates
date_reporting <- as.Date("2025-09-01", format = "%Y-%m-%d")
date_graph_start <- as.Date("2024-09-01", format = "%Y-%m-%d")
date_graph_end <- as.Date("2025-12-01", format = "%Y-%m-%d")

# subset sars and pmmv data based on labProtocolID used betwen date_start and date_end
# display existing labProtocolID
# unique(df$labProtocolID)
df <- df %>%
  filter(labProtocolID %in%
           c("SC_COV_4.1",
             "UA_COV_4.0",
             "SC_PMMV_2.1",
             "UA_PMMV_2.0"))

# rename measures
# diplay existing measure
# unique(df$measure)
df[df$measure == "SARS-CoV-2 E gene", ]$measure <- "SARS"                                  
df[df$measure == "SARS-CoV-2 nucleocapsid gene, allele 2", ]$measure <- "SARS"             
df[df$measure == "Pepper mild mottle virus capsid protein gene region", ]$measure <- "PMMV"

# translate siteName to english 
df[df$siteName == "Bruxelles-Sud", ]$siteName <- "Brussels-South"
df[df$siteName == "Bruxelles-Nord", ]$siteName <- "Brussels-North"

# apply LOQ provided by the lab
df[df$measure == "PMMV" & df$value < 250, ]$value <- NA
df[df$measure == "SARS" & df$value < 8, ]$value <- NA

# remove outliers
df[df$quality == "Quality concerns", ]$value <- NA

# normalization ----
# compute mean of replicated analysis of each measure
df <- df %>%
  select(date, siteName, labName, flowRate, popServ, measure, value) %>%
  group_by(date, siteName, labName, flowRate, popServ, measure) %>%
  summarise(value = mean(value, na.rm = TRUE)) %>% ungroup()

# pivot
df <- df %>%
  pivot_wider(names_from = measure, values_from = value)

# compute viral load (value_load), viral ratio (value_ratio)
df <- df %>%
  pivot_longer(cols = SARS, names_to = "measure", values_to = "value") %>%
  mutate(value_load = value*flowRate*24*1000000/popServ*100000,
         value_pmmv = value/PMMV)

# save
df_site_raw <- df

# smoothening ----
# compute the linear extrapolation data
df <- df_site_raw %>%
  group_by(siteName) %>%
  complete(date = seq(min(date), max(date), "day")) %>%
  mutate(value_avg14d_past = na.approx(value, maxgap = 14, na.rm = FALSE),
         value_load_avg14d_past = na.approx(value_load, maxgap = 14, na.rm = FALSE),
         value_pmmv_avg14d_past = na.approx(value_pmmv, maxgap = 14, na.rm = FALSE))

# compute moving average on past 14 days
df <- df %>%
  group_by(siteName) %>%
  mutate(across(value_avg14d_past:value_pmmv_avg14d_past,
                ~ rollmean(.x, k = 14, fill = NA, na.rm = TRUE, align = "right")))

# save
df_site <- df

# national level ----
## aggregation ----
# compute weighted mean with factor being the population served by each site
df <- df_site_raw %>%
  select(date, popServ, value, value_load, value_pmmv) %>%
  mutate(siteName = "Belgium") %>%
  group_by(siteName, date) %>%
  summarise(across(value:value_pmmv, ~ weighted.mean(.x, popServ, na.rm=TRUE))) %>% ungroup()

## smoothening ----
# linear extrapolation data
df <- df %>%
  group_by(siteName) %>%
  complete(date = seq(min(date), max(date), "day")) %>%
  mutate(value_avg14d_past = na.approx(value, maxgap = 14, na.rm = FALSE),
         value_load_avg14d_past = na.approx(value_load, maxgap = 14, na.rm = FALSE),
         value_pmmv_avg14d_past = na.approx(value_pmmv, maxgap = 14, na.rm = FALSE))

# moving average on past 14 days
df <- df %>%
  group_by(siteName) %>%
  mutate(across(value_avg14d_past:value_pmmv_avg14d_past,
                ~ rollmean(.x, k = 14, fill = NA, na.rm = TRUE, align = "right")))

# save
df_nation <- df

# export data ----
# create folder if not existing
dir.create("./data", showWarnings = F)

# export as csv
write.table(df_site_raw, file = "./data/Belgium_export-site_raw.csv", sep = ";", dec = ".",
            col.names = TRUE, row.names = FALSE)

write.table(df_nation, file = "./data/Belgium_export-site.csv", sep = ";", dec = ".",
            col.names = TRUE, row.names = FALSE)

write.table(df_nation, file = "./data/Belgium_export-nation.csv", sep = ";", dec = ".",
            col.names = TRUE, row.names = FALSE)

# export as xls
write_xlsx(
  list(site_raw = df_site_raw, site = df_site, nation = df_nation),
  path = "./data/Belgium_export.xlsx"
)

# export as rds
saveRDS(list(df_site_raw, df_site, df_nation),
        file = "./data/Belgium_export.rds")


# display msg
cat("- Success : data prep \n")

