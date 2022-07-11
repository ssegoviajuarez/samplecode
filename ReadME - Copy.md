
1.	Data visualization: An example of a data visualization that you have created by yourself. 

2.	Writing sample: The writing sample must be less than 3000 words. 
        This could be an abridged version of a longer paper/thesis or an existing short piece.

3.	Programming: The code that you used to develop the visualization or for the analysis of your writing sample. 
	R or Python code will be preferred. Please upload your code on GitHub.
	You may use an existing account or create a new one if you don’t have an existing account.

4.	Website development (optional): A webpage that you have developed yourself.


***** DO NOT CIRCULATE MATERIAL *****

1. Visualization sample: qcheckViz.Rdm   (https://github.com/ssegoviajuarez/qcheckViz)
   - qcheckViz ia a R Shiny dashboard to visualize the output from qCheck (a technical package for quality control of household surveys, comprehending variable-specific analysis in each dataset).
   - Dashboard needs the datasets include in this package to be visualized (See package)
   - Given the nature of the data used, dashboard cannot published in shinyapps.io, since data has restricted use.
   - To access to the qcheckViz dashboard (without opening the file and running it by yourself, run the following 2 lines in Rstudio console window.
        - install.packages(c("rmarkdown","flexdashboard","shiny"))
	- rmarkdown::run("LOCATION OF YOUR FILE/qcheckViz.Rmd")
   - Please write to: ssegoviajuarez@worldbank.org if questions arrive.

2. Writing sample: RegressionDiagnostics_SAE_SandraSegovia.pdf: 
  - Chapter written by Sandra Segovia for the upcoming "Guidelines to Small Area Estimation for Poverty Mapping" 
    by Paul Corral, Isabel Molina, Alexandru Cojocaru, and Sandra Segovia. 
    (See Closing Report from GSG1 Data for Policy Analysis (P169434) to see complete guidelines)
    *Note: The 3000 word count does not include the index nor the code extracts, althought it was also written by me.

3. Code samples:
   3.1 Code from qcheckViz.Rdm; written R (and Rshiny), Markdown, CSS and HTML.
   3.2 Code from module_creation.do
   - A do-file that create do-files with help of ASCII code and metadata of other dofiles. 
     It was created  to automatize the harmonization of the GMD data base
     from the LAC region at the Poverty and Equity GP.

***** DO NOT CIRCULATE MATERIAL *****
