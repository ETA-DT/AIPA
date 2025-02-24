﻿601,100
562,"CHARACTERDELIMITED"
586,"Defined to prolog"
585,"\\TFR-AP019292\tm1data\FR\Input\Data_Country\FR_Data_ST_Currency.csv"
564,
565,"cJBa:58n\Q]_u56VgttrFUxkll2ACqtWXCJwAhS^\eG6OyId;N6F9[wmZWE7OMNbS7@_G3blAW5RjbP6s=[YALeA@cYXCNvcXjfyDGR1UG\2g]R\FcLdfui0JB9;E=gNQUj=44qnYwoLLQE6Xxg@p6e;5SvK=ep`8;RpV??YUpZ8]x3i\3Nc_JQt[d3SfR0w<NhISI^8"
559,1
928,0
593,
594,
595,
597,
598,
596,
800,
801,
566,0
567,";"
588,","
589," "
568,""""
570,Par défaut
571,
569,0
592,0
599,1000
560,0
561,0
590,0
637,0
577,6
vPeriod
vCurrencyConvertTo
vPhase
vCurrency
vType_Rate
Value
578,6
2
2
2
2
2
1
579,6
1
2
3
4
5
6
580,6
0
0
0
0
0
0
581,6
0
0
0
0
0
0
582,7
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
IgnoredInputVarName=V7VarType=33ColType=1165
572,201
#########################################
# Project : Tango - Multi-instance
# Created by : MBO
# Created at : 12/12/2011
# Modified by : MRE
# Modified at : 20/03/2012
# Modify reason : Add the "Full_Year" possibility in period
#########################################


#****Begin: Generated Statements***
#****End: Generated Statements****


zCube = 'ST_Currency';
zCube_Reject = 'ZZ_PROCESS_REJECT_INSTANCE';


Nb_Lign = 0;
Nb_Reject = 0;
Nb_Load = 0;

zProcess = 'Import_BUDGET_FC_ST_Currency';
zDateLoadingStart = TIMST(now,'\Y-\M-\D');
zDateTimeLoadingStart = TIMST(now,'\Y-\M-\D \h:\i:\s');

pPeriod = CellGetS( 'z_Admin_Param' , 'PERIOD' , 'STR_VAR1');
ParamPhase = CellGetS( 'z_Admin_Param' , 'TYPE_PHASE' , 'STR_VAR1');
pCountry = CellGetS( 'z_Admin_Param' , 'COUNTRY' , 'STR_VAR1');

Source_File = '\\'| CellGetS( 'z_Admin_Param_Instance' , 'SERVER_NAME' , pCountry , 'STR_VAR1' ) 
| CellGetS( 'z_Admin_Param_instance' , 'REP_CM_DATA_EXPORT' ,pCountry, 'STR_VAR1') | pCountry
 | CellGetS( 'z_Admin_Param_instance' , 'REP_DATA_EXPORT' ,pCountry, 'STR_VAR1') | '\' |  pCountry | '_Data_BUDGET_FC_' | zCube | '.csv';

DataSourceNameForServer = Source_File;


#################################################################################
#                                                               Clear Reject Cube
#################################################################################

######
#Call process DB_zz_Date_Time_loading in order to add the new day in the dimension zz_Date_Time_loading
ExecuteProcess('DB_zz_Date_Time_loading');
######

P_NAME_RAZ = zCube_Reject | '_RAZ';
ViewDestroy( zCube_Reject , P_NAME_RAZ );
ViewCreate( zCube_Reject , P_NAME_RAZ );

#-- Create subset in zz_Date_Time_loading and }Processes
IF( SubsetExists( 'zz_Date_Time_loading' , P_NAME_RAZ ) = 1 );
    SubsetDeleteAllElements( 'zz_Date_Time_loading' , P_NAME_RAZ );
ELSE;
    SubsetCreate( 'zz_Date_Time_loading' , P_NAME_RAZ );
ENDIF;

IF( SubsetExists( '}Processes' , P_NAME_RAZ ) = 1 );
    SubsetDeleteAllElements( '}Processes' , P_NAME_RAZ);
ELSE;
    SubsetCreate( '}Processes' , P_NAME_RAZ );
ENDIF;

IF( SubsetExists( 'zz_Process_Source' , P_NAME_RAZ ) = 1 );
    SubsetDeleteAllElements( 'zz_Process_Source' , P_NAME_RAZ);
ELSE;
    SubsetCreate( 'zz_Process_Source' , P_NAME_RAZ );
ENDIF;

SubsetElementInsert( 'zz_Date_Time_loading' , P_NAME_RAZ ,zDateLoadingStart , 1 );
SubsetElementInsert( '}Processes' , P_NAME_RAZ , zProcess , 1 );
SubsetElementInsert( 'zz_Process_Source' , P_NAME_RAZ , pCountry , 1 );

ViewSubsetAssign( zCube_Reject , P_NAME_RAZ , 'zz_Date_Time_loading' , P_NAME_RAZ);
ViewSubsetAssign( zCube_Reject , P_NAME_RAZ , '}Processes', P_NAME_RAZ);
ViewSubsetAssign( zCube_Reject , P_NAME_RAZ , 'zz_Process_Source', P_NAME_RAZ);

#-- Update subset
ViewExtractSkipZeroesSet ( zCube_Reject , P_NAME_RAZ , 1 );
ViewExtractSkipRuleValuesSet ( zCube_Reject , P_NAME_RAZ , 1 );
ViewExtractSkipCalcsSet ( zCube_Reject , P_NAME_RAZ , 1 );

#-- Clear cube
ViewZeroOut( zCube_Reject , P_NAME_RAZ );

#-- Delete subset
ViewDestroy( zCube_Reject , P_NAME_RAZ );
SubsetDestroy( 'zz_Date_Time_loading' , P_NAME_RAZ );
SubsetDestroy( '}Processes' , P_NAME_RAZ );



#################################################################################
#                                                               Clear CUBE
#################################################################################
P_NAME_RAZ = zCube | '_RAZ';
ViewDestroy( zCube , P_NAME_RAZ );
ViewCreate( zCube , P_NAME_RAZ );

############# Create subset in Period #############

IF( SubsetExists( 'Period' , P_NAME_RAZ ) = 1 );
    SubsetDeleteAllElements( 'Period' , P_NAME_RAZ );
ELSE;
    SubsetCreate( 'Period' , P_NAME_RAZ );
ENDIF;
If( SUBST(pPeriod, 1, 6)@='F_year' );
    SubsetElementInsert( 'Period' , P_NAME_RAZ , pPeriod , 1 );
Else;
    i=1;
    WHILE( i < DIMSIZ ( 'Period' )+1 );
        ElemP = DIMNM( 'Period' , i );
        IF( ELLEV( 'Period' , ElemP ) = 0 & ELISANC( 'Period' , pPeriod , ElemP) > 0 );
            SubsetElementInsert( 'Period' , P_NAME_RAZ , ElemP , 1 );
        ENDIF;
        i=i+1;
    END;
Endif;
ViewSubsetAssign( zCube , P_NAME_RAZ , 'Period' , P_NAME_RAZ );


########################### Create subset in Phase ###########################

IF( SubsetExists( 'Phase' , P_NAME_RAZ ) =1 );
    SubsetDeleteAllElements( 'Phase' , P_NAME_RAZ );
ELSE;
    SubsetCreate( 'Phase' , P_NAME_RAZ );
ENDIF;

IF(ParamPhase @= 'Budget');
   
   i= 0;
   While (i <= 7 );
      pPhase = 'BUDG_V'|NumberToString(i + 2);
      pPhase2 = 'MAN_BUDG_V'|NumberToString(i + 2);   
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , pPhase , i );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , pPhase2 , i );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , 'BUDG' , 1 );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , 'MAN_BUDG' , 1 );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , 'BUDG_VC' , 1 );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , 'MAN_BUDG_VC' , 1 );

      i=i+1;
   END;
ENDIF;

IF(ParamPhase @= 'Forecast1');

   i= 0;
   While (i <= 7 );
      pPhase = 'FC_1_V'|NumberToString(i + 2);
      pPhase2 = 'MAN_FC_1_V'|NumberToString(i + 2);   
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , pPhase , i );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , pPhase2 , i );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , 'FC_1' , 1 );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , 'MAN_FC_1' , 1 );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , 'FC_1_VC' , 1 );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , 'MAN_FC_1_VC' , 1 );


      i=i+1;
   END;
ENDIF;

IF(ParamPhase @= 'Forecast2');

   i= 0;
   While (i <= 7 );
      pPhase = 'FC_2_V'|NumberToString(i + 2);
      pPhase2 = 'MAN_FC_2_V'|NumberToString(i + 2);   
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , pPhase , i );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , pPhase2 , i );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , 'FC_2' , 1 );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , 'MAN_FC_2' , 1 );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , 'FC_2_VC' , 1 );
      SubsetElementInsert( 'Phase' , P_NAME_RAZ , 'MAN_FC_2_VC' , 1 );

      i=i+1;
   END;

ENDIF;
ViewSubsetAssign( zCube , P_NAME_RAZ , 'Phase' , P_NAME_RAZ );

#-- Clear cube
ViewZeroOut( zCube , P_NAME_RAZ );

#-- Update subset
ViewExtractSkipZeroesSet ( zCube , P_NAME_RAZ , 1 );
ViewExtractSkipRuleValuesSet ( zCube , P_NAME_RAZ , 1 );
ViewExtractSkipCalcsSet ( zCube , P_NAME_RAZ , 1 );

#-- Delete subset
ViewDestroy( zCube , P_NAME_RAZ );
SubsetDestroy( 'Period' , P_NAME_RAZ );
SubsetDestroy( 'Phase' , P_NAME_RAZ );






573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,27

#****Begin: Generated Statements***
#****End: Generated Statements****


pSource ='CORE_MODEL';

zRecord = vPeriod | ';' | vCurrencyConvertTo | ';' | vPhase | ';' | vCurrency | ';' | vType_Rate | ';' | NumberToString( Value ) ;

#################################################################################
#                                                                             REJECT SECTION
#################################################################################
Nb_lign = Nb_lign + 1;


################################################################################
#                                                               INPUT SECTION : Cube => ST_Currency
################################################################################

#-- => ST_Currency
CellPutN( Value , zCube , vPeriod , vPhase , vCurrency , vCurrencyConvertTo , vType_Rate );

Nb_Load = Nb_Load + 1;




575,63

#****Begin: Generated Statements***
#****End: Generated Statements****






zDateTimeLoadingEnd = TIMST(now,'\Y-\M-\D \h:\i:\s');
#################################################################################
#                                                                             PROCESS with PERIOD and INSTANCE
#################################################################################
zCube_Process_PP = 'ZZ_PROCESS_Detail_Instance';
pChore='Task6_CO_Import_CO_Data';

pInstance=CellGetS( 'z_Admin_Param' , 'COUNTRY' , 'STR_VAR1');
pSource ='CORE_MODEL';

pPeriod=CellGetS( 'z_Admin_Param' , 'PERIOD' , 'STR_VAR1');

CellPutS(zDateTimeLoadingStart , zCube_Process_PP, pChore, zProcess ,pPeriod,zDateLoadingStart, pInstance ,pSource ,'Start_date');
CellPutS(zDateTimeLoadingEnd , zCube_Process_PP, pChore, zProcess ,pPeriod,zDateLoadingStart, pInstance ,pSource ,'End_date');

CellPutS( NumberToString(nb_lign) , zCube_Process_PP , pChore , zProcess , pPeriod , zDateLoadingStart , pInstance ,pSource , 'Nb_Input_records');
CellPutS( NumberToString(nb_reject) , zCube_Process_PP , pChore , zProcess , pPeriod , zDateLoadingStart ,pInstance ,pSource , 'Nb_reject_records');
CellPutS( NumberToString(nb_load) , zCube_Process_PP , pChore , zProcess , pPeriod , zDateLoadingStart , pInstance ,pSource , 'Nb_load_records');

CellPutS('OK' ,zCube_Process_PP, pChore, zProcess ,pPeriod,zDateLoadingStart, pInstance ,pSource , 'Status');

IF( Nb_Lign = Nb_Load);
    CellPutS( 'OK' , zCube_Process_PP, pChore , zProcess , pPeriod , zDateLoadingStart , 
    pInstance ,pSource, 'Status');
ELSE;
    CellPutS( 'KO' , zCube_Process_PP, pChore , zProcess , pPeriod , zDateLoadingStart , 
   pInstance ,pSource , 'Status');
ENDIF; 



#################################################################################
#                                                                             DETAIL PROCESS SECTION
#################################################################################
zCube_Process = 'ZZ_PROCESS_DETAIL';

CellPutS(zDateTimeLoadingStart , zCube_Process , zProcess ,zDateLoadingStart , 'Start_date');
CellPutS(zDateTimeLoadingEnd , zCube_Process,  zProcess ,zDateLoadingStart  , 'End_date');
CellPutS(numbertostring(nb_lign) , zCube_Process , zProcess ,zDateLoadingStart  , 'Nb_Input_records');
CellPutS(numbertostring(nb_reject) , zCube_Process, zProcess ,zDateLoadingStart  , 'Nb_reject_records');
CellPutS(numbertostring(nb_load) , zCube_Process , zProcess ,zDateLoadingStart , 'Nb_load_records');

IF(nb_lign = nb_load);
    CellPutS( 'OK', zCube_Process, zProcess ,zDateLoadingStart, 'Status');
ELSE;
    CellPutS( 'KO', zCube_Process, zProcess ,zDateLoadingStart, 'Status');
    ItemReject( ' Process exited with errors at ' | TIME |  ' on ' | TODAY | '=> Check cubes : zz_Process_Detail_instance and  zz_Process_Reject_insta
nce' );
ENDIF;

#################################################################################
#                                                                             END PROCESS
#################################################################################

576,CubeAction=1511DataAction=1503CubeLogChanges=0
638,1
804,0
1217,1
900,
901,
902,
903,
906,
929,
907,
908,
904,0
905,0
909,0
911,
912,
913,
914,
915,
916,
917,0
918,1
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
