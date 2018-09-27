/**************************************************************************
 Program:  Racecalc_04.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  9/27/18
 Version:  SAS 9.4
 Environment:  Windows 7
 
 Description:  HMDA Macro copied from NatData programming.
 
 Modifications:
 
**************************************************************************/

%macro racecalc_04();
 
         *** create and init race flags ***;
         length ind as wh bl hi mxd multiple np na withrace minority 3.;
         array zerorace {*} ind as wh bl hi mxd multiple np na withrace minority;
         do i = 1 to dim(zerorace);
                 zerorace{i} = 0;
         end;
 
         *** if either app or coapp is hispanic ****;
         if  ethn in ("1") or coapethn in ("1") then do;
         
         	*kp - coding 1 hispanic eth with a second na or np eth as hispanic*;
                 if ethn = "1" and coapethn ne "2" then hi=1; ** both are hispanic ***;
                 	else if coapethn = "1" and ethn ne "2" then hi='1';
                 	else mxd=1; *** only one, then mixed **;
                 withrace=1;
         end;
         *** neither app or coapp is hispanic ***;
         else do;
                 *** has race value ****;
                 if apprac in ("1","2","3","4","5") or coaprac in ("1","2","3","4","5") then withrace=1;
 
                 ****multiple race categories**;
                 if race2 not in ("6","7","8","") then do;  **applicant has multiple races**;
                         if coaprac in ("6","7","8","") then multiple=1 ;  **single applicant with multiple races***;
                                 else if coaprac2 not in ("6","7","8","") then multiple = 1; **both app have multiple races*;
                                 else mxd= 1 ;  ***co-applicants, one with multiple races, one without;
                 end;
 
                 *** no multiple races and no coapplicant/coapplicant race is missing or same race ****;
                 else if coaprac in ("6","7","8","") or apprac=coaprac then do;
                         if apprac eq "1" then ind=1;
                                 else if apprac eq "2" then as=1;
                                 else if apprac eq "3" then bl=1;
                                 else if apprac eq "4" then as=1;
                                 else if apprac eq "5" then wh=1;
                                 else if apprac eq "7" then na=1;
                                 else np=1;
                 end;
 	
                 *** has coapplicant with/different race ****;
                 else do;
                         *** applicant race is missing - use coapplicant***;
                         if apprac in ("6","7","8","") then do;
                                 if coaprac eq "1" then ind=1;
                                 else if coaprac eq "2" then as=1;
                                 else if coaprac eq "3" then bl=1;
                                 else if coaprac eq "4" then as=1;
                                 else if coaprac eq "5" then wh=1;
                                 else if coaprac eq "7" then na=1;
                                 else np=1;
                         end;
                         else do;
                                 if apprac ne coaprac then mxd=1;
                         end;
                 end;
         end;
         if withrace=1 and wh=0 then minority=1;
 
         label
 	         hi = 'hispanic flag'
 	        ind = 'American Indian/Alaska Native flag'
 	        as = 'asian/Native Hawaiian/Pacific Islander flag'
 	        wh = 'white flag'
 	        bl = 'black flag'
 	        multiple = 'single or coapplicants with non hispanic multiple races flag'
 	        mxd = 'applicant/coapplicant with different ethnicities or races flag'
 	        np = 'race not provided flag'
 	        na = 'not applicable flag'
 	        withrace = 'has a value for race variable flag'
 		minority= 'minority flag'
         ;
 
 
 %mend;
