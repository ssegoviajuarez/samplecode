********************************************************************************	
*Author:			Sandra Segovia
*				ssegoviajuarez@worldbank
*Modify: 		Karen Barreto Herrera 
*Dependencies:		The World Bank
*Creation Date:		November, 2019
*Modification Date:  January, 2021 - December, 2021
*Output: GMD 1.5 BASES
********************************************************************************		

*module_creation.do
*     A do-file that creates do-files with help of ASCII code and metadata of other dofiles. 
*     It was created to automatize the harmonization of the GMD data base
*     from the LAC region at the Poverty and Equity GP.


********************************************************************************
*-------------------------------- 0. Set up -----------------------------------*
********************************************************************************
clear all
*set trace on
set checksum off, permanently 

global rootdatalib "S:\Datalib"
global gitpath "${rootdatalib}\_do_gmd"
global datapath "${rootdatalib}\GMD_1.5"
global docs "${datapath}\_docs"             
global index "${docs}\GMD 1.5 List of Variables - 13Dec2021.xlsx" 
global modules "${datapath}\_modules"

****MODULES definitions*********************************************************
*Module ID (IDN)
*Module Geography (GEO)
*Module Demography (DEM)
*Module Labor (LBR)
*Module Utilities (UTL)
*Module Assets and Dwellings (DWL)
********************************************************************************

local update_aux = "yes"    // update if there is a change in excel dictionary
local modules_aux = "yes"   // creates 1 dofile x module for chosen country/year
local rundofiles_aux = "yes" // runs the dofiles (from the previous step) to create a dta per module 
local gmd15_aux = "yes" // Merge previous dtas to create a final version of the GMD 1.5

local modules IDN COR DEM GEO UTL DWL LBR


********************************************************************************
*-------------------------- 1. Update Excel Dictionary ------------------------*
********************************************************************************

if ("`update_aux'"=="yes") {

**For modules that do not require appends: IDN COR
    local modules_1 IDN 
    foreach mod of local modules_1 {
        noi di "`mod'"
        import excel "${index}", sheet("`mod'") firstrow clear
        keep if Module == "`mod'"
        save "${modules}\\`mod'.dta", replace        
    }
 
**For modules that requiere append with IDN: DEM GEO UTL DWL
    tempfile tempo_file
    save `tempo_file', replace empty

    local modules_2 COR DEM GEO UTL DWL
    foreach mod of local modules_2 {
        noi di "`mod'"
        tempfile tempo_file
        import excel "${index}", sheet("`mod'") firstrow clear
        keep if Module == "`mod'"
        save `tempo_file', replace     
        use "${modules}\IDN.dta", clear
        keep if inlist(Variable, "countrycode","year","hhid","pid","weight","weighttype")
        append using `tempo_file', force
        save "${modules}\\`mod'.dta", replace 
    }
    
**For modules that requiere append with IDN and DEM: LBR
    tempfile tempo_file
    save `tempo_file', replace empty
    
    local modules_3 LBR
    foreach mod of local modules_3 {
        noi di "`mod'"
        tempfile tempo_file
        import excel "${index}", sheet("`mod'") firstrow clear
        keep if Module == "`mod'"
        save `tempo_file', replace     
        use "${modules}\DEM.dta", clear
        keep if inlist(Variable, "countrycode","year","hhid","pid","weight","weighttype","age")
        append using `tempo_file', force
        save "${modules}\\`mod'.dta", replace 
    }
       
}


********************************************************************************
*---------------------- 2. Country, year specifications -----------------------*
********************************************************************************
version 10
drop _all

local type     "SEDLAC-03" // Collection used
local code     "BRA"  // Country ISO code
local year     "2020"   // Year of the survey
local theperiod "period(e5)" 

