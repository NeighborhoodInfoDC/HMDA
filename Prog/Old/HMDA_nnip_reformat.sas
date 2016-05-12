/**************************************************************************
 Program:  HMDA_nnip_reformat.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/25/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Autocall macro to reformat HMDA tract summary file
 from NNIP for &YEAR and upload to Alpha

 Modifications:
**************************************************************************/

/** Macro Hmda_nnip_reformat - Start Definition **/

%macro Hmda_nnip_reformat( 
  year=, 
  path=e:\sum&year._2_was.zip, 
  file=sum&year._2_was,
  upload=N,
  revisions=New file. );

   libname Hmda&year "&path";
   
   data Hmda_sum_&year._was;

     set Hmda&year..&file (drop=year country geoid);

     ** Need to recreate YEAR var because in some files it is numeric,
     ** and others it is character.;
     
     year = &year;

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
        ZCTA500=ZCTA500;
      
      format _all_;
      informat _all_;
      
      /*
      label 
        year = 'Year of data'
        CMSA99 = "Consolidated Metropolitan Statistical Area (1999)"
        DIVIS = "Census division"
        MSACMA99 = "Metropolitan Statistical Area/Consolidated Metropolitan Statistical Area (1999)"
        MSAPMA99 = "Metropolitan Statistical Area/Primary Metropolitan Statistical Area (1999)"
        NECMA99 = "New England County Metropolitan Area (1999)"
        PMSA99 = "Primary Metropolitan Statistical Area (1999)"
        REGION = "Census region"
        STATECD = "State (FIPS)"
        STUSAB = "State abbreviation"
        UCOUNTY = "Full county ID:  ssccc"
        UPLACE98 = "Full FIPS place ID:  ssppppp (1998)"
        ZCTA500 = "Zip code tabulation area (5 digit)"
        metro03 = "Metropolitan/micropolitan statistical area (2003)"
      ;
      */
      
  run;
  
proc datasets library=work memtype=(data) nolist;
  modify Hmda_sum_&year._was;
    %Hmda_nnip_labels
  
quit;

  proc sort data=Hmda_sum_&year._was
    out=Hmda.Hmda_sum_&year._was 
          (label="NNIP HMDA tract-level summary files, &year, Washington, D.C. region");
    by geo2000;
  
  %File_info( data=Hmda.Hmda_sum_&year._was, printobs=5, freqvars=STATECD )
  
  %if %upcase( &upload ) = Y %then %do;
  
    %syslput year=&year;
    %syslput revisions=&revisions;
    
    rsubmit;

    proc upload status=no
      inlib=Hmda 
      outlib=Hmda memtype=(data);
      select Hmda_sum_&year._was;

    run;
    
    x "purge [dcdata.hmda.data]Hmda_sum_&year._was.*";
      
    %Dc_update_meta_file(
      ds_lib=Hmda,
      ds_name=Hmda_sum_&year._was,
      creator_process=Hmda.Hmda_sum_&year._was,
      restrictions=None,
      revisions=&revisions
    )
    
    run;
    
    endrsubmit;

  %end;

%mend Hmda_nnip_reformat;

/** End Macro Definition **/

