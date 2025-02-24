601,100
562,"CHARACTERDELIMITED"
586,"Defined to prolog"
585,"\\TFR-AP019292\tm1data\FR\Input\Data_Country\FR_Data_ST_Entity_Rates.csv"
564,
565,"b^a=VZ=]0wq7IKVCT17Fhg@u`wLMA?VJ@vec5EoLuxz77ica6eG`:_buyEq?:\Am2utweBPQ5y[rCEb7A[\6@`k`BQ^sWKMN86[Ak3_H6x0Crunr?XH7re>6Sqh[KPJ3hE05Ya;@sxH?J5U>YxanIDC`dFNSW72rHA_3f^;a6Q^@vZUBBoP2\;2k`UX[_j0MqgJkPHM^"
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
577,5
vector_entity
vPeriod
vPhase
z_Str_Var
value
578,5
2
2
2
2
2
579,5
1
2
3
4
5
580,5
0
0
0
0
0
581,5
0
0
0
0
0
582,6
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
IgnoredInputVarName=V6VarType=33ColType=1165
603,0
572,142
#########################################
# Project : Tango - Multi-instance
# Created by : MBO
# Created at : 14/11/2011
# Modified by :
# Modified at :
# Modify reason :
#########################################


#****Begin: Generated Statements***
#****End: Generated Statements****


zCube = 'ST_Entity_Rates';
zCube_Reject = 'ZZ_PROCESS_REJECT_INSTANCE';


Nb_Lign = 0;
Nb_Reject = 0;
Nb_Load = 0;

zProcess = 'Import_ST_Entity_Rates';

zDateLoadingStart = TIMST(now,'\Y-\M-\D');
zDateTimeLoadingStart = TIMST(now,'\Y-\M-\D \h:\i:\s');

pPeriod = CellGetS( 'z_Admin_Param' , 'MONTH_ACTUAL' , 'STR_VAR1');
pCountry = CellGetS( 'z_Admin_Param' , 'COUNTRY' , 'STR_VAR1');

