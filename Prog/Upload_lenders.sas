/**************************************************************************
 Program:  Upload_lenders.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/11/07
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Upload and register lender data sets to Alpha.
 
 NB: Modify program to copy only the data sets you want to upload.

 Modifications:
  07/21/09 PAT  Uploaded 2006 file.
  07/21/09 PAT  Uploaded 2007 file.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Hmda )

** Start submitting commands to remote server **;

rsubmit;

/** Macro Upload - Start Definition **/

%macro Upload( year=, revisions= );

  proc upload status=no
    inlib=Hmda 
    outlib=Hmda memtype=(data);
    select Lenders_&year;

  x "purge [dcdata.hmda.data]Lenders_&year..*";

  %Dc_update_meta_file(
    ds_lib=Hmda,
    ds_name=Lenders_&year,
    creator_process=Lenders_&year..sas,
    restrictions=None,
    revisions=%str(&revisions)
  )

  run;

%mend Upload;

/** End Macro Definition **/


*******  UPLOAD FILES ***********************************;

%Upload( year=2007, revisions=New file. )

/*
%Upload( year=2006, revisions=New file. )
%Upload( year=2005, revisions=New file. )
%Upload( year=2004, revisions=New file. )
%Upload( year=2003, revisions=New file. )
%Upload( year=2002, revisions=New file. )
%Upload( year=2001, revisions=New file. )
%Upload( year=2000, revisions=New file. )
%Upload( year=1999, revisions=New file. )
%Upload( year=1998, revisions=New file. )
%Upload( year=1997, revisions=New file. )
*/


*********************************************************;

run;

endrsubmit;

** End submitting commands to remote server **;

signoff;
