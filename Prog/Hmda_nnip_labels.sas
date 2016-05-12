/**************************************************************************
 Program:  Hmda_nnip_labels.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/25/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Add labels to NNIP HMDA tract-summary files.

 Modifications:
**************************************************************************/

/** Macro Hmda_nnip_labels - Start Definition **/

%macro Hmda_nnip_labels;

  label
    NumHsngUnits1_4Fam = "Number of housing units, 1 to 4 families (HMDA def.), 2000"
    NumMrtgApps = "Mortgage loan applications (all purposes)"
    NumMrtgAppsHomePurch = "Mortgage loan applications for home purchase"
    NumMrtgAppsHomeImprov = "Mortgage loan applications for home improvement"
    NumMrtgAppsRefin = "Mortgage loan applications for refinancing"
    NumMrtgAppsMultifam = "Mortgage loan applications for multifamily dwellings"
    NumMrtgOrig = "Mortgage loans (all purposes)"
    NumMrtgOrigHomePurch = "Mortgage loans for home purchase"
    NumMrtgOrigHomeImprov = "Mortgage loans for home improvement"
    NumMrtgOrigRefin = "Mortgage loans for refinancing"
    NumMrtgOrigMultifam = "Mortgage loans for multifamily dwellings (all purposes)"
    MrtgOrigTotalDollarAmt = "Total dollar amount of mortgage loans (all purposes) ($)"
    MrtgOrigTotalDollarAmtHomePurch = "Total dollar amount of mortgage loans for home purchase ($)"
    MrtgOrigTotalDollarAmtHomeImprov = "Total dollar amount of mortgage loans for home improvement ($)"
    MrtgOrigTotalDollarAmtRefin = "Total dollar amount of mortgage loans for refinancing ($)"
    MrtgOrigTotalDollarAmtMultifam = "Total amount of mortgage loans for multifamily buildings ($) "
    MrtgOrigMedDollarAmtHomePurch = "Median amount of mortgage loans for home purchase ($)"
    MrtgOrigMedDollarAmtHomeImprov = "Median amount of mortgage loans for home improvement ($)"
    MrtgOrigMedDollarAmtRefin = "Median amount of mortgage loans for refinancing ($)"
    MrtgOrigMedDollarAmtMultifam = "Median amount of mortgage loans for multifamily dwellings ($)"
    NumMrtgOrigAsianPI = "Owner-occupied home purchase mortgage loans to Asians"
    NumMrtgOrigBlack = "Owner-occupied home purchase mortgage loans to Black borrowers"
    NumMrtgOrigHisp = "Owner-occupied home purchase mortgage loans to Hispanic borrowers"
    NumMrtgOrigWhite = "Owner-occupied home purchase mortgage loans to White borrowers"
    NumMrtgOrigAmerInd = "Owner-occ. home purchase mortgage loans to Native Americans"
    NumMrtgOrigOther = "Owner-occ. home purchase mortgage loans to other race borrowers"
    NumMrtgOrigRaceNotProvided = "Owner-occupied home purchase loans where borrower race is missing"
    NumMrtgOrigRaceNotApplic = "Owner-occupied home purchase loans to institutions"
    NumMrtgOrigMxd = "Owner-occupied home purchase loans to mixed race pair borrowers"
    NumMrtgOrigWithRace = "Owner-occupied home purchase loans where borrower race is known"
    NumMrtgOrigTotal = "Owner-occupied home purchase mortgage loans"
    MedianMrtgInc = "Median borrower income for owner-occupied home purchase loans"
    NumMrtgOrigLowInc = "Owner-occupied home purchase loans to low-income borrowers"
    NumMrtgOrigModInc = "Owner-occupied home purchase loans to middle-income borrowers"
    NumMrtgOrigHighInc = "Owner-occupied home purchase loans to high-income borrowers"
    NumMrtgOrigWithInc = "Owner-occupied home purchase loans with borrower income known"
    NumMrtgPurchDenial = "Denials of conventional home purchase loans "
    NumMrtgPurchDenialAsianPI = "Denials of conv. home purchase loans to Asian applicants"
    NumMrtgPurchDenialBlack = "Denials of conv. home purchase loans to Black applicants"
    NumMrtgPurchDenialHisp = "Denials of conv. home purchase loans to Hispanic applicants"
    NumMrtgPurchDenialWhite = "Denials of conv. home purchase loans to White applicants"
    NumMrtgPurchDenialAmerInd = "Denials of conv. home purch. loans to Native American applicants"
    NumMrtgPurchDenialMxd = "Denials of conv. purchase loans to mixed race pair applicants"
    NumMrtgPurchDenialOther = "Denials of conv. home purchase loans to other race applicants"
    NumMrtgPurchDenialNotProvided = "Denials of conv. home purchase loans to unknown race applicants"
    NumMrtgPurchDenialNotApplic = "Denials of conventional home purchase loans to institutions"
    NumMrtgPurchDenialLowInc = "Denials of conv. home purchase loans to low-income applicants"
    NumMrtgPurchDenialModInc = "Denials of conv. home purchase loans to middle-income applicants"
    NumMrtgPurchDenialHighInc = "Denials of conv. home purchase loans to high-income applicants"
    NumMrtgPurchDenialAsianPILowInc = "Denials of conv. purchase loans to low-income Asian applicants"
    NumMrtgPurchDenialBlackLowInc = "Denials of conv. purchase loans to low-income Black applicants"
    NumMrtgPurchDenialHispLowInc = "Denials of conv. purch. loans to low-income Hispanic applicants"
    NumMrtgPurchDenialWhiteLowInc = "Denials of conv. purchase loans to low-income White applicants"
    NumMrtgPurchDenialAmerIndLowInc = "Denials of conv. purch. loans to low-inc. Nat. American applicant"
    NumMrtgPurchDenialMxdLowInc = "Denials of conv. purchase loans to low-income mixed race pairs"
    NumMrtgPurchDenialOthLowInc = "Denials of conv. purch. loans to low-income other race applicants"
    NumMrtgPurchDenialAsianPIModInc = "Denials of conv. purch. loans to middle-income Asian applicants"
    NumMrtgPurchDenialBlackModInc = "Denials of conv. purch. loans to middle-income Black applicants"
    NumMrtgPurchDenialHispModInc = "Denials of conv. purch. loans to middle-inc. Hispanic applicants"
    NumMrtgPurchDenialWhiteModInc = "Denials of conv. purch. loans to middle-income White applicants"
    NumMrtgPurchDenialAmerIndModInc = "Denials of conv. purch. loans to middle-inc. Nat. Amer. applicant"
    NumMrtgPurchDenialMxdModInc = "Denials of conv. purchase loans to middle-income mixed race pairs"
    NumMrtgPurchDenialOthModInc = "Denials of conv. purch. loans to middle-inc. oth. race applicants"
    NumMrtgPurchDenialAsianPIHighInc = "Denials of conv. purchase loans to high-income Asian applicants"
    NumMrtgPurchDenialBlackHighInc = "Denials of conv. purchase loans to high-income Black applicants"
    NumMrtgPurchDenialHispHighInc = "Denials of conv. purchase loans to high-income Hispanic applicant"
    NumMrtgPurchDenialWhiteHighInc = "Denials of conv. purchase loans to high-income White applicants"
    NumMrtgPurchDenialAmerIndHighInc = "Denials of conv. purch. loans to high-inc. Nat. Amer. applicants"
    NumMrtgPurchDenialMxdHighInc = "Denials of conv. purch. loans to high-income mixed race pairs"
    NumMrtgPurchDenialOthHighInc = "Denials of conv. purch. loans to high-income other race applicant"
    NumMrtgPurchApps = "Conventional home purchase mortgage loan applications "
    NumMrtgPurchAppsAsianPI = "Conventional home purchase mortgage loan applications from Asians"
    NumMrtgPurchAppsBlack = "Conventional home purchase mortgage loan applications from Blacks"
    NumMrtgPurchAppsHisp = "Conventional home purchase loan applications from Hispanics"
    NumMrtgPurchAppsWhite = "Conventional home purchase mortgage loan applications from Whites"
    NumMrtgPurchAppsAmerInd = "Conv. home purchase loan applications from Native Americans"
    NumMrtgPurchAppsMxd = "Conv. home purchase loan applications from mixed race pairs"
    NumMrtgPurchAppsOth = "Conv. home purch. mortgage loan applications from other races"
    NumMrtgPurchAppsLowInc = "Conv. home purchase loan applications from low-income applicants"
    NumMrtgPurchAppsModInc = "Conv. purchase loan applications from middle-income applicants"
    NumMrtgPurchAppsHighInc = "Conv. home purchase loan applications from high-income applicants"
    NumMrtgPurchAppsAsianPILowInc = "Conv. home purchase loan applications from low-income Asians"
    NumMrtgPurchAppsBlackLowInc = "Conv. home purchase loan applications from low-income Blacks"
    NumMrtgPurchAppsHispLowInc = "Conv. home purchase loan applications from low-income Hispanics"
    NumMrtgPurchAppsWhiteLowInc = "Conv. home purchase loan applications from low-income Whites"
    NumMrtgPurchAppsAmerIndLowInc = "Conv. home purch. loan applications from low-income Nat. American"
    NumMrtgPurchAppsMxdLowInc = "Conv. purchase loan applications from low-income mixed race pairs"
    NumMrtgPurchAppsOthLowInc = "Conv. home purchase loan applications from low-income other races"
    NumMrtgPurchAppsAsianPIModInc = "Conv. home purchase loan applications from Middle-income Asians"
    NumMrtgPurchAppsBlackModInc = "Conv. home purchase loan applications from Middle-income Blacks"
    NumMrtgPurchAppsHispModInc = "Conv. purchase loan applications from Middle-income Hispanics"
    NumMrtgPurchAppsWhiteModInc = "Conv. home purchase loan applications from Middle-income Whites"
    NumMrtgPurchAppsAmerIndModInc = "Conv. purch. loan applications from Middle-income Nat. American"
    NumMrtgPurchAppsMxdModInc = "Conv. purch. loan applications from Middle-inc. mixed race pair"
    NumMrtgPurchAppsOthModInc = "Conv. purchase loan applications from Middle-income other race"
    NumMrtgPurchAppsAsianPIHighInc = "Conv. home purchase loan applications from high-income Asians"
    NumMrtgPurchAppsBlackHighInc = "Conv. home purchase loan applications from high-income Blacks"
    NumMrtgPurchAppsHispHighInc = "Conv. home purchase loan applications from high-income Hispanics"
    NumMrtgPurchAppsWhiteHighInc = "Conv. home purchase loan applications from high-income Whites"
    NumMrtgPurchAppsAmerIndHighInc = "Conv. purch. loan applications from high-income Native Americans"
    NumMrtgPurchAppsMxdHighInc = "Conv. purch. loan applications from high-income mixed race pairs"
    NumMrtgPurchAppsOthHighInc = "Conv. home purchase loan applications from high-income other race"
    NumSubprimeMrtgOrig = "Conventional mortgage loans by subprime lenders"
    NumSubprimeMrtgOrigHomePurch = "Conventional home purchase mortgage loans by subprime lenders"
    NumSubprimeMrtgOrigHomeImprov = "Conventional home improvement mortgage loans by subprime lenders"
    NumSubprimeMrtgOrigRefin = "Conventional refinancing mortgage loans by subprime lenders"
    NumSubprimeMrtgOrigMultifam = "Conv. multifamily mortgage loans by subprime lenders"
    NumSubprimeMrtgPurchAmerInd = "Conv. home purchase loans by subprime lenders to Nat. Americans"
    NumSubprimeMrtgPurchAsianPI = "Conv. home purchase loans by subprime lenders to Asians"
    NumSubprimeMrtgPurchBlack = "Conv. home purchase loans by subprime lenders to Blacks"
    NumSubprimeMrtgPurchHisp = "Conv. home purch. loans by subprime lenders to Hispanics"
    NumSubprimeMrtgPurchWhite = "Conv. home purchase loans by subprime lenders to Whites"
    NumSubprimeMrtgPurchOther = "Conv. home purchase loans by subprime lenders to other races"
    NumSubprimeMrtgPurchMxd = "Conv. home purchase loans by subprime lenders to mixed race pairs"
    NumSubprimeMrtgPurchNotProvided = "Conv. home purch. loans by subprime lenders where race is unknown"
    NumSubprimeMrtgPurchNotApplic = "Conv. home purchase loans by subprime lenders to institutions"
    NumSubprimeMrtgRefinAmerInd = "Conv. refinancing loans by subprime lenders to Native Americans"
    NumSubprimeMrtgRefinAsianPI = "Conv. refinancing loans by subprime lenders to Asians"
    NumSubprimeMrtgRefinBlack = "Conv. refinancing loans by subprime lenders to Blacks"
    NumSubprimeMrtgRefinHisp = "Conv. refinancing loans by subprime lenders to Hispanic "
    NumSubprimeMrtgRefinWhite = "Conv. refinancing loans by subprime lenders to Whites "
    NumSubprimeMrtgRefinOther = "Conv. refinancing loans by subprime lenders to other races "
    NumSubprimeMrtgRefinMxd = "Conv. refinancing loans by subprime lenders to mixed race pairs"
    NumSubprimeMrtgRefinNotProvided = "Conv. refinancing loans by subprime lenders with unknown race"
    NumSubprimeMrtgRefinNotApplic = "Conv. refinancing loans by subprime lenders to institutions"
    NumConvMrtgOrig = "Conventional mortgage loans"
    NumConvMrtgOrigHomePurch = "Conventional mortgage loans for home purchase"
    NumConvMrtgOrigHomeImprov = "Conventional mortgage loans for home improvement"
    NumConvMrtgOrigRefin = "Conventional mortgage loans for refinancing"
    NumConvMrtgOrigMultifam = "Conventional mortgage loans for multifamily dwellings"
    NumConvMrtgPurchAmerInd = "Conventional home purchase mortgage loans to Native Americans"
    NumConvMrtgPurchAsianPI = "Conventional home purchase mortgage loans to Asian borrowers"
    NumConvMrtgPurchBlack = "Conventional home purchase mortgage loans to Black borrowers"
    NumConvMrtgPurchHisp = "Conventional home purchase mortgage loans to Hispanic borrowers"
    NumConvMrtgPurchWhite = "Conventional home purchase mortgage loans to White borrowers"
    NumConvMrtgPurchOther = "Conventional home purchase mortgage loans to other race borrowers"
    NumConvMrtgPurchMxd = "Conv. home purchase mortgage loans to mixed race pair borrowers"
    NumConvMrtgRefinAmerInd = "Conventional refinancing mortgage loans to Native Americans"
    NumConvMrtgRefinAsianPI = "Conventional refinancing mortgage loans to Asian borrowers"
    NumConvMrtgRefinBlack = "Conventional refinancing mortgage loans to Black borrowers"
    NumConvMrtgRefinHisp = "Conventional refinancing mortgage loans to Hispanic borrowers"
    NumConvMrtgRefinWhite = "Conventional refinancing mortgage loans to White borrowers"
    NumConvMrtgRefinOther = "Conventional refinancing mortgage loans to other race borrowers"
    NumConvMrtgRefinMxd = "Conventional refinancing mortgage loans to mixed race pairs"
    PctMrtgAppsHomePurch = "Pct. of mortgage applications for home purchase"
    PctMrtgAppsHomeImprov = "Pct. of mortgage applications for home improvement"
    PctMrtgAppsRefin = "Pct. of mortgage applications for refinancing"
    PctMrtgAppsMultifam = "Pct. of mortgage applications for multifamily dwellings"
    PctMrtgOrigHomePurch = "Pct. of mortgage loans for home purchase"
    PctMrtgOrigHomeImprov = "Pct. of mortgage loans for home improvement"
    PctMrtgOrigRefin = "Pct. of mortgage loans for refinancing"
    PctMrtgOrigMultifam = "Pct. of mortgage loans for multifamily dwellings"
    NumMrtgOrigHomePurchPerUnit = "Home purchase mortgage loans per 1,000 housing units"
    NumMrtgOrigHomeImprovPerUnit = "Home improvement mortgage loans per 1,000 housing units"
    NumMrtgOrigRefinPerUnit = "Refinancing mortgage loans per 1,000 housing units"
    NumMrtgOrigMultifamPerUnit = "Multifamily mortgage loans per 1,000 housing units"
    MrtgOrigAvgDollarAmtHomePurch = "Average dollar amount of mortgage loans for home purchase ($)"
    MrtgOrigAvgDollarAmtHomeImprov = "Average dollar amount of mortgage loans for home improvement ($)"
    MrtgOrigAvgDollarAmtRefin = "Average dollar amount of mortgage loans for refinancing ($)"
    MrtgOrigAvgDollarAmtMultifam = "Average amount of mortgage loans for multifamily dwellings ($)"
    AmtMrtgOrigHomePurchPerUnit = "Total dollar amount of home purch. loans per 1,000 housing units"
    AmtMrtgOrigHomeImprovPerUnit = "Total dollar amount of home impr. loans per 1,000 housing units"
    AmtMrtgOrigRefinPerUnit = "Total dollar amount of refinancing loans per 1,000 housing units"
    AmtMrtgOrigMultifamPerUnit = "Total dollar amount of multifamily loans per 1,000 housing units"
    PctMrtgOrigAsianPI = "Pct. of owner-occupied home purchase mortgages to Asians"
    PctMrtgOrigBlack = "Pct. of owner-occupied home purchase mortgages to Blacks"
    PctMrtgOrigHisp = "Pct. of owner-occupied home purchase mortgages to Hispanics"
    PctMrtgOrigWhite = "Pct. of owner-occupied home purchase mortgages to Whites"
    PctMrtgOrigAmerInd = "Pct. of owner-occupied home purchase mortgages to Nat. Americans"
    PctMrtgOrigOther = "Pct. of owner-occupied home purchase mortgages to other races"
    PctMrtgOrigMxd = "Pct. of owner-occupied home purchase mortgage to mixed race pairs"
    PctMrtgOrigRaceNotProvided = "Pct. of owner-occupied home purchase mortgages with race unknown"
    PctMrtgOrigLowInc = "Pct. of owner-occ. home purchase loans to low-income borrowers"
    PctMrtgOrigModInc = "Pct. of owner-occ. home purchase loans to Middle-inc. borrowers"
    PctMrtgOrigHighInc = "Pct. of owner-occ. home purchase loans to high-income borrowers"
    PctMrtgOrigIncNotProvided = "Pct. of owner-occ. home purch. loans without borrower's income"
    MedianMrtgIncToTractInc = "Median income of the home purch. borrowers / Median tract income"
    PctMrtgPurchDenial = "Denial rate of conventional home purchase loans "
    PctMrtgPurchDenialAsianPI = "Denial rate of conv. home purchase loans to Asian applicants"
    PctMrtgPurchDenialBlack = "Denial rate of conv. home purchase loans to Black applicants"
    PctMrtgPurchDenialHisp = "Denial rate of conv. home purchase loans to Hispanic applicants"
    PctMrtgPurchDenialWhite = "Denial rate of conv. home purchase loans to White applicants"
    PctMrtgPurchDenialAmerInd = "Denial rate of conv. home purchase loans to Native Americans"
    PctMrtgPurchDenialMxd = "Denial rate of conv. purchase loans to mixed race pair applicants"
    PctMrtgPurchDenialOth = "Denial rate of conv. purchase loans to other race applicants"
    PctMrtgPurchDenialLowInc = "Denial rate of conv. purchase loans to low-income applicants"
    PctMrtgPurchDenialModInc = "Denial rate of conv. Purch. loans to middle-income applicants"
    PctMrtgPurchDenialHighInc = "Denial rate of conv. purch. loans to high-income applicants"
    PctMrtgPurchDenialAsianPILowInc = "Denial rate of conv. purchase loans to low-income Asians"
    PctMrtgPurchDenialBlackLowInc = "Denial rate of conv. purchase loans to low-income Blacks"
    PctMrtgPurchDenialHispLowInc = "Denial rate of conv. purchase loans to low-income Hispanics"
    PctMrtgPurchDenialWhiteLowInc = "Denial rate of conv. purchase loans to low-income Whites"
    PctMrtgPurchDenialAmerIndLowInc = "Denial rate of conv. purch. loans to low-income Nat. Americans"
    PctMrtgPurchDenialMxdLowInc = "Denial rate of conv. purch. loans to low-income mixed race pair"
    PctMrtgPurchDenialOthLowInc = "Denial rate of conv. purchase loans to low-income other race"
    PctMrtgPurchDenialAsianPIModInc = "Denial rate of conv. purchase loans to middle-income Asians"
    PctMrtgPurchDenialBlackModInc = "Denial rate of conv. purchase loans to middle-income Blacks"
    PctMrtgPurchDenialHispModInc = "Denial rate of conv. purch. loans to middle-income Hispanics"
    PctMrtgPurchDenialWhiteModInc = "Denial rate of conv. purchase loans to middle-income Whites"
    PctMrtgPurchDenialAmerIndModInc = "Denial rate of conv. purch. loans to middle-income Nat. Americans"
    PctMrtgPurchDenialMxdModInc = "Denial rate of conv. purch. loans to middle-inc. mixed race pair"
    PctMrtgPurchDenialOthModInc = "Denial rate of conv. purchase loans to middle-income other race"
    PctMrtgPurchDenialAsianPIHighInc = "Denial rate of conv. purchase loans to high-income Asians"
    PctMrtgPurchDenialBlackHighInc = "Denial rate of conv. purchase loans to high-income Blacks"
    PctMrtgPurchDenialHispHighInc = "Denial rate of conv. purchase loans to high-income Hispanics"
    PctMrtgPurchDenialWhiteHighInc = "Denial rate of conv. purchase loans to high-income Whites"
    PctMrtgPurchDenialAmerIndHighInc = "Denial rate of conv. purch. loans to high-income Nat. Americans"
    PctMrtgPurchDenialMxdHighInc = "Denial rate of conv. purchase loans to high-inc. mixed race pair"
    PctMrtgPurchDenialOthHighInc = "Denial rate of conv. purchase loans to high-income other race"
    PctSubprimeMrtgOrig = "Pct. of conventional mortgage loans by subprime lenders"
    PctSubprimeMrtgOrigHomePurch = "Pct. of conv. home purchase mortgage loans by subprime lenders"
    PctSubprimeMrtgOrigHomeImprov = "Pct. of conv. home improvement mortgage loans by subprime lenders"
    PctSubprimeMrtgOrigRefin = "Pct. of conv. refinancing mortgage loans by subprime lenders"
    PctSubprimeMrtgOrigMultifam = "Pct. of conv. multifamily mortgage loans by subprime lenders"
    PctSubprimeMrtgPurchAmerInd = "Pct. of conv. purch. loans to Nat. Americans by subprime lenders"
    PctSubprimeMrtgPurchAsianPI = "Pct. of conv. home purchase loans to Asians by subprime lenders"
    PctSubprimeMrtgPurchBlack = "Pct. of conv. home purchase loans to Blacks by subprime lenders"
    PctSubprimeMrtgPurchHisp = "Pct. of conv. purchase loans to Hispanics by subprime lenders"
    PctSubprimeMrtgPurchWhite = "Pct. of conv. home purchase loans to Whites by subprime lenders"
    PctSubprimeMrtgPurchMxd = "Pct. of conv. purch. loans to mixed race pair by subprime lenders"
    PctSubprimeMrtgPurchOth = "Pct. of conv. purchase loans to other races by subprime lenders"
    PctSubprimeMrtgRefinAmerInd = "Pct. of conv. refin. loans to Nat. Amer. by subprime lenders"
    PctSubprimeMrtgRefinAsianPI = "Pct. of conv. refinancing loans to Asians by subprime lenders"
    PctSubprimeMrtgRefinBlack = "Pct. of conv. refinancing loans to Blacks by subprime lenders"
    PctSubprimeMrtgRefinHisp = "Pct. of conv. refin. loans to Hispanics by subprime lenders"
    PctSubprimeMrtgRefinWhite = "Pct. of conv. refinancing loans to Whites by subprime lenders"
    PctSubprimeMrtgRefinMxd = "Pct. of conv. refin. loans to mixed race pair by subprime lenders"
    PctSubprimeMrtgRefinOth = "Pct. of conv. refin. loans to other races by subprime lenders"
    PctConvMrtgOrigHomePurch = "Pct. of home purchase mortgage loans that are conventional "
    PctConvMrtgOrigRefin = "Pct. of refinancing mortgage loans that are conventional "
    NumHsngUnits5plusFam = "Number of housing units, 5 or more families (HMDA def.)"
    MedianHshldIncome = "Median HH income in tract in 2000 (from U.S. Census)"
    Year = "Year of data"
    STATECD = "State FIPS code"
    STUSAB = "State Abbreviation"
    UCOUNTY = "Unique County Code, SSCCC"
    UPLACE98 = "Unique FIPS place code, SSPPPPP"
    REGION = "Census Region"
    DIVIS = "Census Division"
    MSAPMA99 = "Combined Primary Metropolitan Statistical Area/Metropolitan Statistical Area fields (1999)"
    CMSA99 = "Consolidated Metropolitan Statistical Area (1999)"
    MSACMA99 = "Consolidated Metropolitan Statistical Area/ Metropolitan Statistical Area  (1999)"
    PMSA99 = "Primary Metropolitan Statistical Area (1999)"
    NECMA99 = "New England County Metropolitan Area (1999)"
    ZCTA500 = "Zip code tabulation area (5 digit)"
    Geo2000 = "Census Tract Identifier, SSCCCTTTTTT"
    metro03 = "Metropolitan/micropolitan statistical area (2003)"
  ;

%mend Hmda_nnip_labels;

/** End Macro Definition **/

