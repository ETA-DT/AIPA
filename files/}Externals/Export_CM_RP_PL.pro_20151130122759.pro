601,100
562,"VIEW"
586,"RP_PL"
585,"RP_PL"
564,
565,"pNdc\Vo5]Y\a2w\caPMp4hTwrKMPpPtkRE`GDIr_9nyejE0olrX9EjPdNfX2mHRfiP]JENK_MX9>3pLi[GTpmJO<yBVCkMp6ispxWEr6<Oo>jxZREWA6VD^yoTT@?V:<utEAxvs7x3zGtej]u7M6Mu@sW=jp];Vmk[_70>vgdL\:N66w=9qGAxr:MXl2U@JjE]p4BlTA"
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
570,View1
571,
569,0
592,0
599,1000
560,0
561,0
590,0
637,0
577,13
Activity
Currency
Gaap
Integration_Rate
Legal_Organization
Management_Organization
Period
Phase
Indicator
Value
NVALUE
SVALUE
VALUE_IS_STRING
578,13
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
579,13
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
0
0
0
580,13
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
581,13
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
582,10
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
572,82
#########################################
# Project : Tango - Multi-instance
# Created by :NEK
# Created at : 24/10/2011
# Modified by :
# Modified at :
# Modify reason :
#########################################


#****Begin: Generated Statements***
#****End: Generated Statements****

DatasourceASCIIDelimiter =';';

zCube = 'RP_PL';
zProcess = 'Export_CM_RP_PL';

nb_lign = 0;
nb_load = 0;

zDateLoadingStart = TIMST(now,'\Y-\M-\D');
zDateTimeLoadingStart = TIMST(now,'\Y-\M-\D \h:\i:\s');

pCountry=CellGetS( 'z_Admin_Param' , 'COUNTRY' , 'STR_VAR1');
pPeriod=CellGetS( 'z_Admin_Param' , 'MONTH_ACTUAL' , 'STR_VAR1');

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
IF( SubsetExists( 'Period' , P_NAME_SOURCE ) = 1 );
    SubsetDeleteAllElements( 'Period' , P_NAME_SOURCE );
ELSE;
    SubsetCreate( 'Period' , P_NAME_SOURCE );
ENDIF;
SubsetElementInsert( 'Period' , P_NAME_SOURCE , pPeriod , 1 );
ViewSubsetAssign( zCube, P_NAME_SOURCE , 'Period' , P_NAME_SOURCE );

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
574,13

#****Begin: Generated Statements***
#****End: Generated Statements****




Nb_Lign = Nb_Lign + 1;

ASCIIOUTPUT( Export_File , Activity,Currency,Gaap,Integration_rate,Legal_Organization ,Management_Organization, Period , Phase , Indicator,Value );

Nb_Load = Nb_Load + 1;

575,43

#****Begin: Generated Statements***
#****End: Generated Statements****

#-- Suppress view
ViewDestroy( zCube , P_NAME_SOURCE );
SubsetDestroy( 'Legal_Organization' , P_NAME_SOURCE );
SubsetDestroy( 'Period' , P_NAME_SOURCE );
SubsetDestroy( 'Phase' , P_NAME_SOURCE );



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
