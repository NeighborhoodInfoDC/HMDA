/**************************************************************************
 Program:  HMDA_forweb
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   Rob Pitingolo
 Created:  11/16/2017
 Version:  SAS 9.4
 Environment:  Windows
 Modifications: 

**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas"; 

** Define libraries **;
%DCData_lib( HMDA )
%DCData_lib( Web )


/***** Update the let statements for the data you want to create CSV files for *****/

%let library = hmda; /* Library of the summary data to be transposed */
%let outfolder = hmda; /* Name of folder where output CSV will be saved */
%let sumdata = hmda_sum; /* Summary dataset name (without geo suffix) */
%let start = 1997; /* Start year */
%let end = 2006; /* End year */
%let keepvars = NumMrtgOrigHomePurch1_4m NumHsngUnits1_4Fam MedianMrtgInc1_4m_adj 
           NumConvMrtgOrigHomePurch NumSubprimeConvOrigHomePur; /* Summary variables to keep and transpose */


/***** Update the web_varcreate marcro if you need to create final indicators for the website after transposing *****/

%macro web_varcreate;

NumMrtgOrigHomePurchPerUnit = NumMrtgOrigHomePurch1_4m / NumHsngUnits1_4Fam;
PctSubprimeConvOrigHomePur = NumSubprimeConvOrigHomePur / NumConvMrtgOrigHomePurch;

label NumMrtgOrigHomePurchPerUnit = "Loans per 1,000 housing units";
label PctSubprimeConvOrigHomePur = "% subprime loans";
label MedianMrtgInc1_4m_adj = "Median borrower income";

drop NumMrtgOrigHomePurch1_4m NumMrtgOrigHomePurch1_4m NumSubprimeConvOrigHomePur NumConvMrtgOrigHomePurch NumHsngUnits1_4Fam;

%mend web_varcreate;



/**************** DO NOT UPDATE BELOW THIS LINE ****************/

%macro csv_create(geo);
			 
%web_transpose(&library., &outfolder., &sumdata., &geo., &start., &end., &keepvars. );

/* Load transposed data, create indicators for profiles */
data &sumdata._&geo._long_allyr;
	set &sumdata._&geo._long;
	%web_varcreate;
	label start_date = "Start Date"
		  end_date = "End Date"
		  timeframe = "Year of Data";
run;

/* Create metadata for the dataset */
proc contents data = &sumdata._&geo._long_allyr out = &sumdata._&geo._metadata noprint;
run;

/* Output the metadata */
ods csv file ="&_dcdata_default_path.\web\output\&outfolder.\&outfolder._&geo._metadata..csv";
	proc print data =&sumdata._&geo._metadata noobs;
	run;
ods csv close;


/* Output the CSV */
ods csv file ="&_dcdata_default_path.\web\output\&outfolder.\&outfolder._&geo..csv";
	proc print data =&sumdata._&geo._long_allyr noobs;
	run;
ods csv close


%mend csv_create;
%csv_create (tr10);
%csv_create (tr00);
%csv_create (anc12);
%csv_create (wd02);
%csv_create (wd12);
%csv_create (city);
%csv_create (psa12);
%csv_create (zip);

