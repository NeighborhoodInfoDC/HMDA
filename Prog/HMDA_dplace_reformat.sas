/**************************************************************************
 Program:  HMDA_dplace_reformat.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/25/05
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Autocall macro to reformat HMDA tract summary file
 from DataPlace for &YEAR and upload to Alpha

 Modifications:
**************************************************************************/

/** Macro Hmda_dplace_reformat - Start Definition **/

%macro Hmda_dplace_reformat( 
  year=, 
  path=e:\sum&year._2_was.zip, 
  file=sum&year._2_was,
  upload=N,
  revisions=New file. );

   libname Hmda&year "&path";
   
   %let yr = %substr( &year, 3, 2 );
   
   data Hmda_sum_&year._was;

     set HMDA.HMDATR&yr._was (drop=year);
     where stfid =: "11";

     if stfid =: '11' and put( stfid, $geo00v. ) = '' then do;
       %warn_put( msg='Invalid tract no. ' stfid= )
     end;
       
     ** Need to recreate YEAR var because in some files it is numeric,
     ** and others it is character.;
     
     year = &year;

     rename
       stfid = geo2000
       NumMrtgOrigHomeImprov1_4mPerUnit=NumMrtgOrigHomeImprov1_4mPU
       NumSubprimeConvOrigHomePurch=NumSubprimeConvOrigHomePur
       PctSubprimeConvOrigHomePurch=PctSubprimeConvOrigHomePur
     ;
     
     format _all_;
     informat _all_;
     
     keep 
       statecd
       stfid 
       year 
       NumMrtgOrigHomePurch1_4m
       NumHsngUnits1_4Fam
       MedianMrtgInc1_4m
       NumSubprimeConvOrig
       NumConvMrtgOrig
       NumMrtgOrigHomeImprov1_4mPerUnit
       PctSubprimeConvOrig
       NumSubprimeConvOrigHomePurch
       PctSubprimeConvOrigHomePurch
       NumConvMrtgOrigHomePurch
     ;
     
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

/*
proc datasets library=work memtype=(data) nolist;
  modify Hmda_sum_&year._was;
    %Hmda_dplace_labels
  
quit;
*/

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

%mend Hmda_dplace_reformat;

/** End Macro Definition **/

