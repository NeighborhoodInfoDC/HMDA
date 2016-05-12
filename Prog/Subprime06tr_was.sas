/**************************************************************************
 Program:  Subprime06tr_was.sas
 Library:  Hmda
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/19/07
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Temporary subprime tract data for 2006.

 Modifications:
  09/18/08 PAT Revised definition for subprime HomePurch and Refin to 
               include only 1-4 unit + manuf. homes.
               Added NumSubprimeConvOrigHomeImprov and  
               NumSubprimeConvOrigMultifam.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Hmda )

%let year = 2006;
%let shyear = 06;

data Subprime;

  set Hmda.Loans_&year (keep=ulender ucounty geo2000 loantype action type subprime_lender purpose amount lien rtspread);

  where subprime_lender and loantype = "1" and action = "1";
  
  if type in ( "1", "2" ) then do;
    select ( purpose );
      when ( "1" )
        NumSubprimeConvOrigHomePurch = 1;
      when ( "2" )
        NumSubprimeConvOrigHomeImprov = 1;
      when ( "3" )
        NumSubprimeConvOrigRefin = 1;
      otherwise
        delete;
    end;
  end;
  else if type = "3" then do;
    NumSubprimeConvOrigMultifam = 1;
  end;
    
run;

proc summary data=Subprime nway;
  class geo2000;
  var numsubprimeconvorigrefin NumSubprimeConvOrigHomePurch ;
  output out=Hmda.Subprime&shyear.tr_was sum=;

run;

%File_info( data=Hmda.Subprime&shyear.tr_was )


