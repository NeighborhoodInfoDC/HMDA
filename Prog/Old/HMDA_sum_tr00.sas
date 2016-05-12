/**************************************************************************
 Program:  HMDA_sum_tr00.sas
 Library:  HMDA
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/03/06
 Version:  SAS 8.2
 Environment:  Windows
 
 Description:  Create HMDA summary indicator file for Census tracts
 (2000) from selected variables in DataPlace HMDA files.
 
 NB:  ZIP Magic must be enabled before running this program.

 Modifications:
  01/25/07 PAT  Added 2005 data.
  03/02/07 PAT  Added NumMrtgOrig_vli, NumMrtgOrig_li, NumMrtgOrig_mi,
                NumMrtgOrig_hinc, NumMrtgOrig_Inc.
  03/12/07 PAT  Added NumSubprimeConvOrigRefin, NumConvMrtgOrigRefin.
  12/12/07 PAT  Substituted new 2005 data.
        ******* TEMPORARY FIX UNTIL UPDATED 2004 DATA ARE AVAILABLE.
                WILL NEED TO ADJUST HIGH COST LOAN VARS.

  12/17/07 PAT  Added calculation of DenSubprimeMrtgPurchOtherX, 
                DenSubprimeMrtgRefinOtherX, NumSubprimeMrtgPurchOtherX,
                and NumSubprimeMrtgRefinOtherX.
                
                Added supplemental vars. DenSubprimeMrtgPurch_vli, 
                DenSubprimeMrtgPurch_li, DenSubprimeMrtgPurch_mi, 
                DenSubprimeMrtgPurch_hinc, DenSubprimeMrtgRefin_vli, 
                DenSubprimeMrtgRefin_li, DenSubprimeMrtgRefin_mi, 
                DenSubprimeMrtgRefin_hinc, NumSubprimeMrtgPurch_vli, 
                NumSubprimeMrtgPurch_li, NumSubprimeMrtgPurch_mi, 
                NumSubprimeMrtgPurch_hinc, NumSubprimeMrtgRefin_vli, 
                NumSubprimeMrtgRefin_li, NumSubprimeMrtgRefin_mi, 
                NumSubprimeMrtgRefin_hinc.                

  12/21/07 PAT  Added vars for 2004-2005:
                NumHighCostMrtgPurch_vli, NumHighCostMrtgPurch_li,
                NumHighCostMrtgPurch_mi, NumHighCostMrtgPurch_hinc,
                NumHighCostMrtgRefin_vli, NumHighCostMrtgRefin_li,
                NumHighCostMrtgRefin_mi, NumHighCostMrtgRefin_hinc.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( HMDA )

%let ADJ_YR = 2005;      ** Dollar amounts will be inflation adjusted to this year **;

/** Macro Hmda_dplace_reformat - Start Definition **/

