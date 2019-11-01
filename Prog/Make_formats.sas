/**************************************************************************
 Program:  Make_formats.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/10/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Make HMDA data formats.

 Modifications:
  12/17/07  PAT Changed $purpose.
  09/23/08  PAT Added values 7 & 8 for $action.
  08/28/18  RP Updated $agencys
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( Hmda )

proc format library=Hmda;

  value $agencyf
    "1" = "Office of the Comptroller of the Currency"
    "2" = "Federal Reserve"
    "3" = "Federal Deposit Insurance Corporation"
    "4" = "Office of Thrift Supervision"
    "5" = "National Credit Union Administration"
    "7" = "U.S. Department of Housing and Urban Development"
    "9" = "Consumer Financial Protection Bureau";
  
  value $agencys
    "1" = "OCC"
    "2" = "FRB"
    "3" = "FDIC"
    "4" = "OTS"
    "5" = "NCUA"
    "7" = "HUD"
	"9" = "CFPB";
    
  value $othcodf
    "0" = "Bank, savings institution or credit union"
    "1" = "Mortgage banking subsidiary of commercial bank"
    "2" = "Mortgage banking subsidiary of BHC or servicing corp."
    "3" = "U.S. Department of Housing and Urban Development"
    "5" = "Affiliate";

  value $othcods
    "0" = "Depository institution"
    "1" = "Subsidiary commercial bank"
    "2" = "Subsidiary BHC/servicing corp."
    "3" = "HUD"
    "5" = "Affiliate";
    
  value $yesno
    "Y" = "Yes"
    "N" = "No";

  /** LOAN INFORMATION **/

  value $proptyp
    "1" = "1-4 family (non-manufactured)"
    "2" = "Manufactured housing"
    "3" = "Multifamily";

  value $loantyp
    "1" = "Conventional"
    "2" = "FHA-insured"
    "3" = "VA-guaranteed"
    "4" = "FSA/RHS";

  value $purpose
    "1" = "Home purchase (pre-2004, 1-4 family only)"
    "2" = "Home improvement (pre-2004, 1-4 family only)"
    "3" = "Refinancing (pre-2004, 1-4 family only)"
    "4" = "Other purpose"
	"5" = "Not applicable";

  value $preapp
    "1" = "Preapproval was requested"
    "2" = "Preapproval was not requested"
    "3" = "Not applicable";

  value $occupan
    "1" = "Owner-occupied principal dwelling"
    "2" = "Not owner occupied"
    "3" = "Not applicable";

  value $action
    "1" = "Loan originated"
    "2" = "Approved but not accepted"
    "3" = "Denied"
    "4" = "Withdrawn by applicant"
    "5" = "File closed for incompleteness"
    "6" = "Loan purchased by institution"
    "7" = "Preapproval request denied by financial institution"
    "8" = "Preapproval request approved but not accepted";

  /** APPLICANT INFORMATION **/

  value $hmdrace
    "1" = "American Indian/Alaskan"
    "2" = "Asian/Pacific Islander"
    "3" = "Black"
    "4" = "Hispanic"
    "5" = "White"
    "6" = "Not provided"
    "7" = "Not applicable";

  value $hmdethn
    "1" = "Hispanic/Latino"
    "2" = "Not Hispanic/Latino"
    "3" = "Not provided"
    "4" = "Not applicable"
    "5" = "No co-applicant";

  value $hmdsex
    "1" = "Male"
    "2" = "Female"
    "3" = "Not provided"
    "4" = "Not applicable"
    "5" = "No co-applicant"
	"6" = "Applicant selected both male and female";

  /** PURCHASER AND DENIAL INFORMATION **/

  value $prchtyp
    "0" = "Loan not originated/sold in reporting year"
    "1" = "Federal National Mortgage Association"
    "2" = "Government National Mortgage Association"
    "3" = "Federal Home Loan Mortgage Corporation"
    "4" = "Federal Agricultural Mortgage Corporation"
    "5" = "Commercial bank"
    "6" = "Savings bank or savings association"
    "7" = "Credit union, mortgage company, finance company, or life insurance company"
    "8" = "Affiliate Institution"
    "9" = "Other type of purchaser";

  value $deny
    " " = "Loan not denied/not applicable"
    "0" = "None given"
    "1" = "Debt-to-income ratio"
    "2" = "Employment history"
    "3" = "Credit history"
    "4" = "Collateral"
    "5" = "Insufficient cash"
    "6" = "Unverifiable information"
    "7" = "Credit application incomplete"
    "8" = "Mortgage insurance denied"
    "9" = "Other"
	"10" = "Not applicable";
    
  /** OTHER **/
  
  value $edit
    "0" = "No edit failures"
    "5" = "Validity edit failure only"
    "6" = "Quality edit failure only"
    "7" = "Validity and quality edit failures";
    
  value $hoepa
    "1" = "HOEPA loan"
    "2" = "Not a HOEPA loan"
	"3" = "Not applicable";
    
  value $lien
    "1" = "Secured by first lien"
    "2" = "Secured by subordinate lien"
    "3" = "Not secured by a lien"
    "4" = "Not applicable";
    
  value $appdate
    "0" = "No"
    "1" = "Yes"
    "2" = "Not available";
    
run;

proc catalog catalog=Hmda.formats;
  modify agencyf (desc="Supervising agency code (full label)") / entrytype=formatc;
  modify agencys (desc="Supervising agency code (short label)") / entrytype=formatc;
  modify othcodf (desc="Other lender code (full label)") / entrytype=formatc;
  modify othcods (desc="Other lender code (short label)") / entrytype=formatc;
  modify yesno (desc="Yes/No character variable") / entrytype=formatc;
  modify action (desc="Action taken on application") / entrytype=formatc;
  modify deny (desc="Reason for loan denial") / entrytype=formatc;
  modify hmdrace (desc="HMDA race/ethnicity") / entrytype=formatc;
  modify hmdethn (desc="HMDA ethnicity") / entrytype=formatc;
  modify hmdsex (desc="HMDA sex") / entrytype=formatc;
  modify proptyp (desc="Property type") / entrytype=formatc;
  modify loantyp (desc="Type of loan") / entrytype=formatc;
  modify preapp (desc="Preapproval request") / entrytype=formatc;
  modify occupan (desc="Owner-occupancy for borrower") / entrytype=formatc;
  modify prchtyp (desc="Type of purchaser") / entrytype=formatc;
  modify purpose (desc="Loan purpose") / entrytype=formatc;
  modify edit (desc="Loan record edit status") / entrytype=formatc;
  modify hoepa (desc="Loan HOEPA Status") / entrytype=formatc;
  modify lien (desc="Loan lien status") / entrytype=formatc;
  modify appdate (desc="Application date prior to reporting year") / entrytype=formatc;
  contents;
quit;

run;
