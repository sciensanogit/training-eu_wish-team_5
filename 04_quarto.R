############################################################################### #
# Aim ----
#| generating wastewater reports
# NOTES:
#| git cheat: git status, git add -A, git commit -m "", git push, git pull, git restore
############################################################################### #

# Load packages ----
# select packages
pkgs <- c("dplyr", "ggplot2", "flextable", "quarto")
# install packages
install.packages(setdiff(pkgs, rownames(installed.packages())))
invisible(lapply(pkgs, FUN = library, character.only = TRUE))

# load epi assessment
main_text <- read.csv("epi_assessment_text.csv")

# Render weekly sub report ----
save.image(".RData")

# settings
output_name <- paste0("Report-", format(date_reporting, "%G-W%V"))
format_output <- c("html")
# format_output <- c("html","docx")

quarto_render(input = "04_quarto.qmd",
              output_file = output_name,
              output_format = format_output)

cat("- Success : quarto render \n")