%macro Hmda_dplace_reformat( year= );
  
  %global file_list var_list;

  %let yr = %substr( &year, 3, 2 );
  %let path = &_dcdata_path\hmda\data\HMDATR&yr._was.zip;
  
  %let var_list = 
     MrtgOrigMedAmtHomePur1_4m /* Median amount of mortgage loans for home purchase ($) */
     MrtgOrigMedAmtHomePur1_4m_a /* Median amount of mortgage loans for home purchase (adj. $) */
     NumMrtgPurchDenial /* Denials of conventional home purchase loans */
     DenMrtgPurchDenial /* Conventional home purchase mortgage loan applications */
     NumMrtgOrigHomePurch1_4m /* Mortgage loans for home purchase */
     NumConvMrtgOrigHomePurch /* Conventional mortgage loans for home purchase */
     NumConvMrtgOrigRefin /* Conventional mortgage loans for refinance */
     NumSubprimeConvOrigHomePur /* Conventional home purchase mortgage loans by subprime lenders */
     NumSubprimeConvOrigRefin /* Conventional refinance mortgage loans by subprime lenders */
     MrtgOrigPurchOwner1_4m /* Owner-occupied home purchase mortgage loans */
     MedianMrtgInc1_4m /* Median borrower income for owner-occupied home purchase loans ($) */
     MedianMrtgInc1_4m_adj /* Median borrower income for owner-occupied home purchase loans (adj. $) */
     
     NumMrtgOrig_vli /* Number of owner-occupied home purchase mortgage loan originations to borrowers that are very low-income for 1 to 4 family dwellings and manufactured homes */
     NumMrtgOrig_li /* Number of owner-occupied home purchase mortgage loan originations to borrowers that are low-income for 1 to 4 family dwellings and manufactured homes */
     NumMrtgOrig_mi /* Number of owner-occupied home purchase mortgage loan originations to borrowers that are middle-income for 1 to 4 family dwellings and manufactured homes */
     NumMrtgOrig_hinc /* Number of owner-occupied home purchase mortgage loan originations to borrowers that are high-income for 1 to 4 family dwellings and manufactured homes */
     NumMrtgOrig_Inc /* Number of owner-occupied home purchase mortgage loan originations with borrower income specified for 1 to 4 family dwellings and manufactured homes */

     NumMrtgOrigBlack /* Owner-occupied home purchase mortgage loans to Black borrowers */
     NumMrtgOrigWhite /* Owner-occupied home purchase mortgage loans to White borrowers */
     NumMrtgOrigHisp /* Owner-occupied home purchase mortgage loans to Hispanic borrowers */
     NumMrtgOrigAsianPI /* Owner-occupied home purchase mortgage loans to Asians */
     NumMrtgOrigOtherX /* Owner-occupied home purchase mortgage loans to other race borrowers */
     nummrtgorigwithrace /* Owner-occupied home purchase loans where borrower race is known */
     NumMrtgOrigRaceNotProvided /* Number of owner-occupied home purchase mortgage loan originations 
                                   to borrowers for 1 to 4 family dwellings and manufactured homes 
                                   whose race is not provided */

     NumMrtgPurchDenial_as /* Number of Asian/Pacific Islander applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_bl /* Number of Black applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_hi /* Number of Hispanic applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_wh /* Number of White applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_as /* Number of Asian/PI applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_bl /* Number of Black applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_hi /* Number of Hispanic applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_wh /* Number of White applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_vli /* Number of very low-income applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_li /* Number of low-income applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_mi /* Number of middle-income applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_hinc /* Number of high-income applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_vli /* Number of very low-income applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_li /* Number of low-income applicants  for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_mi /* Number of middle-income applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_hinc /* Number of high-income applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_as_vli /* Number of very low-income Asian/PI applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_bl_vli /* Number of very low-income Black applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_hi_vli /* Number of very low-income Hispanic applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_wh_vli /* Number of very low-income White applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_as_li /* Number of low-income Asian/PI applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_bl_li /* Number of low-income Black applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_hi_li /* Number of low-income Hispanic applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_wh_li /* Number of low-income White applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_as_mi /* Number of middle-income Asian/PI applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_bl_mi /* Number of middle-income Black applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_hi_mi /* Number of middle-income Hispanic applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_wh_mi /* Number of middle-income White applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_as_hinc /* Number of high-income Asian/PI applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_bl_hinc /* Number of high-income Black applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_hi_hinc /* Number of high-income Hispanic applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_wh_hinc /* Number of high-income White applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_as_vli /* Number of very low-income Asian/PI applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_bl_vli /* Number of very low-income Black applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_hi_vli /* Number of very low-income Hispanic applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_wh_vli /* Number of very low-income White applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_as_li /* Number of low-income Asian/PI applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_bl_li /* Number of low-income Black applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_hi_li /* Number of low-income Hispanic applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_wh_li /* Number of low-income White applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_as_mi /* Number of middle-income Asian/PI applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_bl_mi /* Number of middle-income Black applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_hi_mi /* Number of middle-income Hispanic applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_wh_mi /* Number of middle-income White applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_as_hinc /* Number of high-income Asian/PI applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_bl_hinc /* Number of high-income Black applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_hi_hinc /* Number of high-income Hispanic applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_wh_hinc /* Number of high-income White applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */

     NumSubprimeMrtgPurchAsianPI /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to Asian/Pacific Islander borrowers  */
     NumSubprimeMrtgPurchBlack /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to Black borrowers  */
     NumSubprimeMrtgPurchHisp /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to Hispanic borrowers  */
     NumSubprimeMrtgPurchWhite /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to White borrowers  */
     NumSubprimeMrtgRefinAsianPI /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to Asian/Pacific Islander borrowers  */
     NumSubprimeMrtgRefinBlack /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to Black borrowers  */
     NumSubprimeMrtgRefinHisp /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to Hispanic borrowers  */
     NumSubprimeMrtgRefinWhite /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to White borrowers  */
     DenSubprimeMrtgPurchAsianPI /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Asian/Pacific Islander borrowers  */
     DenSubprimeMrtgPurchBlack /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Black borrowers  */
     DenSubprimeMrtgPurchHisp /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Hispanic borrowers  */
     DenSubprimeMrtgPurchWhite /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to White borrowers  */
     DenSubprimeMrtgRefinAsianPI /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Asian/Pacific Islander borrowers  */
     DenSubprimeMrtgRefinBlack /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Black borrowers  */
     DenSubprimeMrtgRefinHisp /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Hispanic borrowers  */
     DenSubprimeMrtgRefinWhite /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to White borrowers  */

     NumMrtgOrigHomePurch_F /* Number of owner-occupied home purchase mortgage loan originations to female borrowers for 1 to 4 family dwellings and manufactured homes */
     NumMrtgOrigHomePurch_MF /* Number of owner-occupied home purchase mortgage loan originations to male and female co-borrowers for 1 to 4 family dwellings and manufactured homes */
     NumMrtgOrigHomePurch_M /* Number of owner-occupied home purchase mortgage loan originations to male borrowers for 1 to 4 family dwellings and manufactured homes */
     NumMrtgOrigHomePurch_SS /* Number of owner-occupied home purchase mortgage loan originations to co-borrowers of the same gender for 1 to 4 family dwellings and manufactured homes */
     NumMrtgOrigHomePurch_sex /* Number of owner-occupied home purchase mortgage loan originations with gender information for 1 to 4 family dwellings and manufactured homes */
     DenMrtgPurchDenial_MF /* Number of male and female co-applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes */
     DenMrtgPurchDenial_M /* Number of male applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_F /* Number of female applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_SS /* Number of same gender co-applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_MF /* Number of male and female co-applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_M /* Number of male applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_F /* Number of female applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_SS /* Number of same gender co-applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */

     DenMrtgPurchDenial_MF_vli /* Number of very low-income male and female co-applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_M_vli /* Number of very low-income male applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_F_vli /* Number of very low-income female applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_SS_vli /* Number of very low-income same gender co-applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_MF_vli /* Number of very low-income male and female co-applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_M_vli /* Number of very low-income male applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_F_vli /* Number of very low-income female applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_SS_vli /* Number of very low-income same gender co-applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_MF_li /* Number of low-income male and female co-applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_M_li /* Number of low-income male applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_F_li /* Number of low-income female applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_SS_li /* Number of low-income same gender co-applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_MF_li /* Number of low-income male and female co-applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_M_li /* Number of low-income male applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_F_li /* Number of low-income female applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_SS_li /* Number of low-income same gender co-applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_MF_mi /* Number of middle-income male and female co-applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_M_mi /* Number of middle-income male applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_F_mi /* Number of middle-income female applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_SS_mi /* Number of middle-income same gender co-applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_MF_mi /* Number of middle-income male and female co-applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_M_mi /* Number of middle-income male applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_F_mi /* Number of middle-income female applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_SS_mi /* Number of middle-income same gender co-applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_MF_hinc /* Number of high-income male and female co-applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_M_hinc /* Number of high-income male applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_F_hinc /* Number of high-income female applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     DenMrtgPurchDenial_SS_hinc /* Number of high-income same gender co-applicants for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_MF_hinc /* Number of high-income male and female co-applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_M_hinc /* Number of high-income male applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_F_hinc /* Number of high-income female applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */
     NumMrtgPurchDenial_SS_hinc /* Number of high-income same gender co-applicants that were denied for conventional home purchase mortgages for 1 to 4 family dwellings and manufactured homes  */

     NumSubprimeMrtgPurch_MF /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to male and female co-borrowers */
     NumSubprimeMrtgPurch_M /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to male borrowers */
     NumSubprimeMrtgPurch_F /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to female borrowers */
     NumSubprimeMrtgPurch_SS /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to borrowers of the same gender */
     NumSubprimeMrtgRefin_MF /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to male and female co-borrowers */
     NumSubprimeMrtgRefin_M /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to male borrowers */
     NumSubprimeMrtgRefin_F /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to female borrowers */
     NumSubprimeMrtgRefin_SS /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes by subprime lenders to borrowers of the same gender */
     DenSubprimeMrtgPurch_MF /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to male and female co-borrowers */
     DenSubprimeMrtgPurch_M /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to male borrowers */
     DenSubprimeMrtgPurch_F /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to female borrowers */
     DenSubprimeMrtgPurch_SS /* Number of conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to borrowers of the same gender */
     DenSubprimeMrtgRefin_MF /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to male and female co-borrowers */
     DenSubprimeMrtgRefin_M /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to male borrowers */
     DenSubprimeMrtgRefin_F /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to female borrowers */
     DenSubprimeMrtgRefin_SS /* Number of conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to borrowers of the same gender */

     NumHsngUnits1_4Fam /* Number of housing units, 1 to 4 family dwellings (consistent with HMDA definition), 2000 */
     NumSubprimeConvOrig /* Number of conventional mortgage loan originations by subprime lenders for all purposes */
     NumConvMrtgOrig /* Conventional mortgage loan originations for all purposes */
     NumSubprimeConvOrigHomeImp /* Number of conventional home improvement mortgage loan originations by subprime lenders for 1 to 4 family dwellings and manufactured homes */
     NumConvMrtgOrigHomeImprov /* Conventional mortgage loan originations for home improvement of 1 to 4 family dwellings and manufactured homes */

     DenSubprimeMrtgPurchOtherX /* Conventional home purchase mortgage loans to other race borrowers */
     DenSubprimeMrtgRefinOtherX /* Conventional refinancing mortgage loans to other race borrowers */
     NumSubprimeMrtgPurchOtherX /* Conventional home purchase loans by subprime lenders to other race borrowers */
     NumSubprimeMrtgRefinOtherX /* Conventional refinancing loans by subprime lenders to other race borrowers */

     DenSubprimeMrtgPurch_vli /* Conventional home purchase mortgage loans to very low-income borrowers */
     DenSubprimeMrtgPurch_li /* Conventional home purchase mortgage loans to low-income borrowers */
     DenSubprimeMrtgPurch_mi /* Conventional home purchase mortgage loans to middle-income borrowers */
     DenSubprimeMrtgPurch_hinc /* Conventional home purchase mortgage loans to high income borrowers */

     DenSubprimeMrtgRefin_vli /* Conventional refinancing mortgage loans to very low-income borrowers */
     DenSubprimeMrtgRefin_li /* Conventional refinancing mortgage loans to low-income borrowers */
     DenSubprimeMrtgRefin_mi /* Conventional refinancing mortgage loans to middle-income borrowers */
     DenSubprimeMrtgRefin_hinc /* Conventional refinancing mortgage loans to high-income borrowers */

     NumSubprimeMrtgPurch_vli /* Conventional home purchase loans by subprime lenders to very-low inc. borrowers */
     NumSubprimeMrtgPurch_li /* Conventional home purchase loans by subprime lenders to low-income borrowers */
     NumSubprimeMrtgPurch_mi /* Conventional home purchase loans by subprime lenders to middle-income borrowers */
     NumSubprimeMrtgPurch_hinc /* Conventional home purchase loans by subprime lenders to high-income borrowers */

     NumSubprimeMrtgRefin_vli /* Conventional refinancing loans by subprime lenders to very-low inc. borrowers */
     NumSubprimeMrtgRefin_li /* Conventional refinancing loans by subprime lenders to low-income borrowers */
     NumSubprimeMrtgRefin_mi /* Conventional refinancing loans by subprime lenders to middle-income borrowers */
     NumSubprimeMrtgRefin_hinc /* Conventional refinancing loans by subprime lenders to high-income borrowers */
  ;
   
  %if &year >= 2004 %then %do;
    %let var_list = &var_list
      NumHighCostConvOrig /* Conventional mortgage loan originations for all purposes with high interest rates */
      NumHighCostConvOrigPurch /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes with high interest rates */
      NumHighCostConvOrigImprov /* Conventional home improvement mortgage loan originations for 1 to 4 family dwellings and manufactured homes with high interest rates */
      NumHighCostConvOrigRefin /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes with high interest rates */
      DenHighCostConvOrig /* Conventional mortgage loan originations for all purposes with interest rate information */
      DenHighCostConvOrigPurch /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes with interest rate information */
      DenHighCostConvOrigImprov /* Conventional home improvement mortgage loan originations for 1 to 4 family dwellings and manufactured homes with interest rate information */
      DenHighCostConvOrigRefin /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes with interest rate information */

      NumHighCostMrtgPurch_as /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Asians with high interest rates */
      NumHighCostMrtgPurch_bl /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Blacks with high interest rates */
      NumHighCostMrtgPurch_hi /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Hispanics with high interest rates */
      NumHighCostMrtgPurch_wh /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Whites with high interest rates */
      DenHighCostMrtgPurch_as /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Asians with interest rate information */
      DenHighCostMrtgPurch_bl /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Blacks with interest rate information */
      DenHighCostMrtgPurch_hi /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Hispanics with interest rate information */
      DenHighCostMrtgPurch_wh /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Whites with interest rate information */
      NumHighCostMrtgRefin_as /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Asian borrowers with high interest rates  */
      NumHighCostMrtgRefin_bl /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Black borrowers with high interest rates  */
      NumHighCostMrtgRefin_hi /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Hispanic borrowers with high interest rates  */
      NumHighCostMrtgRefin_wh /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to White borrowers with high interest rates  */
      DenHighCostMrtgRefin_as /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Asian borrowers with interest rate information  */
      DenHighCostMrtgRefin_bl /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Black borrowers with interest rate information  */
      DenHighCostMrtgRefin_hi /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to Hispanic borrowers with interest rate information  */
      DenHighCostMrtgRefin_wh /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to White borrowers with interest rate information  */

      NumHighCostMrtgPurch_MF /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes with high interest rates to male and female co-borrowers */
      NumHighCostMrtgPurch_M /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes with high interest rates to male borrowers */
      NumHighCostMrtgPurch_F /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes with high interest rates to female borrowers */
      NumHighCostMrtgPurch_SS /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes with high interest rates to co-borrowers of the same gender */
      NumHighCostMrtgRefin_MF /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes with high interest rates to male and female co-borrowers */
      NumHighCostMrtgRefin_M /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes with high interest rates to male borrowers */
      NumHighCostMrtgRefin_F /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes with high interest rates to female borrowers */
      NumHighCostMrtgRefin_SS /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes with high interest rates to co-borrowers of the same gender */
      DenHighCostMrtgPurch_MF /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to male and female co-borrowers with interest rate information */
      DenHighCostMrtgPurch_M /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to male borrowers with interest rate information */
      DenHighCostMrtgPurch_F /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to female borrowers with interest rate information */
      DenHighCostMrtgPurch_SS /* Conventional home purchase mortgage loan originations for 1 to 4 family dwellings and manufactured homes to co-borrowers of the same gender with interest rate information */
      DenHighCostMrtgRefin_MF /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to male and female co-borrowers with interest rate information */
      DenHighCostMrtgRefin_M /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to male borrowers with interest rate information */
      DenHighCostMrtgRefin_F /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to female borrowers with interest rate information */
      DenHighCostMrtgRefin_SS /* Conventional refinancing mortgage loan originations for 1 to 4 family dwellings and manufactured homes to co-borrowers of the same gender with interest rate information */

      NumHighCostMrtgPurch_vli /* Conventional home purchase loans with high interest rates to very-low inc. borrowers */
      NumHighCostMrtgPurch_li /* Conventional home purchase loans with high interest rates to low-income borrowers */
      NumHighCostMrtgPurch_mi /* Conventional home purchase loans with high interest rates to middle-income borrowers */
      NumHighCostMrtgPurch_hinc /* Conventional home purchase loans with high interest rates to high-income borrowers */

      NumHighCostMrtgRefin_vli /* Conventional refinancing loans with high interest rates to very-low inc. borrowers */
      NumHighCostMrtgRefin_li /* Conventional refinancing loans with high interest rates to low-income borrowers */
      NumHighCostMrtgRefin_mi /* Conventional refinancing loans with high interest rates to middle-income borrowers */
      NumHighCostMrtgRefin_hinc /* Conventional refinancing loans with high interest rates to high-income borrowers */
    
    ;
  %end;

  libname Hmda&year "&path";

  %if &year = 2006 %then %do;
  
    proc sort data=HMDA.dc_dplex_hmda_summary_&yr out=HMDATR&yr._was_new (compress=no);
      by stfid;
      
  %end;
      
  %else %if &year = 2005 %then %do;
  
    proc sort data=HMDA&year..HMDATR&yr._was out=HMDATR&yr._was (compress=no);
      by stfid;
      
    proc sort data=HMDA.dc_dplex_hmda_summary_05 out=dc_dplex_hmda_summary_05 (compress=no);
      by stfid;
      
    data HMDATR&yr._was_new (compress=no);
    
      merge
        HMDATR&yr._was
          (drop=
            NumSubprimeConvOrig NumSubprimeConvOrigHomeImprov NumSubprimeConvOrigHomePurch
            NumSubprimeConvOrigMultifam NumSubprimeConvOrigRefin NumSubprimeGovtMrtgOrig
            NumSubprimeGovtMrtgOrigHomeImpr NumSubprimeGovtMrtgOrigHomePurch
            NumSubprimeGovtMrtgOrigMultifam NumSubprimeGovtMrtgOrigRefin
            NumSubprimeMrtgPurch_F NumSubprimeMrtgPurch_M NumSubprimeMrtgPurch_MF
            NumSubprimeMrtgPurch_sexna NumSubprimeMrtgPurch_sexnp NumSubprimeMrtgPurch_SS
            NumSubprimeMrtgPurchAmerInd NumSubprimeMrtgPurchAsianPI
            NumSubprimeMrtgPurchBlack NumSubprimeMrtgPurchHisp NumSubprimeMrtgPurchMin
            NumSubprimeMrtgPurchMultiple NumSubprimeMrtgPurchMxd
            NumSubprimeMrtgPurchNotApplic NumSubprimeMrtgPurchNotProvided
            NumSubprimeMrtgPurchOther NumSubprimeMrtgPurchWhite NumSubprimeMrtgRefin_F
            NumSubprimeMrtgRefin_M NumSubprimeMrtgRefin_MF NumSubprimeMrtgRefin_sexna
            NumSubprimeMrtgRefin_sexnp NumSubprimeMrtgRefin_SS NumSubprimeMrtgRefinAmerInd
            NumSubprimeMrtgRefinAsianPI NumSubprimeMrtgRefinBlack NumSubprimeMrtgRefinHisp
            NumSubprimeMrtgRefinMin NumSubprimeMrtgRefinMultiple NumSubprimeMrtgRefinMxd
            NumSubprimeMrtgRefinNotApplic NumSubprimeMrtgRefinNotProvided
            NumSubprimeMrtgRefinOther NumSubprimeMrtgRefinWhite
          )
        dc_dplex_hmda_summary_05;
      by stfid;
      
    run;
      
  %end;

  data Hmda_sum_tr00_&year (compress=no);

    %if &year >= 2005 %then %do;
      set 
        HMDATR&yr._was_new
        (drop=year
         rename=(
           stfid=Geo2000
           /** Need to rename vars w/names longer than 27 chars. **/
           /*NumMrtgOrigHomeImprov1_4mPerUnit=NumMrtgOrigHomeImprov1_4mPU*/
           NumSubprimeConvOrigHomePurch=NumSubprimeConvOrigHomePur
           NumSubprimeConvOrigHomeImprov=NumSubprimeConvOrigHomeImp
           MrtgOrigMedAmtHomePurch1_4m=MrtgOrigMedAmtHomePur1_4m
           /*PctSubprimeConvOrigHomePurch=PctSubprimeConvOrigHomePur*/
         ))
         ;
    %end;
    %else %do;
    merge 
      HMDA&year..HMDATR&yr._was 
        (drop=year
         rename=(
           stfid=Geo2000
           /** Need to rename vars w/names longer than 27 chars. **/
           /*NumMrtgOrigHomeImprov1_4mPerUnit=NumMrtgOrigHomeImprov1_4mPU*/
           NumSubprimeConvOrigHomePurch=NumSubprimeConvOrigHomePur
           NumSubprimeConvOrigHomeImprov=NumSubprimeConvOrigHomeImp
           MrtgOrigMedAmtHomePurch1_4m=MrtgOrigMedAmtHomePur1_4m
           /*PctSubprimeConvOrigHomePurch=PctSubprimeConvOrigHomePur*/
         ))
       Hmda.Hmdatr&yr._sup (drop=year);
    by Geo2000;
    %end;
    where Geo2000 =: "11";

    if put( Geo2000, $geo00v. ) = '' then do;
      %warn_put( msg='Invalid tract no. ' Geo2000= )
    end;
      
    ** Need to recreate YEAR var because in some files it is numeric,
    ** and others it is character.;
    
    Year = &year;

    format _all_;
    informat _all_;
    
    keep 
      Geo2000 
      year 
      &var_list
    ;
    
    label
      Year = 'Year of data'
      Geo2000 = 'Full census tract ID (2000): ssccctttttt'
      NumHsngUnits1_4Fam = 'Number of housing units, 1 to 4 families (HMDA def., 2000 Census)';
    
    ** Other race **;

    NumMrtgOrigOtherX = 
      max( nummrtgorigwithrace - sum( NumMrtgOrigBlack, NumMrtgOrigWhite, NumMrtgOrigHisp, NumMrtgOrigAsianPI ), 0 );

    label 
      NumMrtgOrigOtherX = "Owner-occupied home purchase mortgage loans to other race borrowers";

    DenSubprimeMrtgPurchOtherX = sum( 
      %if &year >= 2004 %then %do;
        DenSubprimeMrtgPurchMultiple,
      %end;
      DenSubprimeMrtgPurchAmerInd,
      DenSubprimeMrtgPurchOther,
      DenSubprimeMrtgPurchMxd
    );

    DenSubprimeMrtgRefinOtherX = sum(
      %if &year >= 2004 %then %do;
        DenSubprimeMrtgRefinMultiple,
      %end;
      DenSubprimeMrtgRefinAmerInd,
      DenSubprimeMrtgRefinOther,
      DenSubprimeMrtgRefinMxd
    );

    NumSubprimeMrtgPurchOtherX = sum( 
      %if &year >= 2004 %then %do;
        NumSubprimeMrtgPurchMultiple,
      %end;
      NumSubprimeMrtgPurchAmerInd,
      NumSubprimeMrtgPurchOther,
      NumSubprimeMrtgPurchMxd
    );

    NumSubprimeMrtgRefinOtherX = sum(
      %if &year >= 2004 %then %do;
        NumSubprimeMrtgRefinMultiple,
      %end;
      NumSubprimeMrtgRefinAmerInd,
      NumSubprimeMrtgRefinOther,
      NumSubprimeMrtgRefinMxd
    );
    
    label
      DenSubprimeMrtgPurchOtherX = "Conventional home purchase mortgage loans to other race borrowers"
      DenSubprimeMrtgRefinOtherX = "Conventional refinancing mortgage loans to other race borrowers"
      NumSubprimeMrtgPurchOtherX = "Conventional home purchase loans by subprime lenders to other race borrowers"
      NumSubprimeMrtgRefinOtherX = "Conventional refinancing loans by subprime lenders to other race borrowers"
    ;

    ** Inflation adjusted dollar amounts **;
    
    %dollar_convert( MrtgOrigMedAmtHomePur1_4m, MrtgOrigMedAmtHomePur1_4m_a, &year, &ADJ_YR )
    %dollar_convert( MedianMrtgInc1_4m, MedianMrtgInc1_4m_adj, &year, &ADJ_YR )
    
    label 
      MrtgOrigMedAmtHomePur1_4m = "Median loan amount for home purchase of 1 to 4 family units ($)"
      MrtgOrigMedAmtHomePur1_4m_a = "Median loan amount for home purchase of 1 to 4 family units (&ADJ_YR $)"
      MedianMrtgInc1_4m = "Median borrower income for owner-occ. purch. loans (1 to 4 fam.) ($)"
      MedianMrtgInc1_4m_adj = "Median borrower income for owner-occ. purch. loans (1 to 4 fam.) (&ADJ_YR $)"
    ;
    
  run;

  proc sort data=Hmda_sum_tr00_&year;
    by geo2000;
  run;
  
  %let file_list = &file_list Hmda_sum_tr00_&year;

  /*
  %File_info( data=Hmda_sum_tr00_&year, printobs=0 )
  */
  
