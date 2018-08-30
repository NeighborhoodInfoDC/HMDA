/**************************************************************************
 Program:  Pct_subprime_tbl.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/19/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Table showing changes in subprime lending for counties
and region.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
***%include "C:\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

proc tabulate data=Hmda.Subprime_was format=comma6.1 noseps missing;
  class ucounty;
  var NumSubprimePurRef: NumConvPurRef: DenHighCostPurRef: NumHighCostPurRef: ;
  table 
    /** Rows **/
    all='Washington, D.C., Region' ucounty=' ',
    /** Columns **/
    NumSubprimePurRef_1997='1997' * pctsum<NumConvPurRef_1997>=' '
    NumSubprimePurRef_1998='1998' * pctsum<NumConvPurRef_1998>=' '
    NumSubprimePurRef_1999='1999' * pctsum<NumConvPurRef_1999>=' '
    NumSubprimePurRef_2000='2000' * pctsum<NumConvPurRef_2000>=' '
    NumSubprimePurRef_2001='2001' * pctsum<NumConvPurRef_2001>=' '
    NumSubprimePurRef_2002='2002' * pctsum<NumConvPurRef_2002>=' '
    NumSubprimePurRef_2003='2003' * pctsum<NumConvPurRef_2003>=' '
    NumSubprimePurRef_2004='2004' * pctsum<NumConvPurRef_2004>=' '
    NumSubprimePurRef_2005='2005' * pctsum<NumConvPurRef_2005>=' '
    / rtspace=40 box='Pct. Loans from Subprime Lenders'
    ;
  table 
    /** Rows **/
    all='Washington, D.C., Region' ucounty=' ',
    /** Columns **/
    NumHighCostPurRef_2004='2004' * pctsum<DenHighCostPurRef_2004>=' '
    NumHighCostPurRef_2005='2005' * pctsum<DenHighCostPurRef_2005>=' '
    / rtspace=40 box='Pct. High Interest Rate Loans'
    ;
  format ucounty $cnty99f.;

run;
