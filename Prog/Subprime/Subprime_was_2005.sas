/**************************************************************************
 Program:  Subprime_was_2005.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/16/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Create subprime lending profiles for cities/counties
 in Washington, D.C., region, 2005.

 NB: ZIP MAGIC must be enabled before this program is run.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%let rpt_title = Spring 2007;

%let rpt_yr = 2005;

%let start_yr = 1997;
%let end_yr = 2005;

%let rpt_path = &_dcdata_path\Hmda\Prog;
%let rpt_file = Subprime_was_&rpt_yr;
%let rpt_xls  = &rpt_file..xls;
%let map_file = &rpt_file;

%let BLANK = '09'x;    ** Blank character for DDE output **;

%fdate()


/** Macro Write_dde - Write data to workbook using DDE **/

%macro Write_dde_yr( sheet=, range=, data=, id=, var=, fopt=notab, start_yr=, end_yr= );

  filename xlsFile dde "excel|&rpt_path\[&rpt_xls]&sheet!&range" lrecl=2000 &fopt;

  data _null_;

    set &data;
    
    file xlsFile;
    
    %*put &var;
    
    ** Area ID **;
    put ucounty $10. '09'x @;
    put ucounty $cnty99f. '09'x @;
    put &BLANK @;
    
    %let i = 1;
    %let v = %scan( &var, &i );
    
    %do %while ( &v ~= );
      %do year = &start_yr %to &end_yr;
        put &v._&year '09'x @;
      %end;

      *** TEMPORARY SKIP 10TH YEAR ***;
      PUT &BLANK @;
    
      %let i = %eval( &i + 1 );
      %let v = %scan( &var, &i );
    %end;
    
    put;
    
  run;

  filename xlsFile clear;

%mend Write_dde_yr;

/** End Macro Definition **/



/** Macro Compile_data - Compile data sets across multiple years **/

%macro Compile_data( start_yr=, end_yr= );

  %do year = &start_yr %to &end_yr;

    %let shyear = %substr( &year, 3, 2 );
    
    libname hmdatr&shyear "D:\DCData\Libraries\HMDA\Data\HMDATR&shyear._was.zip";
      
  %end;

  *options obs=10;

  ***** TEMPORARY 2005 FILE ADDING SUBPRIME DATA *****;

  proc sort data=hmdatr05.hmdatr05_was out=in_hmdatr05_was;
    by stfid;

  data Hmdatr05_was;

    merge
      in_hmdatr05_was 
        (where=(geoscaleid="1")
         drop=NumSubprimeConvOrigHomePurch numsubprimeconvorigrefin
         rename=(stfid=geo2000)
         in=in1)
        hmda.subprime05tr_was (keep=geo2000 NumSubprimeConvOrigHomePurch numsubprimeconvorigrefin);
    by geo2000;
    
    if in1;
    
    if missing( NumSubprimeConvOrigHomePurch ) then NumSubprimeConvOrigHomePurch = 0;
    if missing( numsubprimeconvorigrefin ) then numsubprimeconvorigrefin = 0;

  run;

  options mprint symbolgen mlogic;

  data Subprime_was_tr;

    set 
      
      %do year = &start_yr %to &end_yr;
      
        %let shyear = %substr( &year, 3, 2 );
    
        %if &year = 2005 %then %do;
        
        HMDATR&shyear._was 
          (keep=ucounty year 
                numconvmrtgorighomepurch numconvmrtgorigrefin
                NumSubprimeConvOrigHomePurch numsubprimeconvorigrefin
                NumHighCostConvOrigPurch NumHighCostConvOrigRefin
                DenHighCostConvOrigPurch DenHighCostConvOrigRefin
           rename=(NumSubprimeConvOrigHomePurch=NumSubprimeConvOrigHomePur)
           )

        %end;
        %else %do;

        Hmdatr&shyear..HMDATR&shyear._was 
          (keep=geoscaleid ucounty year 
                numconvmrtgorighomepurch numconvmrtgorigrefin
                NumSubprimeConvOrigHomePurch numsubprimeconvorigrefin
                NumHighCostConvOrigPurch NumHighCostConvOrigRefin
                DenHighCostConvOrigPurch DenHighCostConvOrigRefin
           rename=(NumSubprimeConvOrigHomePurch=NumSubprimeConvOrigHomePur)
           where=(geoscaleid = "3" /** County-level obs. **/
             /*
             and
             ucounty in ( "11001", "24031", "24033", "51013", "51059", "51510", "51600", "51610" )
             */
             )
           )

        %end;
        
      %end;
      ;
            
       NumSubprimePurRef = 
         sum( NumSubprimeConvOrigHomePur, numsubprimeconvorigrefin );
       
       NumConvPurRef = 
         sum( numconvmrtgorighomepurch, numconvmrtgorigrefin );
       
       NumHighCostPurRef = 
         sum( NumHighCostConvOrigPurch, NumHighCostConvOrigRefin );
         
       DenHighCostPurRef = 
         sum( DenHighCostConvOrigPurch, DenHighCostConvOrigRefin );
       
       format ucounty $cnty99f.;

  run;

  options obs=max;

%mend Compile_data;

/** End Macro Definition **/


*******   MAIN PROGRAM   ********;

%Compile_data( start_yr=&start_yr, end_yr=&end_yr )

%let vars = 
      NumSubprimePurRef NumConvPurRef
      numconvmrtgorighomepurch NumSubprimeConvOrigHomePur 
      numconvmrtgorigrefin numsubprimeconvorigrefin
      DenHighCostPurRef NumHighCostPurRef 
      DenHighCostConvOrigPurch NumHighCostConvOrigPurch 
      DenHighCostConvOrigRefin NumHighCostConvOrigRefin;

proc summary data=Subprime_was_tr nway;
  class ucounty year;
  var &vars;
  output out=Subprime_was_cty sum= ;

%Super_transpose(  
  data=Subprime_was_cty,
  out=Hmda.Subprime_was,
  var=&vars,
  id=year,
  by=ucounty,
  mprint=N
)

%File_info( data=Hmda.Subprime_was )



%Write_dde_yr( 
  sheet=Data, 
  range=r3c1:r30c123, 
  data=Hmda.Subprime_was, 
  var=&vars,
  fopt=notab, 
  start_yr=&start_yr, 
  end_yr=&end_yr )

