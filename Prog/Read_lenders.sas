/**************************************************************************
 Program:  Read_lenders.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/10/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to read HMDA lender data.

 Modifications:
  04/15/07 PAT Added support for years 1997-2003.
  01/02/08 PAT Added support for 2006.
               Added lenders_ds= parameter.
  07/14/09 PAT Added support for 2007.
               Added lenders_txt= parameter to read text file.
**************************************************************************/

/** Macro Read_lenders - Start Definition **/

%macro Read_lenders( 
  year=, 
  lenders_txt=,
  lenders_wbk=,
  lenders_ds=,
  subprime_wbk=,
  path=&_dcdata_path\hmda\raw
  );

  %let lenders_num_rows = 10000;
  %let subprime_num_rows = 500;

  %if &year < 1997 or &year > 2007 %then %do;
  
    %err_mput( macro=Read_lenders, msg=Macro does not support year=&year.. )
    %goto exit;
  
  %end;

  /** Macro Reformat_str - Start Definition **/

  %macro Reformat_str( str );

    &str = left( compbl( propcase( &str ) ) );

  %mend Reformat_str;

  /** End Macro Definition **/

  **** Read subprime data ****;

  filename xlsFile dde "excel|&path\[&subprime_wbk]&year!r4c1:r&subprime_num_rows.c5" lrecl=2000 notab;

  data Subprime_&year (compress=no);

    length
      ulender $ 15
      u_resp_id $ 11
      agency $ 1
      resp_id $ 10
      mh $ 1
      rsp_name $ 30;
      
    infile xlsFile missover dsd dlm='09'x;
      
    input 
      u_resp_id
      agency
      resp_id
      mh
      rsp_name;

    ulender = "&year" || u_resp_id;

    if mh = "1" then subprime_lender = 1;
    else subprime_lender = 0;
    
    if mh = "2" then manf_home_lender = 1;
    else manf_home_lender = 0;

    keep ulender subprime_lender manf_home_lender;

  run;

  filename xlsFile clear;

  %Data_to_format(
    FmtLib=work,
    FmtName=$subprm,
    Desc=,
    Data=Subprime_&year,
    Value=ulender,
    Label=subprime_lender,
    OtherLabel="0",
    Print=N,
    Contents=N
    )

  %Data_to_format(
    FmtLib=work,
    FmtName=$manfhm,
    Desc=,
    Data=Subprime_&year,
    Value=ulender,
    Label=manf_home_lender,
    OtherLabel="0",
    Print=N,
    Contents=N
    )

  proc sql noprint;
    select sum( subprime_lender ), sum( manf_home_lender ) into :subprime_lender, :manf_home_lender 
    from Subprime_&year;
  quit;

  %put Subprime lenders=&subprime_lender  Manufactured home lenders=&manf_home_lender; 

  **** Read lender (TS) data ****;
  
  %if &lenders_wbk ~= %then %do;
    filename xlsFile dde "excel|&path\[&lenders_wbk]&year!r2c1:r&lenders_num_rows.c22" lrecl=1000 notab;
  %end;
  %else %if &lenders_txt ~= %then %do;
    filename xlsFile "&path\&lenders_txt" lrecl=1000;
  %end;

  data Hmda.Lenders_&year (label="Mortgage lenders (transmittal sheet), &year");

    %if &lenders_ds = %then %do;
      infile xlsFile stopover dsd dlm='09'x;
    %end;
    %else %do;
      set &lenders_ds (drop=year clar_cnt crsp_asst cyear idd);
      year = "&year";
    %end;
    
    %if &year >= 2004 %then %do;
    
      %** Years 2004 or later **;
    
      length
        year $ 4
        ulender $ 15
        agency $ 1
        resp_id $ 10
        rsp_name $ 30
        rsp_addr $ 40
        rsp_city $ 25
        rsp_stat $ 2
        rsp_zip $ 10
        rsp_zip5 $ 5
        par_name $ 30
        par_addr $ 40
        par_city $ 25
        par_stat $ 2
        par_zip $ 10
        par_zip5 $ 5
        pan_name $ 30
        pan_city $ 25
        pan_stat $ 2
        rsp_tax $ 10
        rsp_asst 8 /*$ 10*/
        rsp_ocd $ 1
        agen_reg $ 2
        lar_cnt 8
        val_err $ 1
        subprime_lender manf_home_lender 3
      ;

      %if &lenders_ds = %then %do;
        input
          year
          resp_id
          agency
          rsp_tax
          rsp_name
          rsp_addr
          rsp_city
          rsp_stat
          rsp_zip
          par_name
          par_addr
          par_city
          par_stat
          par_zip
          pan_name
          pan_city
          pan_stat
          rsp_asst
          rsp_ocd
          agen_reg
          lar_cnt
          val_err
        ;
      %end;
    
      ** Reformat name strings **;
      
      %Reformat_str( rsp_name )
      %Reformat_str( rsp_addr )
      %Reformat_str( rsp_city )
      
      %Reformat_str( par_name )
      %Reformat_str( par_addr )
      %Reformat_str( par_city )

      %Reformat_str( pan_name )
      %Reformat_str( pan_city )
        
      ** 5-digit ZIP codes **;
      
      rsp_zip5 = left( rsp_zip );
      par_zip5 = left( par_zip );
      
      ** Reformat agency region code (add leading zero) **;
      
      agen_reg = put( 1 * agen_reg, z2. );
    
      label
        year = "HMDA reporting year"
        ulender = "Unique lender ID [year + agency + resp_id]"
        resp_id = "Respondent (lender) ID"
        agency = "Supervising government agency"
        rsp_name = "Respondent name"
        rsp_addr = "Respondent mailing address"
        rsp_city = "Respondent city"
        rsp_stat = "Respondent state"
        rsp_zip = "Respondent ZIP code"
        rsp_zip5 = "Respondent ZIP code (5-digit)"
        par_name = "Parent name"
        par_addr = "Parent mailing address"
        par_city = "Parent city"
        par_stat = "Parent state"
        par_zip = "Parent ZIP code"
        par_zip5 = "Parent ZIP code (5-digit)"
        pan_name = "Panel name"
        pan_city = "Panel city"
        pan_stat = "Panel state"
        rsp_tax = "Respondent tax ID"
        rsp_asst = "Respondent assets (Dec. 31 previous year)"
        rsp_ocd = "Respondent other lender type"
        agen_reg = "Supervising agency regional office"
        lar_cnt = "LAR count"
        val_err = "LAR validity edits"
      ;
    
      format agency $agencyf. rsp_ocd $othcodf. val_err $yesno. ;

    %end;
    %else %if &year >= 2000 %then %do;
    
      %** Years 2000 - 2003 **;
    
      length
        year $ 4
        ulender $ 15
        agency $ 1
        resp_id $ 10
        rsp_name $ 30
        rsp_addr $ 40
        rsp_city $ 25
        rsp_stat $ 2
        rsp_zip $ 10
        rsp_zip5 $ 5
        rsp_tax $ 10
        rsp_asst $ 10
        rsp_ocd $ 1
        agen_reg $ 2
        lar_cnt 8
        subprime_lender manf_home_lender 3
      ;

      input
        year
        resp_id
        agency
        rsp_name
        rsp_addr
        rsp_city
        rsp_stat
        rsp_zip
        rsp_tax
        rsp_asst
        rsp_ocd
        agen_reg
        lar_cnt
      ;
    
      ** Reformat name strings **;
      
      %Reformat_str( rsp_name )
      %Reformat_str( rsp_addr )
      %Reformat_str( rsp_city )
      
      ** 5-digit ZIP codes **;
      
      rsp_zip5 = left( rsp_zip );
      
      ** Reformat agency region code (add leading zero) **;
      
      agen_reg = put( 1 * agen_reg, z2. );
    
      label
        year = "HMDA reporting year"
        ulender = "Unique lender ID [year + agency + resp_id]"
        resp_id = "Respondent (lender) ID"
        agency = "Supervising government agency"
        rsp_name = "Respondent name"
        rsp_addr = "Respondent mailing address"
        rsp_city = "Respondent city"
        rsp_stat = "Respondent state"
        rsp_zip = "Respondent ZIP code"
        rsp_zip5 = "Respondent ZIP code (5-digit)"
        rsp_tax = "Respondent tax ID"
        rsp_asst = "Respondent assets (Dec. 31 previous year)"
        rsp_ocd = "Respondent other lender type"
        agen_reg = "Supervising agency regional office"
        lar_cnt = "LAR count"
      ;
    
      format agency $agencyf. rsp_ocd $othcodf. ;

    %end;
    %else %if &year >= 1999 %then %do;
    
      %** Year 1999 **;
    
      length
        year $ 4
        ulender $ 15
        agency $ 1
        resp_id $ 10
        rsp_name $ 30
        rsp_addr $ 40
        rsp_city $ 25
        rsp_stat $ 2
        rsp_zip $ 10
        rsp_zip5 $ 5
        rsp_tax $ 10
        rsp_asst $ 10
        rsp_ocd $ 1
        agen_reg $ 2
        subprime_lender manf_home_lender 3
      ;

      input
        year
        resp_id
        agency
        rsp_name
        rsp_addr
        rsp_city
        rsp_stat
        rsp_zip
        rsp_tax
        rsp_asst
        rsp_ocd
        agen_reg
      ;
    
      ** Reformat name strings **;
      
      %Reformat_str( rsp_name )
      %Reformat_str( rsp_addr )
      %Reformat_str( rsp_city )
      
      ** 5-digit ZIP codes **;
      
      rsp_zip5 = left( rsp_zip );
      
      ** Reformat agency region code (add leading zero) **;
      
      agen_reg = put( 1 * agen_reg, z2. );
    
      label
        year = "HMDA reporting year"
        ulender = "Unique lender ID [year + agency + resp_id]"
        resp_id = "Respondent (lender) ID"
        agency = "Supervising government agency"
        rsp_name = "Respondent name"
        rsp_addr = "Respondent mailing address"
        rsp_city = "Respondent city"
        rsp_stat = "Respondent state"
        rsp_zip = "Respondent ZIP code"
        rsp_zip5 = "Respondent ZIP code (5-digit)"
        rsp_tax = "Respondent tax ID"
        rsp_asst = "Respondent assets (Dec. 31 previous year)"
        rsp_ocd = "Respondent other lender type"
        agen_reg = "Supervising agency regional office"
      ;
    
      format agency $agencyf. rsp_ocd $othcodf. ;

    %end;
    %else %if &year >= 1998 %then %do;
    
      %** Year 1998 **;
    
      length
        year $ 4
        ulender $ 15
        agency $ 1
        resp_id $ 10
        rsp_name $ 30
        rsp_addr $ 40
        rsp_city $ 25
        rsp_stat $ 2
        rsp_zip $ 10
        rsp_zip5 $ 5
        rsp_tax $ 10
        rsp_asst $ 10
        rsp_ocd $ 1
        agen_reg $ 2
        subprime_lender manf_home_lender 3
      ;

      input
        year
        agency
        resp_id
        rsp_name
        rsp_addr
        rsp_city
        rsp_stat
        rsp_zip
        rsp_tax
        rsp_asst
        rsp_ocd
        agen_reg
      ;
    
      ** Reformat name strings **;
      
      %Reformat_str( rsp_name )
      %Reformat_str( rsp_addr )
      %Reformat_str( rsp_city )
      
      ** 5-digit ZIP codes **;
      
      rsp_zip5 = left( rsp_zip );
      
      ** Reformat agency region code (add leading zero) **;
      
      agen_reg = put( 1 * agen_reg, z2. );
    
      label
        year = "HMDA reporting year"
        ulender = "Unique lender ID [year + agency + resp_id]"
        resp_id = "Respondent (lender) ID"
        agency = "Supervising government agency"
        rsp_name = "Respondent name"
        rsp_addr = "Respondent mailing address"
        rsp_city = "Respondent city"
        rsp_stat = "Respondent state"
        rsp_zip = "Respondent ZIP code"
        rsp_zip5 = "Respondent ZIP code (5-digit)"
        rsp_tax = "Respondent tax ID"
        rsp_asst = "Respondent assets (Dec. 31 previous year)"
        rsp_ocd = "Respondent other lender type"
        agen_reg = "Supervising agency regional office"
      ;
    
      format agency $agencyf. rsp_ocd $othcodf. ;

    %end;
    %else %if &year >= 1997 %then %do;
    
      %** Year 1997 **;
    
      length
        year $ 4
        ulender $ 15
        agency $ 1
        resp_id $ 10
        rsp_name $ 30
        rsp_city $ 25
        rsp_stat $ 2
        rsp_tax $ 10
        lar_cnt 8
        rsp_ocd $ 1
        subprime_lender manf_home_lender 3
      ;

      input
        year
        agency
        resp_id
        rsp_name
        rsp_city
        rsp_stat
        rsp_tax
        lar_cnt
        rsp_ocd
      ;
    
      ** Reformat name strings **;
      
      %Reformat_str( rsp_name )
      %Reformat_str( rsp_city )
      
      label
        year = "HMDA reporting year"
        ulender = "Unique lender ID [year + agency + resp_id]"
        resp_id = "Respondent (lender) ID"
        agency = "Supervising government agency"
        rsp_name = "Respondent name"
        rsp_city = "Respondent city"
        rsp_stat = "Respondent state"
        rsp_tax = "Respondent tax ID"
        lar_cnt = "LAR count"
        rsp_ocd = "Respondent other lender type"
      ;
    
      format agency $agencyf. rsp_ocd $othcodf. ;

    %end;
    %else %do;
    
      %err_mput( macro=Read_lenders, msg=Macro does not support year=&year.. )
      %goto exit;
    
    %end;
    
    if missing( year ) and missing( resp_id ) then do;
      %warn_put( macro=Read_lenders, msg='Blank record deleted: ' _n_= year= resp_id= rsp_name= )
      delete;
    end;
    
    if year ~= &year then do;
      %warn_put( macro=Read_lenders, msg="Records not for &year deleted: " _n_= year= resp_id= rsp_name= )
      delete;
    end;
    
    ** Fix lender IDs in 1998 **;
    
    if year = 1998 then do;
      xagency = substr( resp_id, 10, 1 );
      resp_id = trim( agency ) || left( resp_id );
      agency = xagency;
    end;      
    
    ** Unique lender ID **;
    
    ulender = year || trim( left( agency ) ) || left( resp_id );
    
    ** Subprime & manufactured housing lender flags **;
    
    subprime_lender = 1 * put( ulender, $subprm. );
    manf_home_lender = 1 * put( ulender, $manfhm. );
    
    label
      subprime_lender = "Is a HUD-classified subprime lender"
      manf_home_lender = "Is a HUD-classified manufactured home lender";

    format subprime_lender manf_home_lender dyesno.;
    
    drop xagency;

  run;

  proc sort data=Hmda.Lenders_&year;
    by ulender;

  filename xlsFile clear;

  proc catalog catalog=work.formats;
    delete subprm manfhm / entrytype=formatc;
  quit;
  
  ** Check for duplicate lender records **;
  
  %Dup_check(
    data=Hmda.Lenders_&year,
    by=agency resp_id,
    id=year rsp_name rsp_city rsp_stat,
    out=_dup_check,
    listdups=Y,
    count=dup_check_count,
    quiet=N,
    debug=N
  )

  %File_info( 
    data=Hmda.Lenders_&year, 
    printobs=5,
    freqvars=
      year agency 
      %if &year >= 1998 %then %do;
        agen_reg 
      %end;
      rsp_ocd 
      rsp_stat 
      %if &year >= 2004 %then %do;
        par_stat pan_stat              
        val_err 
      %end;
      subprime_lender manf_home_lender
  )

  proc print data=Hmda.Lenders_&year 
      n="Number of subprime lenders in HUD list = %left( &subprime_lender ) / In TS data = ";
    where subprime_lender;
    id ulender;
    var rsp_name;
    title2 "Subprime lenders, &year";
    
  run;

  proc print data=Hmda.Lenders_&year 
      n="Number of manufactured home lenders in HUD list = %left( &manf_home_lender ) / In TS data = ";
    where manf_home_lender;
    id ulender;
    var rsp_name;
    title2 "Manufactured home lenders, &year";
    
  run;

  title2;
  footnote1;
  
  %exit:
  
  %note_mput( macro=Read_lenders, msg=Macro exiting. )

%mend Read_lenders;

/** End Macro Definition **/


