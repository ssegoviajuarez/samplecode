require(shiny)
require(rmarkdown)
require(flexdashboard)
folder_address = 'Z://public//Stats_Team//others//adocheck//project03//Rviz//test_app//qcheck.Rmd'
runApp(folder_address, launch.browser=TRUE)
library(shiny)
library(rmarkdown)
Sys.getenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/pandoc")
rmarkdown::render("Z:/public/Stats_Team/others/adocheck/project03/Rviz/qcheck.Rmd", output_file='output.html')
rmarkdown::run("Z:/public/Stats_Team/others/adocheck/project03/Rviz/qcheck.Rmd",shiny_args = list(launch.browser = TRUE))


