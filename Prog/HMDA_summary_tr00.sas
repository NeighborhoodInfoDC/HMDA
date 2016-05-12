/**************************************************************************
 Program:  HMDA_summary_tr00.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/23/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Compile summary data files provided by NNIP (Kathy).
 Data sets are on CD.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( HMDA )

%let cd = E:;

/** Macro Read_one - Start Definition **/

%macro Read_all( year1, year2 );

  %do i = &year1 %to &year2;
    libname cd&i "&cd\sum&i._2_was.zip";
  %end;
  
  data Hmda_summary_tr00;
  
    set 
      %do i = &year1 %to &year2;
        cd&i..sum&i._2_was (drop=year in=in&i)
      %end;
    ;
    
    where STATECD = '11';
    
    %do i = &year1 %to &year2;
      if in&i then year = &i;
    %end;

    rename
      stfid = geo2000
      NHU1_4Fa=NumHsngUnits1_4Fam
      NMrAp=NumMrtgApps
      NMrApHP=NumMrtgAppsHomePurch
      NMrApHI=NumMrtgAppsHomeImprov
      NMrApR=NumMrtgAppsRefin
      NMrApMu=NumMrtgAppsMultifam
      NMrOr=NumMrtgOrig
      NMrOrHP=NumMrtgOrigHomePurch
      NMrOrHI=NumMrtgOrigHomeImprov
      NMrOrR=NumMrtgOrigRefin
      NMrOrMu=NumMrtgOrigMultifam
      MOrDol=MrtgOrigTotalDollarAmt
      MOrDolHP=MrtgOrigTotalDollarAmtHomePurch
      MOrDolHI=MrtgOrigTotalDollarAmtHomeImprov
      MOrDolR=MrtgOrigTotalDollarAmtRefin
      MOrDolMu=MrtgOrigTotalDollarAmtMultifam
      MOMDolHP=MrtgOrigMedDollarAmtHomePurch
      MOMDolHI=MrtgOrigMedDollarAmtHomeImprov
      MOMDolR=MrtgOrigMedDollarAmtRefin
      MOMDolMu=MrtgOrigMedDollarAmtMultifam
      NMrOrAs=NumMrtgOrigAsianPI
      NMrOrB=NumMrtgOrigBlack
      NMrOrH=NumMrtgOrigHisp
      NMrOrW=NumMrtgOrigWhite
      NMrOrAI=NumMrtgOrigAmerInd
      NMrOrOt=NumMrtgOrigOther
      NMrOrNP=NumMrtgOrigRaceNotProvided
      NMrOrNA=NumMrtgOrigRaceNotApplic
      NMrOrMix=NumMrtgOrigMxd
      NMrOrWR=NumMrtgOrigWithRace
      NMrOrTot=NumMrtgOrigTotal
      MedMrInc=MedianMrtgInc
      NMrOrLIn=NumMrtgOrigLowInc
      NMrOrMIn=NumMrtgOrigModInc
      NMrOrHIn=NumMrtgOrigHighInc
      NMrOrWIn=NumMrtgOrigWithInc
      NMrPrDe=NumMrtgPurchDenial
      NMrPDeAs=NumMrtgPurchDenialAsianPI
      NMrPDeB=NumMrtgPurchDenialBlack
      NMrPDeH=NumMrtgPurchDenialHisp
      NMrPDeW=NumMrtgPurchDenialWhite
      NMrPDeAI=NumMrtgPurchDenialAmerInd
      NMrPDeMx=NumMrtgPurchDenialMxd
      NMrPDeOt=NumMrtgPurchDenialOther
      NMrPDeNP=NumMrtgPurchDenialNotProvided
      NMrPDeNA=NumMrtgPurchDenialNotApplic
      NMrPDeLI=NumMrtgPurchDenialLowInc
      NMrPDeMI=NumMrtgPurchDenialModInc
      NMrPDeHI=NumMrtgPurchDenialHighInc
      PDeAsLI=NumMrtgPurchDenialAsianPILowInc
      PDeBLI=NumMrtgPurchDenialBlackLowInc
      PDeHLI=NumMrtgPurchDenialHispLowInc
      PDeWLI=NumMrtgPurchDenialWhiteLowInc
      PDeAILI=NumMrtgPurchDenialAmerIndLowInc
      PDeMxLI=NumMrtgPurchDenialMxdLowInc
      PDeOtLI=NumMrtgPurchDenialOthLowInc
      PDeAsMI=NumMrtgPurchDenialAsianPIModInc
      PDeBMI=NumMrtgPurchDenialBlackModInc
      PDeHMI=NumMrtgPurchDenialHispModInc
      PDeWMI=NumMrtgPurchDenialWhiteModInc
      PDeAIMI=NumMrtgPurchDenialAmerIndModInc
      PDeMxMI=NumMrtgPurchDenialMxdModInc
      PDeOtMI=NumMrtgPurchDenialOthModInc
      PDeAsHI=NumMrtgPurchDenialAsianPIHighInc
      PDeBHI=NumMrtgPurchDenialBlackHighInc
      PDeHHI=NumMrtgPurchDenialHispHighInc
      PDeWHI=NumMrtgPurchDenialWhiteHighInc
      PDeAIHI=NumMrtgPurchDenialAmerIndHighInc
      PDeMxHI=NumMrtgPurchDenialMxdHighInc
      PDeOtHI=NumMrtgPurchDenialOthHighInc
      NMPuAp=NumMrtgPurchApps
      NMPuApAs=NumMrtgPurchAppsAsianPI
      NMPuApB=NumMrtgPurchAppsBlack
      NMPuApH=NumMrtgPurchAppsHisp
      NMPuApW=NumMrtgPurchAppsWhite
      NMPuApAI=NumMrtgPurchAppsAmerInd
      NMPuApMx=NumMrtgPurchAppsMxd
      NMPuApOt=NumMrtgPurchAppsOth
      NMPuApLI=NumMrtgPurchAppsLowInc
      NMPuApMI=NumMrtgPurchAppsModInc
      NMPuApHI=NumMrtgPurchAppsHighInc
      PApAsLI=NumMrtgPurchAppsAsianPILowInc
      PApBLI=NumMrtgPurchAppsBlackLowInc
      PApHLI=NumMrtgPurchAppsHispLowInc
      PApWLI=NumMrtgPurchAppsWhiteLowInc
      PApAILI=NumMrtgPurchAppsAmerIndLowInc
      PApMxLI=NumMrtgPurchAppsMxdLowInc
      PApOtLI=NumMrtgPurchAppsOthLowInc
      PApAsMI=NumMrtgPurchAppsAsianPIModInc
      PApBMI=NumMrtgPurchAppsBlackModInc
      PApHMI=NumMrtgPurchAppsHispModInc
      PApWMI=NumMrtgPurchAppsWhiteModInc
      PApAIMI=NumMrtgPurchAppsAmerIndModInc
      PApMxMI=NumMrtgPurchAppsMxdModInc
      PApOtMI=NumMrtgPurchAppsOthModInc
      PApAsHI=NumMrtgPurchAppsAsianPIHighInc
      PApBHI=NumMrtgPurchAppsBlackHighInc
      PApHHI=NumMrtgPurchAppsHispHighInc
      PApWHI=NumMrtgPurchAppsWhiteHighInc
      PApAIHI=NumMrtgPurchAppsAmerIndHighInc
      PApMxHI=NumMrtgPurchAppsMxdHighInc
      PApOtHI=NumMrtgPurchAppsOthHighInc
      NSubMrOr=NumSubprimeMrtgOrig
      NSMrOrHP=NumSubprimeMrtgOrigHomePurch
      NSMrOrHI=NumSubprimeMrtgOrigHomeImprov
      NSMrOrR=NumSubprimeMrtgOrigRefin
      NSMrOrMu=NumSubprimeMrtgOrigMultifam
      NSMrPuAI=NumSubprimeMrtgPurchAmerInd
      NSMrPuAs=NumSubprimeMrtgPurchAsianPI
      NSMrPuB=NumSubprimeMrtgPurchBlack
      NSMrPuH=NumSubprimeMrtgPurchHisp
      NSMrPuW=NumSubprimeMrtgPurchWhite
      NSMrPuOt=NumSubprimeMrtgPurchOther
      NSMrPuMx=NumSubprimeMrtgPurchMxd
      NSMrPuNP=NumSubprimeMrtgPurchNotProvided
      NSMrPuNA=NumSubprimeMrtgPurchNotApplic
      NSMrRAI=NumSubprimeMrtgRefinAmerInd
      NSMrRAs=NumSubprimeMrtgRefinAsianPI
      NSMrRB=NumSubprimeMrtgRefinBlack
      NSMrRH=NumSubprimeMrtgRefinHisp
      NSMrRW=NumSubprimeMrtgRefinWhite
      NSMrROt=NumSubprimeMrtgRefinOther
      NSMrRMx=NumSubprimeMrtgRefinMxd
      NSMrRNP=NumSubprimeMrtgRefinNotProvided
      NSMrRNA=NumSubprimeMrtgRefinNotApplic
      NConMrOr=NumConvMrtgOrig
      NCMrOrHP=NumConvMrtgOrigHomePurch
      NCMrOrHI=NumConvMrtgOrigHomeImprov
      NCMrOrR=NumConvMrtgOrigRefin
      NCMrOrMu=NumConvMrtgOrigMultifam
      NCMrPuAI=NumConvMrtgPurchAmerInd
      NCMrPuAs=NumConvMrtgPurchAsianPI
      NCMrPuB=NumConvMrtgPurchBlack
      NCMrPuH=NumConvMrtgPurchHisp
      NCMrPuW=NumConvMrtgPurchWhite
      NCMrPuOt=NumConvMrtgPurchOther
      NCMrPuMx=NumConvMrtgPurchMxd
      NCMrRAI=NumConvMrtgRefinAmerInd
      NCMrRAs=NumConvMrtgRefinAsianPI
      NCMrRB=NumConvMrtgRefinBlack
      NCMrRH=NumConvMrtgRefinHisp
      NCMrRW=NumConvMrtgRefinWhite
      NCMrROt=NumConvMrtgRefinOther
      NCMrRMx=NumConvMrtgRefinMxd
      PMrApHP=PctMrtgAppsHomePurch
      PMrApHI=PctMrtgAppsHomeImprov
      PMrApR=PctMrtgAppsRefin
      PMrApMu=PctMrtgAppsMultifam
      PMrOrHP=PctMrtgOrigHomePurch
      PMrOrHI=PctMrtgOrigHomeImprov
      PMrOrR=PctMrtgOrigRefin
      PMrOrMu=PctMrtgOrigMultifam
      NMrOrHPU=NumMrtgOrigHomePurchPerUnit
      NMrOrHIU=NumMrtgOrigHomeImprovPerUnit
      NMrOrRU=NumMrtgOrigRefinPerUnit
      NMrOrMuU=NumMrtgOrigMultifamPerUnit
      MrOrAvHP=MrtgOrigAvgDollarAmtHomePurch
      MrOrAvHI=MrtgOrigAvgDollarAmtHomeImprov
      MrOrAvR=MrtgOrigAvgDollarAmtRefin
      MrOrAvMu=MrtgOrigAvgDollarAmtMultifam
      AmtHPU=AmtMrtgOrigHomePurchPerUnit
      AmtHIU=AmtMrtgOrigHomeImprovPerUnit
      AmtRU=AmtMrtgOrigRefinPerUnit
      AmtMuU=AmtMrtgOrigMultifamPerUnit
      PMrOrAs=PctMrtgOrigAsianPI
      PMrOrB=PctMrtgOrigBlack
      PMrOrH=PctMrtgOrigHisp
      PMrOrW=PctMrtgOrigWhite
      PMrOrAI=PctMrtgOrigAmerInd
      PMrOrOt=PctMrtgOrigOther
      PMrOrMx=PctMrtgOrigMxd
      PMrOrNP=PctMrtgOrigRaceNotProvided
      PMrOrLIn=PctMrtgOrigLowInc
      PMrOrMIn=PctMrtgOrigModInc
      PMrOrHIn=PctMrtgOrigHighInc
      PMrOrINP=PctMrtgOrigIncNotProvided
      MedIncTr=MedianMrtgIncToTractInc
      PMrPuDe=PctMrtgPurchDenial
      PMrPuDAs=PctMrtgPurchDenialAsianPI
      PMrPuDB=PctMrtgPurchDenialBlack
      PMrPuDH=PctMrtgPurchDenialHisp
      PMrPuDW=PctMrtgPurchDenialWhite
      PMrPuDAI=PctMrtgPurchDenialAmerInd
      PMrPuDMx=PctMrtgPurchDenialMxd
      PMrPuDOt=PctMrtgPurchDenialOth
      PMrPuDLI=PctMrtgPurchDenialLowInc
      PMrPuDMI=PctMrtgPurchDenialModInc
      PMrPuDHI=PctMrtgPurchDenialHighInc
      PMPDAsLI=PctMrtgPurchDenialAsianPILowInc
      PMPDBLI=PctMrtgPurchDenialBlackLowInc
      PMPDHLI=PctMrtgPurchDenialHispLowInc
      PMPDWLI=PctMrtgPurchDenialWhiteLowInc
      PMPDAILI=PctMrtgPurchDenialAmerIndLowInc
      PMPDMxLI=PctMrtgPurchDenialMxdLowInc
      PMPDOtLI=PctMrtgPurchDenialOthLowInc
      PMPDAsMI=PctMrtgPurchDenialAsianPIModInc
      PMPDBMI=PctMrtgPurchDenialBlackModInc
      PMPDHMI=PctMrtgPurchDenialHispModInc
      PMPDWMI=PctMrtgPurchDenialWhiteModInc
      PMPDAIMI=PctMrtgPurchDenialAmerIndModInc
      PMPDMxMI=PctMrtgPurchDenialMxdModInc
      PMPDOtMI=PctMrtgPurchDenialOthModInc
      PMPDAsHI=PctMrtgPurchDenialAsianPIHighInc
      PMPDBHI=PctMrtgPurchDenialBlackHighInc
      PMPDHHI=PctMrtgPurchDenialHispHighInc
      PMPDWHI=PctMrtgPurchDenialWhiteHighInc
      PMPDAIHI=PctMrtgPurchDenialAmerIndHighInc
      PMPDMxHI=PctMrtgPurchDenialMxdHighInc
      PMPDOtHI=PctMrtgPurchDenialOthHighInc
      PSubMrOr=PctSubprimeMrtgOrig
      PSMrOrHP=PctSubprimeMrtgOrigHomePurch
      PSMrOrHI=PctSubprimeMrtgOrigHomeImprov
      PSMrOrR=PctSubprimeMrtgOrigRefin
      PSMrOrMu=PctSubprimeMrtgOrigMultifam
      PSMrPuAI=PctSubprimeMrtgPurchAmerInd
      PSMrPuAs=PctSubprimeMrtgPurchAsianPI
      PSMrPuB=PctSubprimeMrtgPurchBlack
      PSMrPuH=PctSubprimeMrtgPurchHisp
      PSMrPuW=PctSubprimeMrtgPurchWhite
      PSMrPuMx=PctSubprimeMrtgPurchMxd
      PSMrPuOt=PctSubprimeMrtgPurchOth
      PSMrRAI=PctSubprimeMrtgRefinAmerInd
      PSMrRAs=PctSubprimeMrtgRefinAsianPI
      PSMrRB=PctSubprimeMrtgRefinBlack
      PSMrRH=PctSubprimeMrtgRefinHisp
      PSMrRW=PctSubprimeMrtgRefinWhite
      PSMrRMx=PctSubprimeMrtgRefinMxd
      PSMrROt=PctSubprimeMrtgRefinOth
      PCMrOrHP=PctConvMrtgOrigHomePurch
      PCMrOrR=PctConvMrtgOrigRefin
      NumUnits5=NumHsngUnits5plusFam
      Year=Year
      STATECD=STATECD
      STUSAB=STUSAB
      UCOUNTY=UCOUNTY
      UPLACE98=UPLACE98
      REGION=REGION
      DIVIS=DIVIS
      MSAPMA99=MSAPMA99
      CMSA99=CMSA99
      MSACMA99=MSACMA99
      PMSA99=PMSA99
      NECMA99=NECMA99
      ZCTA500=ZCTA500
      GEOID=GEOSCALEID
      COUNTRY=COUNTRY;
    
    format _all_;
    informat _all_;
    
    label year = 'Year of data';
    
  run;
  
  proc sort data=Hmda_summary_tr00
    out=Hmda.Hmda_summary_tr00 (label="HMDA summary files, &year1 to &year2, DC");
    by geo2000 year;
  
  %File_info( data=Hmda.Hmda_summary_tr00, freqvars=year )

%mend Read_all;

/** End Macro Definition **/


%Read_all( 1995, 2003 )

run;