cap datalib, country(`code') year(`year') type(sedlac) mod(all) pro(03) `theperiod' clear 

if _rc!=0 { 
	local vm       "01"     // Master version
	local va       "01"     // Alternative version
noi di "Warning: new version"
}

else {

    local vm       "`r(vermast)'"     // Master version
	local va       "`r(veralt)'"     // Alternative version
}

local survey = upper("`r(survname)'")


********************************************************************************
*    3. Sofcode
********************************************************************************

include "${rootdatalib}\_git_gld\_aux\GMD_softcode.do"

********************************************************************************
*    4. Do files by Module creation
********************************************************************************

if  ("`modules_aux'"=="yes") {

    foreach mod of local modules {
	
    use "${modules}\\`mod'.dta", clear
   
    *use levels of vars in that dta, we want to create a local that will keep
    *levelsof Variable, clean
    *local varlist =  "`r(levels)'"
    m : st_local("Variable", invtokens(st_sdata(., "Variable")'))
    local varlist : list uniq Variable
    
    *******
    count if Module != " "
    local N = r(N)

    **************************************************************************** 
    cap mkdir "${gitpath}\\`code'"
    cap mkdir "${gitpath}\\`code'\\`code'_`year'_`survey'"
    file open `mod' using "${gitpath}\\`code'\\`code'_`year'_`survey'\\`code'_`year'_`survey'_v`vm'_M_v`va'_A_GMD_`mod'.do", write replace
    
    set more off
   

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*   
**************************** Writing Preamble **********************************
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
            
    file write `mod' ///
"/*------------------------------------------------------------------------------" _n   ///
                  _tab(5)        "GMD Harmonization"                  _n  ///
"--------------------------------------------------------------------------------" _n  ///             
"<_Program name_>" _column(20) "`code'_`year'_`survey'_v`vm'_M_v`va'_A_GMD_`mod'.do" _tab "</_Program name_>" _n ///
"<_Application_>"  _column(20) "`appl'"    _tab "<_Application_>" _n ///
"<_Author(s)_>"    _column(20) "`author'"  _tab "</_Author(s)_>" _n ///                            
"<_Date created_>" _column(20) "`date_created'" _tab "</_Date created_>"_n ///                          
"<_Date modified>" _column(20)	"$S_DATE" _tab "</_Date modified_>" _n ///   
"--------------------------------------------------------------------------------"_n /// 
"<_Country_>"      _column(20) "`code'" _tab "</_Country_>"_n /// 
"<_Survey Title_>" _column(20) "`survey'" _tab "</_Survey Title_>" _n /// 
"<_Survey Year_>"  _column(20) "`year'" _tab "</_Survey Year_>"_n /// 
"--------------------------------------------------------------------------------"_n ///    
"<_Version Control_>"_n /// 
"Date:" _tab "`date_created'" _n /// 
"File:" _tab "`code'_`year'_`survey'_v`vm'_M_v`va'_A_GMD_`mod'.do" _n ///
"- First version" _n ///
"</_Version Control_>"_n /// 
"------------------------------------------------------------------------------*/"_n(2) ///
"*<_Program setup_>;"_n /// 
"#delimit ;" _n ///
"clear all;" _n /// 
"set more off;"_n(2) /// 
"local code"    _column(20)  (char(034)) "`code'" (char(034)) ";" _n ///  
"local year"    _column(20)  (char(034)) "`year'" (char(034)) ";" _n ///
"local survey"  _column(20)  (char(034)) "`survey'" (char(034)) ";" _n /// 
"local vm"      _column(20)  (char(034)) "`vm'" (char(034)) ";" _n /// 
"local va"      _column(20)  (char(034)) "`va'" (char(034)) ";" _n ///
"local type"    _column(20)  (char(034)) "`type'" (char(034)) ";" _n ///
"local yearfolder" _column(20)   (char(034)) "`code'_`year'_`survey'" (char(034)) ";" _n ///
"local gmdfolder" _column(20) (char(034)) "`code'_`year'_`survey'_v`vm'_M_v`va'_A_GMD" (char(034)) ";" _n ///
"local filename" _column(20) (char(034)) "`code'_`year'_`survey'_v`vm'_M_v`va'_A_GMD_`mod'" (char(034)) ";" _n ///
"*</_Program setup_>;" _n(2) ///  
"*<_Folder creation_>;" _n ///
"cap mkdir " (char(034)) (char(036)) "rootdatalib\GMD_1.5" (char(034)) ";" _n ///
"cap mkdir " (char(034)) (char(036)) "rootdatalib\GMD_1.5\\" (char(096)) "code" (char(039)) (char(034)) ";" _n ///
"cap mkdir " (char(034)) (char(036)) "rootdatalib\GMD_1.5\\" (char(096)) "code" (char(039)) "\\" (char(096)) "yearfolder" (char(039)) (char(034)) ";" _n ///
"cap mkdir " (char(034)) (char(036)) "rootdatalib\GMD_1.5\\" (char(096)) "code" (char(039)) "\\" (char(096)) "yearfolder" (char(039)) "\\" (char(096)) "gmdfolder" (char(039)) (char(034)) ";" _n ///
"cap mkdir " (char(034)) (char(036)) "rootdatalib\GMD_1.5\\" (char(096)) "code" (char(039)) "\\" (char(096)) "yearfolder" (char(039)) "\\" (char(096)) "gmdfolder" (char(039)) "\Data" (char(034)) ";" _n ///
"cap mkdir " (char(034)) (char(036)) "rootdatalib\GMD_1.5\\" (char(096)) "code" (char(039)) "\\" (char(096)) "yearfolder" (char(039)) "\\" (char(096)) "gmdfolder" (char(039)) "\Data\Harmonized" (char(034)) ";" _n ///
"*</_Folder creation_>;" _n(2) ///
"*<_Datalibweb request_>;"_n /// 
"#delimit cr" _n ///
"datalib, country(" (char(096)) "code" (char(039)) ") " ///
            "year(" (char(096)) "year" (char(039)) ") " ///
            "type(" (char(096)) "sedlac" (char(039)) ") " ///
            "pro(" (char(096)) "03" (char(039)) ") " ///
            "survey(" (char(096)) "survey" (char(039)) ") " ///
            "vermast(" (char(096)) "vm" (char(039)) ") " ///
            "veralt(" (char(096)) "va" (char(039)) ") " ///
            "mod(all) `theperiod' clear" _n ///
"#delimit ;" _n ///
"*</_Datalibweb request_>;" _n(2) ///

* module specific
    forvalues i = 1(1)`N' {
            file write `mod' ///
                    "*<_" (Variable[`i']) "_>;" _n ///              
                    "*<_" (Variable[`i']) "_note_> " (Variablelabel[`i']) ///
                    " *</_" (Variable[`i']) "_note_>;" _n  ///
                    "*<_" (Variable[`i']) "_note_> " (Variable[`i']) /// 
                    " brought in from " (Source[`i']) /// 
                    " *</_" (Variable[`i']) "_note_>;" _n ///   
                    (Code[`i']) _n ///                 
                   "*</_" (Variable[`i']) "_>;" _n(2)  
    }
    
    file write `mod' ///  
"*<_Keep variables_>;" _n ///
"keep " "`varlist'" ";" _n ///
"order countrycode year hhid pid weight weighttype" ";" _n ///
"sort hhid pid ;" _n ///
"*</_Keep variables_>;" _n(2) ///
"*<_Save data file_>;"_n ///
"save " (char(034)) (char(036)) "rootdatalib\GMD_1.5\\" ///
            (char(096)) "code" (char(039)) "\\" (char(096)) "yearfolder" (char(039)) "\\" ///
            (char(096)) "gmdfolder" (char(039)) "\Data\Harmonized\\" (char(096)) "filename" ///
            (char(039)) ".dta" (char(034)) " , replace" ";" _n ///
"*</_Save data file_>;"_n ///
"exit;" _n 
    file close `mod'

    }
}

********************************************************************************
*    5. Run do files 
********************************************************************************

if ("`rundofiles_aux'"=="yes") {
    cd "${gitpath}\\`code'\\`code'_`year'_`survey'\\"
    global rootdatalib "S:\Datalib"
    foreach mod of local modules {
      do "`code'_`year'_`survey'_v`vm'_M_v`va'_A_GMD_`mod'.do"
    }
}

********************************************************************************
*    6. Merge to create GMD 1.5
********************************************************************************

if ("`gmd15_aux'"=="yes") {
*labels and other locals
    
cd "${datapath}\\`code'\\`code'_`year'_`survey'\\`code'_`year'_`survey'_v`vm'_M_v`va'_A_GMD\Data\Harmonized\\"

*Merge do files
use "`code'_`year'_`survey'_v`vm'_M_v`va'_A_GMD_IDN.dta"
sort hhid pid

local mods COR GEO DEM LBR DWL UTL 
foreach mod of local mods {
    sort hhid pid
    merge 1:1 hhid pid using "`code'_`year'_`survey'_v`vm'_M_v`va'_A_GMD_`mod'.dta"
    tab _merge
    keep if _merge==3
    drop _merge       
}
include "${gitpath}\_aux\GMD_1.5_variables_and_value_labels.do"
keep `gmd_1_5_vars' 
order `gmd_1_5_vars'
save "`code'_`year'_`survey'_v`vm'_M_v`va'_A_GMD_ALL.dta",replace
}

exit
