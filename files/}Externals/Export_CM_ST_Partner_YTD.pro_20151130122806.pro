601,100
562,"VIEW"
586,"ST_Partner_YTD"
585,"ST_Partner_YTD"
564,
565,"xv_=USDyP2MuGB@UqA6Pn5lRa?0jh11XPPJAua\NXQj5QQPB_fCYNX3W6<wh85s8ZjR]Rl0D4=N0_=6?S`JTD5<kh9OyfZ4;QbKG?8q>jr6CU0qIOU]=Ye`m@8@M\j\a2y;;lAnh7R^WT;uGMZrwE5\w4arlAe[an`La?z?>4PL^q0ityaxaT^HkbFO53^P0GWF7CwOg"
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
577,14
Integration_Rate
Activity
Currency
Gaap
Legal_Organization
Management_Organization
Partner
Period_YTD
Phase
Indicator
Value
NVALUE
SVALUE
VALUE_IS_STRING
578,14
2
2
2
2
2
2
2
2
2
2
2
1
2
1
579,14
1
2
3
4
5
6
7
8
9
10
11
0
0
0
580,14
0
0
0
0
0
0
0
0
0
0
0
0
0
0
581,14
0
0
0
0
0
0
0
0
0
0
0
0
0
0
582,11
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
572,83
#########################################
# Project : Tango - Multi-instance
# Created by :NEK
# Created at : 24/10/2011
# Modified by :MBO
# Modified at :14\11\2011
# Modify reason :
#########################################


#****Begin: Generated Statements***
#****End: Generated Statements****

DatasourceASCIIDelimiter =';';

zCube = 'ST_Partner_YTD';
zProcess = 'Export_CM_ST_Partner_YTD';

nb_lign = 0;
nb_load = 0;

zDateLoadingStart = TIMST(now,'\Y-\M-\D');
zDateTimeLoadingStart = TIMST(now,'\Y-\M-\D \h:\i:\s');

pCountry=CellGetS( 'z_Admin_Param' , 'COUNTRY' , 'STR_VAR1');
pPeriod=CellGetS( 'z_Admin_Param' , 'MONTH_ACTUAL' , 'STR_VAR1')  | '_YTD';

Export_File = '\\'| CellGetS( 'z_Admin_Param_Instance' , 'SERVER_NAME' , 'CM','STR_VAR1') | CellGetS( 'z_Admin_Param_Instance' , 'REP_CO_DATA_EXPORT' 
, 'CM','STR_VAR1') | pCountry | '_Data_' | zCube | '.csv';

######
#Call process DB_zz_Date_Time_loading in order to add the new day in the dimension zz_Date_Time_loading
ExecuteProcess('DB_zz_Date_Time_loading');
######

#################################################################################
#                                                               Source CUBE 
#################################################################################

P_NAME_SOURCE = zCube | '_Vue';
ViewDestroy( zCube , P_NAME_SOURCE );
ViewCreate( zCube , P_NAME_SOURCE );

#-- Create subset in Legal_Organization
SubsetDestroy( 'Legal_Organization' , P_NAME_SOURCE );
SubsetCreate( 'Legal_Organization' , P_NAME_SOURCE );
i=1;
WHILE( i < DIMSIZ ( 'Legal_Organization' )+1 );
   ElemE = DIMNM( 'Legal_Organization' , i );
      IF ( ATTRS ( 'Legal_Organization' , ElemE,'Country_entity' ) @= pCountry ) ;
           SubsetElementInsert( 'Legal_Organization' , P_NAME_SOURCE , ElemE , 1 );
      ENDIF;
    i=i+1;
END;
ViewSubsetAssign( zCube , P_NAME_SOURCE , 'Legal_Organization' , P_NAME_SOURCE );

#-- Create subset in Period
IF( SubsetExists( 'Period_YTD' , P_NAME_SOURCE ) = 1 );
    SubsetDeleteAllElements( 'Period_YTD' , P_NAME_SOURCE );
ELSE;
    SubsetCreate( 'Period_YTD' , P_NAME_SOURCE );
ENDIF;
SubsetElementInsert( 'Period_YTD' , P_NAME_SOURCE , pPeriod , 1 );
ViewSubsetAssign( zCube, P_NAME_SOURCE , 'Period_YTD' , P_NAME_SOURCE );

#-- Create subset in Phase
IF( SubsetExists( 'Phase' , P_NAME_SOURCE ) =1 );
    SubsetDeleteAllElements( 'Phase' , P_NAME_SOURCE );
ELSE;
    SubsetCreate( 'Phase' , P_NAME_SOURCE );
ENDIF;
SubsetElementInsert( 'Phase' , P_NAME_SOURCE , 'ACT' , 1 );
SubsetElementInsert( 'Phase' , P_NAME_SOURCE , 'MAN_AJUST' , 1 );
ViewSubsetAssign( zCube , P_NAME_SOURCE , 'Phase' , P_NAME_SOURCE );

#-- Update subset
ViewExtractSkipZeroesSet ( zCube , P_NAME_SOURCE , 1 );
ViewExtractSkipRuleValuesSet ( zCube , P_NAME_SOURCE , 1 );
ViewExtractSkipCalcsSet ( zCube , P_NAME_SOURCE , 1 );


DatasourceNameForServer = zCube ;
DatasourceCubeview = P_NAME_SOURCE ;
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,16

#****Begin: Generated Statements***
#****End: Generated Statements****


nb_lign=nb_lign+1;




ASCIIOUTPUT( Export_File , Integration_rate,Activity,Currency,Gaap,Legal_Organization ,Management_Organization, Partner,Period_YTD,Phase , Indicator,V
alue );



nb_load=nb_load+1;
575,44

#****Begin: Generated Statements***
#****End: Generated Statements****





ViewDestroy( zCube , P_NAME_SOURCE );
SubsetDestroy( 'Legal_Organization' , P_NAME_SOURCE );
SubsetDestroy( 'Phase' , P_NAME_SOURCE );
SubsetDestroy( 'Period_YTD' , P_NAME_SOURCE );


zDateTimeLoadingEnd = TIMST(now,'\Y-\M-\D \h:\i:\s');
#################################################################################
#                                                                             PROCESS with PERIOD and INSTANCE
#################################################################################
zCube_Process_PP = 'ZZ_PROCESS_Detail_Instance';

pChore='Task4_CO_Import_Vector_Parameter_Export_CM_Data_' | pCountry;
pSource=pCountry;

CellPutS(zDateTimeLoadingStart , zCube_Process_PP, pChore, zProcess ,pPeriod,zDateLoadingStart, pCountry , psource, 'Start_date');
CellPutS(zDateTimeLoadingEnd , zCube_Process_PP, pChore, zProcess ,pPeriod,zDateLoadingStart, pCountry ,psource, 'End_date');
CellPutS(numbertostring(nb_lign) , zCube_Process_PP, pChore, zProcess ,pPeriod,zDateLoadingStart, pCountry ,psource, 'Nb_Input_records');
CellPutS(numbertostring(nb_load) ,  zCube_Process_PP, pChore, zProcess ,pPeriod,zDateLoadingStart, pCountry ,psource, 'Nb_load_records');
CellPutS('OK' ,zCube_Process_PP, pChore, zProcess ,pPeriod,zDateLoadingStart, pCountry , psource,  'Status');


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
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
