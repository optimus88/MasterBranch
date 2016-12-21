# #IIMS_SEC
# expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=IIMS_SF_ST.dmp LOGFILE=IIMS_SF_ST.log schemas=IIMS_SF
#  "Export done"
# impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=IIMS_SF TABLE_EXISTS_ACTION=REPLACE dumpfile=IIMS_SF_ST.dmp LOGFILE=import_IIMS_SF_ST.log
# #echo "Import Done"
# rm IIMS_SF_ST.dmp
# echo "Dump file IIMS_SF_ST.dmp deleted"

#Q00TAXI01
expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=Q00TAXI01_ST.dmp LOGFILE=IIMS_SF_ST.log schemas=Q00TAXI01
echo "Export done"
impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=Q00TAXI01 TABLE_EXISTS_ACTION=REPLACE dumpfile=Q00TAXI01_ST.dmp LOGFILE=import_Q00TAXI01_ST.log
echo "Import Done"
rm Q00TAXI01_ST.dmp
echo "Dump file Q00TAXI01_ST.dmp deleted"

#WORKFLOW
expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=WORKFLOW_ST.dmp LOGFILE=WORKFLOW_ST.log schemas=WORKFLOW
echo "Export done"
impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=WORKFLOW TABLE_EXISTS_ACTION=REPLACE dumpfile=WORKFLOW_ST.dmp LOGFILE=import_WORKFLOW_ST.log
echo "Import Done"
rm WORKFLOW_ST.dmp
echo "Dump file WORKFLOW_ST.dmp deleted"

#IIMS_BATCH_USER
expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=BATCH_USER_ST.dmp LOGFILE=BATCH_USER.log schemas=BATCH_USER
echo "Export done"
impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=BATCH_USER TABLE_EXISTS_ACTION=REPLACE dumpfile=BATCH_USER_ST.dmp LOGFILE=import_BATCH_USER_ST.log
echo "Import Done"
rm BATCH_USER_ST.dmp
echo "Dump file BATCH_USER_ST.dmp deleted"

#IIMS_IIMS_PTY
expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=IIMS_PTY_ST.dmp LOGFILE=IIMS_PTY_ST.log schemas=IIMS_PTY
echo "Export done"
impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=IIMS_PTY TABLE_EXISTS_ACTION=REPLACE dumpfile=IIMS_PTY_ST.dmp LOGFILE=import_IIMS_PTY_ST.log
echo "Import Done"
rm IIMS_PTY_ST.dmp
echo "Dump file IIMS_PTY_ST.dmp deleted"

#IIMS_REP
expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=IIMS_REP_ST.dmp LOGFILE=IIMS_SEC_ST.log schemas=IIMS_REP
echo "Export done"
impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=IIMS_REP TABLE_EXISTS_ACTION=REPLACE dumpfile=IIMS_REP_ST.dmp LOGFILE=import_IIMS_REP_ST.log
echo "Import Done"
rm IIMS_REP_ST.dmp
echo "Dump file IIMS_REP_ST.dmp deleted"

#IIMS_CLM
expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=IIMS_CLM_ST.dmp LOGFILE=IIMS_CLM_ST.log schemas=IIMS_CLM
echo "Export done"
impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=IIMS_CLM TABLE_EXISTS_ACTION=REPLACE dumpfile=IIMS_CLM_ST.dmp LOGFILE=import_IIMS_CLM_ST.log
echo "Import Done"
rm IIMS_CLM_ST.dmp
echo "IIMS_CLM_ST.dmp deleted"

#IIMS_INTERFACE
expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=IIMS_INTERFACE_ST.dmp LOGFILE=IIMS_INTERFACE_ST.log schemas=IIMS_INTERFACE
echo "Export done"
impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=IIMS_INTERFACE TABLE_EXISTS_ACTION=REPLACE dumpfile=IIMS_INTERFACE_ST.dmp LOGFILE=import_IIMS_INTERFACE.log
echo "Import Done"
rm IIMS_INTERFACE_ST.dmp
echo "deleted IIMS_INTERFACE.dmp file"

#IIMS_ACC
expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=IIMS_ACC_ST.dmp LOGFILE=IIMS_SEC_ST.log schemas=IIMS_ACC
echo "Export done"
impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=IIMS_ACC TABLE_EXISTS_ACTION=REPLACE dumpfile=IIMS_ACC_ST.dmp LOGFILE=import_IIMS_ACC_ST.log
echo "Import Done"
rm IIMS_ACC_ST.dmp
echo "deleted IIMS_ACC_ST.dmp file"

#ENT_MGR
expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=ENT_MGR_ST.dmp LOGFILE=IIMS_SEC_ST.log schemas=ENT_MGR
echo "Export done"
impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=ENT_MGR TABLE_EXISTS_ACTION=REPLACE dumpfile=ENT_MGR_ST.dmp LOGFILE=import_ENT_MGR_ST.log
echo "Import Done"
rm ENT_MGR_ST.dmp
echo "deleted ENT_MGR_ST.dmp file"

#IIMS_DM
expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=IIMS_DM_ST.dmp LOGFILE=IIMS_SEC_ST.log schemas=IIMS_DM
echo "Export done"
impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=IIMS_DM TABLE_EXISTS_ACTION=REPLACE dumpfile=IIMS_DM_ST.dmp LOGFILE=import_IIMS_DM_ST.log
echo "Import Done"
rm IIMS_DM_ST.dmp
echo "Deleted IIMS_DM_ST.dmp"

#IIMS_UWR
expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=IIMS_UWR_ST.dmp LOGFILE=IIMS_SEC_ST.log schemas=IIMS_UWR
echo "Export done"
impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=IIMS_UWR TABLE_EXISTS_ACTION=REPLACE dumpfile=IIMS_UWR_ST.dmp LOGFILE=import_IIMS_UWR_ST.log
echo "Import Done"
rm IIMS_UWR_ST.dmp
echo "deleted IIMS_UWR_ST.dmp file"

#COMMON
expdp system/TCS123@STCM directory=DUMP_BKUP dumpfile=COMMON_ST.dmp LOGFILE=IIMS_SEC_ST.log schemas=COMMON
echo "Export done"
impdp system/IIMS@PERFDBENV directory=DUMP_BKUP schemas=COMMON TABLE_EXISTS_ACTION=REPLACE dumpfile=COMMON_ST.dmp LOGFILE=import_COMMON_ST.log
echo "Import Done"
rm COMMON_ST.dmp
echo "COMMON_ST.dmp deleted"