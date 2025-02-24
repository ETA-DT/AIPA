601,100
562,"VIEW"
586,"TC_CONTRACT_ECO_MO_TYP_CLI"
585,"TC_CONTRACT_ECO_MO_TYP_CLI"
564,
565,"uveaRefa`UZ[M41x`Gv96aa3S76^Gx;^vXP:eu?iczbpdzHDVHIbe?P>b\\Uv8Ce3O@F6@xpo\nVO?HV0kuBc3[3SEvK=CqoCS=J23UJ6HN`v5B_lll2o;CTzi6@y_AXcwuJlUj`S1:dwijaus;FJO\DFT2y1dO3_5V9Yg_d;Z=t[iX];f0`WHN@mIu\yVVJ;4h<1uAA"
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
567,","
588,","
589,
568,""""
570,Export_data
571,
569,0
592,0
599,1000
560,0
561,0
590,0
637,0
577,8
Activity
Legal_Organization
Management_Organization
z_Str_Var
Value
NVALUE
SVALUE
VALUE_IS_STRING
578,8
2
2
2
2
2
1
2
1
579,8
1
2
3
4
5
0
0
0
580,8
0
0
0
0
0
0
0
0
581,8
0
0
0
0
0
0
0
0
582,5
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
572,67
#########################################
# Project : Tango - Multi-instance
# Created by  : NEK
# Created at : 24/10/2011
# Modified by : MBO
# Modified at : 14/11/2011
# Modify reason :
#########################################


#****Begin: Generated Statements***
#****End: Generated Statements****



DatasourceASCIIDelimiter =';';

zCube = 'TC_CONTRACT_ECO_MO_TYP_CLI';
zProcess = 'Export_CM_TC_CONTRACT_ECO_MO_TYP_CLI';

nb_lign = 0;
nb_load = 0;

zDateLoadingStart = TIMST(now,'\Y-\M-\D');
zDateTimeLoadingStart = TIMST(now,'\Y-\M-\D \h:\i:\s');

pCountry=CellGetS( 'z_Admin_Param' , 'COUNTRY' , 'STR_VAR1');

Export_File ='\\'| CellGetS( 'z_Admin_Param_Instance' , 'SERVER_NAME' , 'CM','STR_VAR1') |  CellGetS( 'z_Admin_Param_Instance' , 'REP_CO_STRUC_EXPORT' , 'CM','STR_VAR1') | pCountry | '_Mapping_' | zCube | '.csv';

######
#Call process DB_zz_Date_Time_loading in order to add the new day in the dimension zz_Date_Time_loading
ExecuteProcess('DB_zz_Date_Time_loading');
######

#############################################################
#                                                       Source CUBE 
#############################################################
P_NAME_SOURCE = zCube | '_Vue';
ViewDestroy( zCube , P_NAME_SOURCE );
ViewCreate( zCube , P_NAME_SOURCE );

#-- Create subset in Legal_Organization
SubsetDestroy( 'Legal_Organization' , P_NAME_SOURCE );
SubsetCreate( 'Legal_Organization' , P_NAME_SOURCE );
i=1;
WHILE( i < DIMSIZ ( 'Legal_Organization' ) + 1 );
   ElemE = DIMNM( 'Legal_Organization' , i );
      IF ( ATTRS ( 'Legal_Organization' , ElemE , 'Country_entity' ) @= pCountry ) ;
           SubsetElementInsert( 'Legal_Organization' , P_NAME_SOURCE , ElemE , 1 );
      ENDIF;
    i=i+1;
END;
ViewSubsetAssign( zCube , P_NAME_SOURCE , 'Legal_Organization' , P_NAME_SOURCE );


#-- Update subset
ViewExtractSkipZeroesSet ( zCube , P_NAME_SOURCE , 1 );
ViewExtractSkipRuleValuesSet ( zCube , P_NAME_SOURCE , 1 );
ViewExtractSkipCalcsSet ( zCube , P_NAME_SOURCE , 1 );


DatasourceNameForServer = zCube ;
DatasourceCubeview = P_NAME_SOURCE ;



573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,11

#****Begin: Generated Statements***
#****End: Generated Statements****



Nb_Lign = Nb_Lign + 1;

ASCIIOUTPUT( Export_File , Activity , Legal_Organization , Management_Organization , z_Str_Var , Value );

Nb_Load = Nb_Load + 1;
575,45

#****Begin: Generated Statements***
#****End: Generated Statements****


#-- Suppress view
ViewDestroy( zCube , P_NAME_SOURCE );
SubsetDestroy( 'Legal_Organization' , P_NAME_SOURCE );

zDateTimeLoadingEnd = TIMST(now,'\Y-\M-\D \h:\i:\s');
#################################################################################
#                                                                             PROCESS with PERIOD and INSTANCE
#################################################################################
zCube_Process_PP = 'ZZ_PROCESS_Detail_Instance';

pChore = 'Task4_CO_Import_Vector_Parameter_Export_CM_Data_' | pCountry;

pSource = pCountry;
pPeriod = CellGetS( 'z_Admin_Param' , 'MONTH_ACTUAL' , 'STR_VAR1');

CellPutS( zDateTimeLoadingStart , zCube_Process_PP , pChore , zProcess , pPeriod , zDateLoadingStart , 
pCountry , pSource , 'Start_date');
CellPutS( zDateTimeLoadingEnd , zCube_Process_PP , pChore , zProcess , pPeriod , zDateLoadingStart , 
pCountry , pSource , 'End_date');
CellPutS( NumberToString(nb_lign) , zCube_Process_PP , pChore , zProcess , pPeriod , zDateLoadingStart , 
pCountry , pSource , 'Nb_Input_records'); 
CellPutS( NumberToString(nb_load) , zCube_Process_PP , pChore , zProcess , pPeriod , zDateLoadingStart , 
pCountry , pSource , 'Nb_load_records');
CellPutS( 'OK' ,zCube_Process_PP, pChore , zProcess , pPeriod , zDateLoadingStart , pCountry , pSource , 'Status');


#################################################################################
#                                                                             DETAIL PROCESS SECTION
#################################################################################
zCube_Process = 'ZZ_PROCESS_DETAIL';

CellPutS(zDateTimeLoadingStart , zCube_Process , zProcess ,zDateLoadingStart , 'Start_date');
CellPutS(zDateTimeLoadingEnd , zCube_Process,  zProcess ,zDateLoadingStart  , 'End_date');
CellPutS(numbertostring(nb_lign) , zCube_Process , zProcess ,zDateLoadingStart  , 'Nb_Input_records');
CellPutS(numbertostring(nb_load) , zCube_Process , zProcess ,zDateLoadingStart , 'Nb_load_records');
CellPutS('OK' , zCube_Process , zProcess ,zDateLoadingStart , 'Status');

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
920,0
921,""
922,""
923,0
924,""
925,""
926,""
927,""
