Here are your missions!!!

# Session 2 (11/12/2025) ----
 Split the following tasks in your team, meet every 30 min to share advancement
 
## Adapt 01_data_prep.R code to
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
- load data saved in ./Belgium_export-nation.csv folder, at the end use the file exported by your team
- create ./plot folder if not existing
- create figure with the viral ratio at the national level (inspiration from Session1 is welcome)
- save graph as ./plot/graph-viral_ratio-nation.png
- Display nice xaxis, yaxis
- Add a past two weeks moving average line

## Adapt 03_tbl.R code to
- load data saved in ./Belgium_export-nation.csv folder, at the end use the file exported by your team
- save a table showing last ten dates of the national viral ratio with the last date being the date_reporting defined in 01_data_prep.R
- display only sampling days which are Mondays
- display understandable headers, nice units, nice digits
- test different themes

## Adapt 04_quarto code to
- make sure you have a .png named graph_oostend_aalst.png in the folder ./plot/ if not save a fake one (maybe using mission2.R).
- run 04_quarto and view the .html file produced
- modify the epi_assessment_text.csv at the reporting_date defined in 01_data_prep.R. run 04_quarto.R again and observe the modification of text
- add sentences in 04_quarto.qmd to introduce graphs and tables
- try to subtract reporting_date by 7 days to save a new version .html version
- add tbl_nation when your team has saved it

## Adapt 00_main.R code to
- start doing this 45 min before the end of session2, to ensure having enough time.
- ask each team member to commit their change and push it to the online repository
- source 01_data_prep.R, 02_visuals.R, 03_tbl.R, and 04_quarto. make sure to load all packages needed in 00_main.R only
- remove non necessary files
- commit and push the modifications

## extra steps if you have time
- produce .html and .docx files with the quarto render
- Display LOQ in red on graph (values below 1000 copies of SARS/copies of PMMV)
- produce report for two different dates (2025-08-24 and 2025-09-01)
- add a graph of RSV and influenza in the reports