Source_File = '\\'| CellGetS( 'z_Admin_Param_Instance' , 'SERVER_NAME' , pCountry , 'STR_VAR1' ) 
| CellGetS( 'z_Admin_Param_instance' , 'REP_CM_DATA_EXPORT' , pcountry,'STR_VAR1') | pCountry | CellGetS( 'z_Admin_Param_instance' , 'REP_
DATA_EXPORT' ,pcountry, 'STR_VAR1') 
| '\' |  pCountry | '_Data_' | zCube | '.csv';

vDim2='Legal_Organization';

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

#-- Create subset in Period
IF( SubsetExists( 'Period' , P_NAME_RAZ ) = 1 );
    SubsetDeleteAllElements( 'Period' , P_NAME_RAZ);
ELSE;
    SubsetCreate( 'Period' , P_NAME_RAZ );
ENDIF;
SubsetElementInsert( 'Period' , P_NAME_RAZ , pPeriod , 1 );
ViewSubsetAssign( zCube , P_NAME_RAZ , 'Period' , P_NAME_RAZ );

#-- Create subset in Phase
IF( SubsetExists( 'Phase' , P_NAME_RAZ ) =1 );
    SubsetDeleteAllElements( 'Phase' , P_NAME_RAZ  );
ELSE;
    SubsetCreate( 'Phase' , P_NAME_RAZ  );
ENDIF;
SubsetElementInsert( 'Phase' , P_NAME_RAZ  , 'ACT' , 1 );
SubsetElementInsert( 'Phase' , P_NAME_RAZ  , 'MAN_AJUST' , 1 );
ViewSubsetAssign( zCube , P_NAME_RAZ  , 'Phase' , P_NAME_RAZ  );

#-- Clear cube
ViewZeroOut( zCube , P_NAME_RAZ );

#-- Update subset
ViewExtractSkipZeroesSet ( zCube , P_NAME_RAZ , 1 );
ViewExtractSkipRuleValuesSet ( zCube , P_NAME_RAZ , 1 );
ViewExtractSkipCalcsSet ( zCube , P_NAME_RAZ , 1 );

#-- Delete subset
ViewDestroy( zCube , P_NAME_RAZ );
SubsetDestroy( 'Period' , P_NAME_RAZ );
SubsetDestroy( vDim2, P_NAME_RAZ );
SubsetDestroy( 'Phase' , P_NAME_RAZ );








573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,51

#****Begin: Generated Statements***
#****End: Generated Statements****



pSource ='CORE_MODEL';

#zRecord = vector_entity | ';' | vPeriod | ';' | vPhase | ';' | z_Str_Var | ';' | NumberToString( Value ) ;
zRecord = vector_entity | ';' | vPeriod | ';' | vPhase | ';' | z_Str_Var | ';' |  Value ;

#################################################################################
#                                                                             REJECT SECTION
#################################################################################
Nb_lign = Nb_lign + 1;

#-- If the period is different of the period in the file this record is reject
IF( vPeriod @<> pPeriod );
   Nb_Reject = Nb_Reject + 1;
   zError_Message = 'Rejected Data : The period in parameter is different of the period in the file at line ' | NumberToString( Nb_Lign ) ;
      CellPutS( zRecord , zCube_Reject , zProcess , zDateLoadingStart , 'l' | NumberToString(Nb_Reject) ,pSource, 'Record' );
      CellPutS( zError_Message , zCube_Reject , zProcess , zDateLoadingStart , 'l' | NumberToString(Nb_Reject) ,pSource ,'Error_Message' );
   ItemSkip;
ENDIF;

#-- if the Entity is not exists in legal_organization dimension, this record is reject
IF(Dimix('Legal_Organization', vector_Entity) = 0 );
   zerror_message='The entity ' | vector_Entity | ' does not exist in dimension Legal_Organization at line ' |  numbertostring(nb_lign) ;
   nb_reject=nb_reject+1;
      CellPutS( zRecord , zCube_Reject , zProcess , zDateLoadingStart , 'l' | NumberToString(Nb_Reject) ,pSource, 'Record' );
      CellPutS( zError_Message , zCube_Reject , zProcess , zDateLoadingStart , 'l' | NumberToString(Nb_Reject) ,pSource ,'Error_Message' );
   ItemSkip;
ENDIF;

################################################################################
#                                                               INPUT SECTION : Cube => ST_Entity_Rates
################################################################################

#-- => ST_Entity_Rates

IF (Subst(z_Str_Var, 1, 3) @='NUM');
CellPutN( StringToNumber(Value) , zCube , vector_entity, vPeriod, vPhase , z_Str_Var );
ELSE;
CellPutS( Value , zCube , vector_entity, vPeriod, vPhase , z_Str_Var );
ENDIF;

Nb_Load = Nb_Load + 1;




575,65

#****Begin: Generated Statements***
#****End: Generated Statements****



#-- Copy the file data in historical directory
ExecuteProcess( 'z_Tools_Data_Transfert' , 
'zFile' , pCountry | '_Data_' | zCube , 'zAnnee' , SUBST( pPeriod , 1 , 4 ) , 'zMois' , SUBST( pPeriod , 6 , 2 )  );


zDateTimeLoadingEnd = TIMST(now,'\Y-\M-\D \h:\i:\s');
#################################################################################
#                                                                             PROCESS with PERIOD and INSTANCE
#################################################################################
zCube_Process_PP = 'ZZ_PROCESS_Detail_Instance';

pChore='Task4_CO_Import_Vector_Parameter_Export_CM_Data_' | pCountry;

pInstance=CellGetS( 'z_Admin_Param' , 'COUNTRY' , 'STR_VAR1');
pSource ='CORE_MODEL';

pPeriod=CellGetS( 'z_Admin_Param' , 'MONTH_ACTUAL' , 'STR_VAR1');

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
