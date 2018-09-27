/**************************************************************************
 Program:  purp_type.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  9/27/18
 Version:  SAS 9.4
 Environment:  Windows 7
 
 Description:  HMDA Macro copied from NatData programming.
 
 Modifications:
 
**************************************************************************/

	%macro purp_type();
 
                 array zerovar2 {*} purch impr refin multi;
 
                 do i = 1 to dim(zerovar2);
                         zerovar2{i} = 0;
                 end;
 
                 **** pre-2004 purpose flags (for 1-4 family units and manufactured homes) *****;
                 
                 %if &year. gt 2003 %then %do;
                 if type ne "3" then do;
                     if purpose eq "1" then purch=1;
                 	else if purpose eq "2" then impr=1;
                 	else if purpose eq "3" then refin=1;
                 end;
 		%end;
                 %else %do;
                      if purpose eq "1" then purch=1;
                 	else if purpose eq "2" then impr=1;
                 	else if purpose eq "3" then refin=1;
             	%end;    
 
                 *** dsd - in 04, purpose only had 3 categories. Need to get multi from type now *****;
                 %if &year. gt 2003 %then %do;
                         else if type eq "3" then multi=1;
                 %end;
                 %else %do;
                         else if purpose eq "4" then multi=1;
                 %end;
                 else delete;
 	
 	       *** 2/22/06  kp - in 04, purpose only had 3 categories. Need to reformat to old purpose categories *****;
 	       length purpose4cat $1.;
 	       
 	       %if &year. gt 2003 %then %do;
 	               if type eq '3' then purpose4cat = '4';
 	               		else purpose4cat=purpose;
 	       %end;
 	       %else %do;
 	       				 purpose4cat=purpose;
 	       %end;
 	       
 	
 		label 
 			purch = 'purchase flag (for 1-4 family units and manufactured homes)'
 			impr = 'improvement flag (for 1-4 family units and manufactured homes)'
 			refin= 'refinance flag (for 1-4 family units and manufactured homes)'
 			multi = 'multifamily housing, all purposes flag';
 		
 		
 	
 	%mend;
