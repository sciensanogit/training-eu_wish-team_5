# Session 3 (15/01/2026) ----
All your team members should read the code of 01_data_prep-solution.R
Then you may split the following tasks within your team.
Meet regularly to share advancement
 
## Read 01_data_prep-solution.R code used to
- subset dates between date_graph_start and date_graph_end (as defined in 01_data_prep.R)
- subset sars and pmmv data based on labProtocolID used between date_graph_start and date_graph_end ("SC_COV_4.1", "UA_COV_4.0", "SC_PMMV_2.1", "UA_PMMV_2.0")
- rename measure to SARS or PMMV only
- translate two siteName from French to English ("Bruxelles-Sud" to "Brussels-South", "Bruxelles-Nord" to "Brussels-North")
- apply LOQ provided by the lab. Set PMMV values below 250 to NA, and SARS values below 8 to NA
- remove outlier based on the variable named "Quality". Set samples with "Quality concerns" to NA
- compute mean of replicated analysis of each measure using group_by() and summarize()
- compute viral ratio (SARS/PMMV) in a variable named "value_pmmv" using pivot_longer()
- compute moving average on past 14 days
- aggregate data at national level by computing weighted mean with factor being the popServed by each site
- match the metadata structure of file ./Belgium_export-nation.csv
- create ./data folder if not existing and export data in .csv format using writ.table(), in .xlsx format using write.xlsx(), and in .rds using saveRDS()

## Adapt 02_visuals.R code to
- load data saved in .data/Belgium_export-nation.csv. This csv will be created by running 01_data_prep-solution.R. If you cannot run 01_data_prep-solution.R, you can load the ./Belgium_expert-nation.csv
- create ./plot folder if not existing
- create a figure with the viral ratio (variable called value_pmmv) at the national level (inspiration from mission2.R is welcome)
- save graph as ./plot/graph-viral_ratio-nation.png
- Display nice xaxis, yaxis
- Add a past two weeks moving average line from the variable  (variable called value_pmmv_avg14d_past)

## Adapt 03_tbl.R code to
- load data saved in .data/Belgium_export-nation.csv. This csv will be created by running 01_data_prep-solution.R. If you cannot run 01_data_prep-solution.R, you can load the ./Belgium_expert-nation.csv
- save a table showing last ten dates of the national viral ratio with the last date being the date_reporting defined in 01_data_prep.R
- display only sampling days which are Mondays
- display understandable headers, nice units, nice digits
- test different themes
- this table will be used by the 04_quarto.R script

## Adapt 04_quarto.R code to
- make sure you have a .png named graph_oostend_aalst.png in the folder ./plot/ if not save a fake one (maybe using mission2.R).
- run 04_quarto.R and open the .html file produced in your internet browser
- modify the epi_assessment_text.csv at the reporting_date defined in 01_data_prep.R. run 04_quarto.R again and observe the modification of text
- add sentences in 04_quarto.qmd to introduce graphs and tables
- add tbl_nation when your team has saved it

## Adapt 00_main.R code to
- start doing this 45 min before the end of session2, to ensure having enough time.
- ask each team member to commit their change and push it to the online repository
- source 01_data_prep.R, 02_visuals.R, 03_tbl.R, and 04_quarto.R in the 00_main.R script
- make sure to load all packages needed in 00_main.R only
- commit and push the modifications

## extra steps if you have time
- produce .html and .docx files with the quarto render
- Display values below the limit of quantification in red and above in green on graph (values below 1000 copies of SARS/copies of PMMV)
- produce report for two different dates (2025-08-24 and 2025-09-01) with different ending date of graphs and table by modifying the date_reporting variable
- add a table in the 04_quarto.R with the last 10 dates for the sampling site of Brussels-North
- add a graph of influenza starting in Sep2025 and ending in Dec2025 to the quarto report
-- import data with read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantsinfluenza&outputFormat=csv")
-- filter labProtocolID being "SC_INF_2.0" and "UA_INF_2.0"
- add a graph of RSV starting in Sep2025 and ending in Dec2025 ot the quarto report
-- import data with read.csv("https://data.geo.be/ws/sciensano/wfs?SERVICE=WFS&REQUEST=GetFeature&VERSION=2.0.0&TYPENAMES=sciensano:wastewatertreatmentplantsrsv&outputFormat=csv")
-- filter labProtocolID being "SC_RSV_2.0" and "UA_RSV_2.0"