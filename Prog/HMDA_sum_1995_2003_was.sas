/**************************************************************************
 Program:  HMDA_sum_1995_2003_was.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/25/05
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Copy and reformat HMDA tract summary files from NNIP.
 Years 1995 - 2003.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( HMDA )

*options mprint symbolgen mlogic;

%let revisions = New file.;

%Hmda_nnip_reformat( year=1995, upload=y, revisions=&revisions )
%Hmda_nnip_reformat( year=1996, upload=y, revisions=&revisions )
%Hmda_nnip_reformat( year=1997, upload=y, revisions=&revisions )
%Hmda_nnip_reformat( year=1998, upload=y, revisions=&revisions )
%Hmda_nnip_reformat( year=1999, upload=y, revisions=&revisions )
%Hmda_nnip_reformat( year=2000, upload=y, revisions=&revisions )
%Hmda_nnip_reformat( year=2001, upload=y, revisions=&revisions )
%Hmda_nnip_reformat( year=2002, upload=y, revisions=&revisions )
%Hmda_nnip_reformat( year=2003, upload=y, revisions=&revisions )

run;

signoff;

