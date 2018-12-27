/**************************************************************************
 Program:  Gender.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  9/27/18
 Version:  SAS 9.4
 Environment:  Windows 7
 
 Description:  HMDA Macro copied from NatData programming.
 
 Modifications:
 
**************************************************************************/

%macro gender();
 	*** create and init gender flag vars ***;
 	array zerosex {*} male female samesex samesexm samesexf diffsex withsex sexnp sexna;	
 	do i = 1 to dim(zerosex);
 		zerosex{i} = 0;
 	end;
 	
 
 	*set any missing values to not provided code;
 	if appsex = " " then appsex = "3";
 	if coapsex = " " then coapsex = "3";
 
 	** applicant or coapplicant has gender ***;
 	if appsex in ("1","2") or coapsex in ("1","2") then withsex=1;
 	
 	*** same sex - either gender ****;	
 	if coapsex in ("1","2") and appsex=coapsex then do;	
 		samesex=1; ** ss flag ***;
 		if coapsex='1' then samesexm=1;	** ss males flag ***;	
 		else if coapsex='2' then samesexf=1; ** ss females flag ***;	
 	end;
 
 	*** male and female ***;
 	else if coapsex in ("1","2") and appsex ^= coapsex then do;
 	*** applicant gender not reported ***;
 		if appsex in ('3','4') then do;
 			sexnp=1;
 			withsex=0;
 		end;	
 		else if appsex in ('4') then do; *assumes n/a equals no co-applicant*; 
 			if coapsex='1' then male =1;
 				else female=1;
 		end;	
 		else do;
 			diffsex=1;
 		end;
 	end;
 
 	*** single applicant - either gender ***;
 	else if appsex in ("1","2") and coapsex in ('4' '5') then do; *assumes n/a equals no co-applicant*;
 		if appsex='1' then male=1;		
 		else if appsex='2' then female=1;	
 	end;
 
 	*** single applicant (either gender) with co-app info missing***;
 	else if appsex in ("1","2") and coapsex in ('3') then do;
 		sexnp=1;
 		withsex=0;	
 	end;
 
 	*** both missing gender ***;
 	else do;
 		if appsex = '4' then sexna=1;
 		else if appsex='3' then sexnp=1;
 		else sexnp=1;
 		withsex=0;
 	end;
 
 	label
 		male = 'male (1 applicant)'
 		female = 'female (1 applicant)'
 		samesex = 'same sex co-app'
 		samesexm = 'same sex - males'
 		samesexf = 'same sex - females'
 		diffsex = 'app and coapp have diff sex'
 		withsex = 'has valid value for gender applicant and coapplicant'
 		sexnp = 'missing gender'
 		sexna = 'gender not applicable'
 	;
 
 
 
 %mend gender;
