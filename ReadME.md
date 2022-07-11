![Basic Analysis](images/basic.png)

![Indicators](images/indi.png)

# *****DO NOT CIRCULATE MATERIAL *****

## 1. Visualization sample: qcheckViz.Rdm   
   - Also see in https://github.com/ssegoviajuarez/qcheckViz
   - qcheckViz ia a R Shiny dashboard to visualize the output from qCheck (a technical package for quality control of household surveys, comprehending variable-specific analysis in each dataset).
   - Dashboard needs the datasets include in this package to be visualized (See package)
   - Given the nature of the data used, dashboard cannot published in shinyapps.io, since data has restricted use.
   - To access to the qcheckViz dashboard (without opening the file and running it by yourself, run the following 2 lines in Rstudio console window.
        
	- install.packages(c("rmarkdown","flexdashboard","shiny"))
	
	- rmarkdown::run("LOCATION OF YOUR FILE/qcheckViz.Rmd")
   
   - Please write to: ssegoviajuarez@worldbank.org if you have questions.
   
   

   

## 2. Writing sample: RegressionDiagnostics.pdf: 
  - Chapter written by Sandra Segovia for the upcoming "Guidelines to Small Area Estimation for Poverty Mapping" 
    by Paul Corral, Isabel Molina, Alexandru Cojocaru, and Sandra Segovia.
   - **Note**: The 3000 word count does not include the index nor the code extracts, althought it was also written by me.

## 3. Code samples:
   ### 3.1 Code from qcheckViz.Rdm
   - written in R (and Rshiny), Markdown, CSS and HTML.
   ### 3.2 Code from module_creation.do
   - A do-file that create do-files with help of ASCII code and metadata of other dofiles. 
     It was created  to automatize the harmonization of the GMD data base
     from the LAC region at the Poverty and Equity GP.

# ***** DO NOT CIRCULATE MATERIAL *****
