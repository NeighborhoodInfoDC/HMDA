/**************************************************************************
 Program:  Read_Hmda06_was.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/20/09
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Read CSV file HMDA06_was.csv into a SAS data set.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( HMDA )

filename csvFile "D:\DCData\Libraries\HMDA\Raw\HMDA06_was.csv" lrecl=500;

data Hmda.Hmda06_was (label="Raw HMDA LAR records, Washington region, 2006");

  infile csvFile dsd stopover firstobs=2 /*obs=101*/;
  
  length 
    income 4
    rtspread 5
    amount 5
    minpopct 6
    tctinc 6
    seq 8
    pop 8
    hudmdinc 8
    ownocc 8
    units1_4 8
  ;

  input
    msapma99 : $4.
    geo2000 : $12.
    ucounty : $5.
    year : $4.
    resp_id : $10.
    msa : $5.  /* metro05 */
    state : $2.
    county : $3.
    tract : $7.
    preapp : $1.
    action : $1.
    agency : $1.
    loantype : $1.
    proptype : $1.
    purpose : $1.
    occupanc : $1.
    appethn : $1.
    coapethn : $1.
    apprac : $1.
    apprac2 : $1.
    apprac3 : $1.
    apprac4 : $1.
    apprac5 : $1.
    coaprac : $1.
    coaprac2 : $1.
    coaprac3 : $1.
    coaprac4 : $1.
    coaprac5 : $1.
    appsex : $1.
    coapsex : $1.
    prch_typ : $1.
    hoepa : $1.
    lien : $1.
    edit : $1.
    deny1 : $1.
    deny2 : $1.
    deny3 : $1.
    before2004 : $1.
    income 
    rtspread
    amount
    minpopct
    tctinc
    seq
    pop
    hudmdinc
    ownocc
    units1_4;

  label
    action = "Type of Action Taken"
    agency = "Agency Code"
    amount = "Amount of Loan (000s)"
    appethn = "Applicant Ethnicity"
    apprac = "Applicant Race 1"
    apprac2 = "Applicant Race 2"
    apprac3 = "Applicant Race 3"
    apprac4 = "Applicant Race 4"
    apprac5 = "Applicant Race 5"
    appsex = "Applicant Sex"
    before2004 = "Application Date Prior to 2004 Flag"
    coapethn = "Co-Applicant Ethnicity"
    coaprac = "Co-Applicant Race 1"
    coaprac2 = "Co-Applicant Race 2"
    coaprac3 = "Co-Applicant Race 3"
    coaprac4 = "Co-Applicant Race 4"
    coaprac5 = "Co-Applicant Race 5"
    coapsex = "Co-Applicant Sex"
    county = "County Code (Three-digit FIPS)"
    ucounty = "Unique county: SSCCC"
    deny1 = "Denial Reason 1"
    deny2 = "Denial Reason 2"
    deny3 = "Denial Reason 3"
    edit = "Edit Status"
    geo2000 = "Full FIPS:  SSCCCTTTTTT"
    hoepa = "HOEPA status"
    hudmdinc = "HUD Median Family Income"
    income = "Applicant Income (000s)"
    lien = "Lien Status"
    loantype = "Type of Loan"
    minpopct = "Minority Population %"
    msa = "MSA of Property"
    msapma99 = "MSP/PMSA (1999)"
    occupanc = "Occupancy"
    ownocc = "Number to Owner-occupied units"
    pop = "Population"
    prch_typ = "Purchaser Type"
    preapp = "Preapproval"
    proptype = "Property Type"
    purpose = "Purpose of Loan"
    resp_id = "Respondent ID"
    rtspread = "Rate Spread"
    seq = "Sequence Number"
    state = "State Code (Two-digit FIPS)"
    tctinc = "Tract to MSA Income %"
    tract = "Census Tract Number"
    units1_4 = "Number of 1-to-4 Family units"
    year = "Year of data (e.g. 2006)"
  ;
  
  format ucounty $cnty99f. agency $agencyf. loantype $loantyp. purpose $purpose.;

run;

proc sort data=Hmda.hmda06_was;
  by resp_id seq;

%Dup_check(
  data=Hmda.hmda06_was,
  by=resp_id seq,
  id=state county,
  out=_dup_check,
  listdups=Y,
  count=dup_check_count,
  quiet=N,
  debug=N
)

%File_info( data=Hmda.hmda06_was, freqvars=year agency msapma99 msa loantype purpose )

proc sort data=Hmda.hmda06_was_dc out=hmda06_was_dc;
  by resp_id seq;

proc compare base=hmda06_was_dc compare=Hmda.hmda06_was (where=(state='11')) maxprint=(40,32000) listvar;
  id resp_id seq;
run;