%mend Hmda_dplace_reformat;

/** End Macro Definition **/


** Reformat input data sets **;

%Hmda_dplace_reformat( year=1997 )
%Hmda_dplace_reformat( year=1998 )
%Hmda_dplace_reformat( year=1999 )
%Hmda_dplace_reformat( year=2000 )
%Hmda_dplace_reformat( year=2001 )
%Hmda_dplace_reformat( year=2002 )
%Hmda_dplace_reformat( year=2003 )
%Hmda_dplace_reformat( year=2004 )
%Hmda_dplace_reformat( year=2005 )
%Hmda_dplace_reformat( year=2006 )

%put file_list=&file_list;

** Combine years together **;

data Hmda_sum_tr00_all_years (compress=no);

  set &file_list;
  by geo2000 year;
  
run;

** Transpose by year **;

%Super_transpose(  
  data=Hmda_sum_tr00_all_years,
  out=Hmda_sum_tr00,
  var=&var_list,
  id=year,
  by=geo2000,
  mprint=N
)

** Remove vars missing in certain years **;

data Hmda.Hmda_sum_tr00 (label="HMDA summary, DC, Census tract (2000)");
  set Hmda_sum_tr00;
  drop 
    NumHighCostConvOrig_1997-NumHighCostConvOrig_2003
    NumHighCostConvOrigPurch_1997-NumHighCostConvOrigPurch_2003
    NumHighCostConvOrigImprov_1997-NumHighCostConvOrigImprov_2003
    NumHighCostConvOrigRefin_1997-NumHighCostConvOrigRefin_2003
    DenHighCostConvOrig_1997-DenHighCostConvOrig_2003
    DenHighCostConvOrigPurch_1997-DenHighCostConvOrigPurch_2003
    DenHighCostConvOrigImprov_1997-DenHighCostConvOrigImprov_2003
    DenHighCostConvOrigRefin_1997-DenHighCostConvOrigRefin_2003
    NumHighCostMrtgPurch_as_1997-NumHighCostMrtgPurch_as_2003
    NumHighCostMrtgPurch_bl_1997-NumHighCostMrtgPurch_bl_2003
    NumHighCostMrtgPurch_hi_1997-NumHighCostMrtgPurch_hi_2003
    NumHighCostMrtgPurch_wh_1997-NumHighCostMrtgPurch_wh_2003
    DenHighCostMrtgPurch_as_1997-DenHighCostMrtgPurch_as_2003
    DenHighCostMrtgPurch_bl_1997-DenHighCostMrtgPurch_bl_2003
    DenHighCostMrtgPurch_hi_1997-DenHighCostMrtgPurch_hi_2003
    DenHighCostMrtgPurch_wh_1997-DenHighCostMrtgPurch_wh_2003
    NumHighCostMrtgRefin_as_1997-NumHighCostMrtgRefin_as_2003
    NumHighCostMrtgRefin_bl_1997-NumHighCostMrtgRefin_bl_2003
    NumHighCostMrtgRefin_hi_1997-NumHighCostMrtgRefin_hi_2003
    NumHighCostMrtgRefin_wh_1997-NumHighCostMrtgRefin_wh_2003
    DenHighCostMrtgRefin_as_1997-DenHighCostMrtgRefin_as_2003
    DenHighCostMrtgRefin_bl_1997-DenHighCostMrtgRefin_bl_2003
    DenHighCostMrtgRefin_hi_1997-DenHighCostMrtgRefin_hi_2003
    DenHighCostMrtgRefin_wh_1997-DenHighCostMrtgRefin_wh_2003
    NumHighCostMrtgPurch_MF_1997-NumHighCostMrtgPurch_MF_2003
    NumHighCostMrtgPurch_M_1997-NumHighCostMrtgPurch_M_2003
    NumHighCostMrtgPurch_F_1997-NumHighCostMrtgPurch_F_2003
    NumHighCostMrtgPurch_SS_1997-NumHighCostMrtgPurch_SS_2003
    NumHighCostMrtgRefin_MF_1997-NumHighCostMrtgRefin_MF_2003
    NumHighCostMrtgRefin_M_1997-NumHighCostMrtgRefin_M_2003
    NumHighCostMrtgRefin_F_1997-NumHighCostMrtgRefin_F_2003
    NumHighCostMrtgRefin_SS_1997-NumHighCostMrtgRefin_SS_2003
    DenHighCostMrtgPurch_MF_1997-DenHighCostMrtgPurch_MF_2003
    DenHighCostMrtgPurch_M_1997-DenHighCostMrtgPurch_M_2003
    DenHighCostMrtgPurch_F_1997-DenHighCostMrtgPurch_F_2003
    DenHighCostMrtgPurch_SS_1997-DenHighCostMrtgPurch_SS_2003
    DenHighCostMrtgRefin_MF_1997-DenHighCostMrtgRefin_MF_2003
    DenHighCostMrtgRefin_M_1997-DenHighCostMrtgRefin_M_2003
    DenHighCostMrtgRefin_F_1997-DenHighCostMrtgRefin_F_2003
    DenHighCostMrtgRefin_SS_1997-DenHighCostMrtgRefin_SS_2003
    NumHighCostMrtgPurch_vli_1997 NumHighCostMrtgPurch_vli_1998
    NumHighCostMrtgPurch_vli_1999 NumHighCostMrtgPurch_vli_2000
    NumHighCostMrtgPurch_vli_2001 NumHighCostMrtgPurch_vli_2002
    NumHighCostMrtgPurch_vli_2003 NumHighCostMrtgPurch_li_1997
    NumHighCostMrtgPurch_li_1998 NumHighCostMrtgPurch_li_1999
    NumHighCostMrtgPurch_li_2000 NumHighCostMrtgPurch_li_2001
    NumHighCostMrtgPurch_li_2002 NumHighCostMrtgPurch_li_2003
    NumHighCostMrtgPurch_mi_1997 NumHighCostMrtgPurch_mi_1998
    NumHighCostMrtgPurch_mi_1999 NumHighCostMrtgPurch_mi_2000
    NumHighCostMrtgPurch_mi_2001 NumHighCostMrtgPurch_mi_2002
    NumHighCostMrtgPurch_mi_2003 NumHighCostMrtgPurch_hinc_1997
    NumHighCostMrtgPurch_hinc_1998 NumHighCostMrtgPurch_hinc_1999
    NumHighCostMrtgPurch_hinc_2000 NumHighCostMrtgPurch_hinc_2001
    NumHighCostMrtgPurch_hinc_2002 NumHighCostMrtgPurch_hinc_2003
    NumHighCostMrtgRefin_vli_1997 NumHighCostMrtgRefin_vli_1998
    NumHighCostMrtgRefin_vli_1999 NumHighCostMrtgRefin_vli_2000
    NumHighCostMrtgRefin_vli_2001 NumHighCostMrtgRefin_vli_2002
    NumHighCostMrtgRefin_vli_2003 NumHighCostMrtgRefin_li_1997
    NumHighCostMrtgRefin_li_1998 NumHighCostMrtgRefin_li_1999
    NumHighCostMrtgRefin_li_2000 NumHighCostMrtgRefin_li_2001
    NumHighCostMrtgRefin_li_2002 NumHighCostMrtgRefin_li_2003
    NumHighCostMrtgRefin_mi_1997 NumHighCostMrtgRefin_mi_1998
    NumHighCostMrtgRefin_mi_1999 NumHighCostMrtgRefin_mi_2000
    NumHighCostMrtgRefin_mi_2001 NumHighCostMrtgRefin_mi_2002
    NumHighCostMrtgRefin_mi_2003 NumHighCostMrtgRefin_hinc_1997
    NumHighCostMrtgRefin_hinc_1998 NumHighCostMrtgRefin_hinc_1999
    NumHighCostMrtgRefin_hinc_2000 NumHighCostMrtgRefin_hinc_2001
    NumHighCostMrtgRefin_hinc_2002 NumHighCostMrtgRefin_hinc_2003      
  ;
  
run;

%File_info( data=Hmda.Hmda_sum_tr00, printobs=0 )

