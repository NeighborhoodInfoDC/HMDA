/**************************************************************************
 Program:  Prop_type.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  9/27/18
 Version:  SAS 9.4
 Environment:  Windows 7
 
 Description:  HMDA Macro copied from NatData programming.
 
 Modifications:
 
**************************************************************************/

%macro prop_type();
 	*** create and init property flag vars ***;
 	array zeroprop {*} prop1_4 prop1_4m prop5 prop_man prop_miss hasProp;
 	do i = 1 to dim(zeroprop);
 		zeroprop{i} = 0;
 	end;
 	
 %if &year. gt 2003 %then %do;
 		
 	if type in (1,2,3) then hasProp=1;
 	
 	if type = 1 then prop1_4=1;
 	else if type=2 then prop_man=1;
 	else if type = 3 then prop5=1;
 	else prop_miss=1;
 
 	*creating flag consistent with 2003 and earlier-kp 2/5/06;
 	if type in (1,2) then prop1_4m = 1;
 %end;
 
 *creating parallel set of flags for 2003 and earlier-kp 2/5/06;
 %if &year. lt 2004 %then %do;
  if purpose in ('1','2','3') then prop1_4m = 1;
  		else if purpose = '4' then prop5 = 1;
 %end;
  
 	label
 		prop1_4 ='1 to 4 family'
 		prop1_4m ='1 to 4 family, plus manufactured housing'
 		prop5 = '5 + family' 
 		prop_man ='manufactured'
 		prop_miss = 'missing property type information'
 		hasProp = 'has property type information'
 	;
 
 %mend prop_type;
