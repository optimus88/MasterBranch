#!  /bin/bash
# script for making TAR file

now=$(date +"%Y%m%d%H%M")
timestamp=$now
flag=0
crrVar=0
crrEnv=null
tableVar=IIMS_UWR.T_BUSINESS_CONTEXT_MAPPING,IIMS_CLM.T_BUSINESS_CONTEXT_MAPPING,IIMS_PTY.T_BUSINESS_CONTEXT_MAPPING
echo "Dump Export-Import initiated at ======>" $timestamp;
echo -e "\033[1;33m ****** Do You Want To Customize TimeStamp ?????\033[0m Y/N"
read ansTime
if [ $ansTime == Y -o $ansTime == y ]
then
echo "**** Please Provide Preferable Timestamp: e.g- 201504160000 :: yyyymmddhhss"
read ansTimeStamp
timestamp=$ansTimeStamp
echo Dump will be created as Timestamp $timestamp
fi

# -----------------------PRD Dump Export Script--------------------------------------
echo -e "\033[1;32m Select environment From Where You Want To Export PRD Dump: 
        #press 1 for STCM Export PRD Dump                             
        #press 2 for DEVCM Export PRD Dump                             
        #press 3 for COLLECTCM Export PRD Dump                                   
        #press 4 for INTCM Export PRD Dump                                        
        #press 5 for SKIP \033[0m"

read variable1
echo you selected $variable1
#-------------------------PRD Export Starts
if [ $variable1 -eq 1 ] 
then
echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Exporting PRD Dump File from STCM ..........................\033[0m"
expdp system/TCS123@STCM directory=DUMP_bkup dumpfile=IIMSPRD_$timestamp.dmp logfile=IIMSPRD_Export_$timestamp.log INCLUDE=SCHEMA_EXPORT/TABLE schemas=IIMS_PRD
crrVar=1
crrEnv=STCM
flag=1
chmod 777 IIMSPRD_$timestamp.dmp

elif [ $variable1 -eq 2 ] 
then
echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Exporting PRD Dump File from DEVCM ..........................\033[0m"
expdp system/IIMS@devcm directory=DUMP_bkup dumpfile=IIMSPRD_$timestamp.dmp logfile=IIMSPRD_Export_$timestamp.log INCLUDE=SCHEMA_EXPORT/TABLE schemas=IIMS_PRD
crrVar=2
crrEnv=devcm
flag=1
chmod 777 IIMSPRD_$timestamp.dmp

elif [ $variable1 -eq 3 ] 
then
echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Exporting PRD Dump File from COLLECTCM ..........................\033[0m"
expdp system/IIMS@collectcm directory=DUMP_bkup dumpfile=IIMSPRD_$timestamp.dmp logfile=IIMSPRD_Export_$timestamp.log INCLUDE=SCHEMA_EXPORT/TABLE schemas=IIMS_PRD
crrVar=3
crrEnv=collectcm
flag=1
chmod 777 IIMSPRD_$timestamp.dmp

elif [ $variable1 -eq 4 ] 
then
echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Exporting PRD Dump File from INTCM ..........................\033[0m"
expdp system/IIMSTCS@INTCM directory=DUMP_bkup dumpfile=IIMSPRD_$timestamp.dmp logfile=IIMSPRD_Export_$timestamp.log INCLUDE=SCHEMA_EXPORT/TABLE schemas=IIMS_PRD
crrVar=4
crrEnv=INTCM
flag=1
chmod 777 IIMSPRD_$timestamp.dmp

else
echo -e "\033[1;35m !!!!!!!PRD Dump Export Skipped !!!!!\033[0m"
crrVar=5
flag=3
fi
#-------------------------PRD Export ends

# -----------------------TABLE Dump Export Script--------------------------------------
echo -e "\033[1;32mSelect environment From Where You Want To Export Table Dump: 
		#press 0 for Continue with Same Evironment \033[0m
		
		\033[1;36mOtherwise change It by following Options =>
		#press 1 for STCM Export Table Dump
		#press 2 for DEVCM Export Table Dump
		#press 3 for PERF Export Table Dump
		#press 4 for COLLECTCM Export Table Dump
		#press 5 for INTCM Export Table Dump
		#press 6 for SKIP \033[0m"

read variable2
if [ $variable2 -eq 0 ]
then
variable2=$crrVar
fi
if [ $variable2 -eq 1 -o $variable2 -eq 2 -o $variable2 -eq 3 -o $variable2 -eq 4 ]
then
echo -e "\033[1;33m ****** Do You Want To Provide Table Names ?????\033[0m Y/N"
read ans
if [ $ans == Y -o $ans == y ]
then
echo "**** Please Provide Table names: e.g- table1,table2"
read tableVare
tableVar=$tableVare
echo you Provided $tableVar
fi
fi
echo you selected $variable2
#--------if starts
if [ $variable2 -eq 1 ] 
then
echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Exporting Table Dump File from STCM ..........................\033[0m"
expdp system/TCS123@STCM directory=DUMP_bkup dumpfile=Table_$timestamp.dmp logfile=Table_Export_$timestamp.log TABLES=$tableVar
flag=$((flag+1))
chmod 777 Table_$timestamp.dmp

elif [ $variable2 -eq 2 ] 
then
echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Exporting Table Dump File from devcm ..........................\033[0m"
expdp system/IIMS@devcm directory=DUMP_bkup dumpfile=Table_$timestamp.dmp logfile=Table_Export_$timestamp.log TABLES=$tableVar
flag=$((flag+1))
chmod 777 Table_$timestamp.dmp

elif [ $variable2 -eq 3 ] 
then
echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Exporting Table Dump File from collectcm..........................\033[0m"
expdp system/IIMS@PERFDBENV directory=DUMP_bkup dumpfile=Table_$timestamp.dmp logfile=Table_Export_$timestamp.log TABLES=$tableVar
flag=$((flag+1))
chmod 777 Table_$timestamp.dmp

elif [ $variable2 -eq 4 ] 
then
echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Exporting Table Dump File from collectcm..........................\033[0m"
expdp system/IIMS@collectcm directory=DUMP_bkup dumpfile=Table_$timestamp.dmp logfile=Table_Export_$timestamp.log TABLES=$tableVar
flag=$((flag+1))
chmod 777 Table_$timestamp.dmp

elif [ $variable2 -eq 5 ] 
then
echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Exporting Table Dump File from INTCM..........................\033[0m"
expdp system/IIMSTCS@INTCM directory=DUMP_bkup dumpfile=Table_$timestamp.dmp logfile=Table_Export_$timestamp.log TABLES=$tableVar
flag=$((flag+1))
chmod 777 Table_$timestamp.dmp

else 
echo -e "\033[1;35m !!!!!!!Table Dump Export Skipped !!!!!\033[0m"

fi
#------if ends

# ----------------------- TAR Generating Script--------------------------------------
echo -e "\033[1;32mChoose Action You Want To Perform: 
		#press 0 for Generating TAR \033[0m
		
		\033[1;36mOtherwise Select Environment to Import =>
		#press 1 for Import in STCM
		#press 2 for Import in DEVCM
		#press 3 for Import in PERFDBENV
		#press 4 for Import in COLLECTCM
		#press 5 for Import in INTCM
		#press 6 for SKIP \033[0m"
read variable3
#--------if starts
if [ $variable3 -eq 0 ]
then
	echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Generating TAR ...........................\033[0m"
	cd /home0/oracle11/DB_bkup
	if [ $flag -eq 1 ] 
	then
	tar cvzf TAR_BALL_PRD_BIZ_$crrEnv.tar.gz IIMSPRD_$timestamp.dmp

	echo -e "\033[1;34m >>>>>>>>>>>>> Creating import.txt .......................\033[0m"

	echo "impdp system@"$crrEnv" directory=DUMP_BKUP schemas=IIMS_PRD TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=IIMSPRD_"$timestamp".dmp LOGFILE=IIMSPRD_"$timestamp".log" > import.txt

	echo "<<<<<<<<<<<<<< TAR generated in /home0/oracle11/DB_bkup as TAR_BALL_PRD_BIZ_"$crrEnv".tar.gz of =======> IIMSPRD_"$timestamp".dmp"
	
	elif [ $flag -eq 2 ] 
	then
	tar cvzf TAR_BALL_PRD_BIZ_$crrEnv.tar.gz IIMSPRD_$timestamp.dmp Table_$timestamp.dmp

	echo -e "\033[1;34m >>>>>>>>>>>>> Creating import.txt .......................\033[0m"

	echo "impdp system@"$crrEnv" directory=DUMP_BKUP schemas=IIMS_PRD TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=IIMSPRD_"$timestamp".dmp LOGFILE=IIMSPRD_"$timestamp".log" > import.txt
	echo "" >> import.txt
	echo "impdp system@"$crrEnv" directory=DUMP_BKUP TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=Table_"$timestamp".dmp LOGFILE=Table_"$timestamp".log TABLES="$tableVar >> import.txt

	echo "<<<<<<<<<<<<<< TAR generated in /home0/oracle11/DB_bkup as TAR_BALL_PRD_BIZ_"$crrEnv".tar.gz of =======> IIMSPRD_"$timestamp."dmp and Table_"$timestamp."dmp"

	elif [ $flag -eq 4 ] 
	then
	tar cvzf TAR_BALL_PRD_BIZ_$crrEnv.tar.gz Table_$timestamp.dmp

	echo -e "\033[1;34m >>>>>>>>>>>>> Creating import.txt .......................\033[0m"

	echo "impdp system@"$crrEnv" directory=DUMP_BKUP TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=Table_"$timestamp".dmp LOGFILE=Table_"$timestamp".log TABLES="$tableVar >> import.txt

	echo "<<<<<<<<<<<<<< TAR generated in /home0/oracle11/DB_bkup as TAR_BALL_PRD_BIZ_"$crrEnv".tar.gz of =======> Table_"$timestamp".dmp"

	else 
	echo -e "\033[1;35m !!!!!!!There is NO Dump to make TAR!!!!!\033[0m"
	fi
	
elif [ $variable3 -eq 1 ]
then
	echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Import Dump in STCM Started...........................\033[0m"
	if [ $flag -eq 1 -o $flag -eq 2 ] 
	then
expdp system@STCM directory=DUMP_bkup dumpfile=IIMSPRD_Bck_ST_$timestamp.dmp logfile=IIMSPRD_Bck_Export_$timestamp.log INCLUDE=SCHEMA_EXPORT/TABLE schemas=IIMS_PRD
echo "PRD Backup of STCM has been taken as IIMSPRD_Bck_ST_"$timestamp".dmp"
impdp system@STCM directory=DUMP_BKUP schemas=IIMS_PRD TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=IIMSPRD_$timestamp.dmp LOGFILE=IIMSPRD_Import_$timestamp.log
	fi
	if [ $flag -eq 2 -o $flag -eq 4 ] 
	then
expdp system@STCM directory=DUMP_bkup dumpfile=Table_Bck_ST_$timestamp.dmp logfile=Table_Export_$timestamp.log TABLES=$tableVar
echo "Table Backup of STCM has been taken as Table_Bck_ST_"$timestamp".dmp"
impdp system@STCM directory=DUMP_BKUP TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=Table_$timestamp.dmp LOGFILE=Table_Import_$timestamp.log TABLES=$tableVar
		if [ $? -eq 0 ] 
		then
			echo "Import of the DUMP was successfull. Proceeding with the deletion of the Backup Created."
			rm Table_Bck_ST_$timestamp.dmp Table_Export_$timestamp.log
		else
			echo "The Import was not successful. Please proceed manually.!!!"
			exit 1;
		fi
	fi
elif [ $variable3 -eq 2 ]
then
	echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Import Dump in DEVCM Started..........................\033[0m"
	if [ $flag -eq 1 -o $flag -eq 2 ] 
	then
		expdp system@devcm directory=DUMP_bkup dumpfile=Table_Bck_devcm_$timestamp.dmp logfile=Table_Export_devcm_$timestamp.log TABLES=$tableVar
		echo "Table Backup of DEVCM has been taken as Table_Bck_devcm_"$timestamp".dmp"
		impdp system@devcm directory=DUMP_BKUP TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=Table_$timestamp.dmp LOGFILE=Table_Import_$timestamp.log TABLES=$tableVar
		if [ $? -eq 0 ] 
		then
			echo "Import of the DUMP was successfull. Proceeding with the deletion of the Backup Created."
			rm Table_Bck_devcm_$timestamp.dmp Table_Export_devcm_$timestamp.log
		else
			echo "The Import was not successful. Please proceed manually.!!! The Process will exit now."
			exit 1;
		fi		
		# impdp system@devcm directory=DUMP_BKUP schemas=IIMS_PRD TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=IIMSPRD_$timestamp.dmp LOGFILE=IIMSPRD_Import_$timestamp.log
	fi
	if [ $flag -eq 2 -o $flag -eq 4 ] 
	then
impdp system@devcm directory=DUMP_BKUP TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=Table_$timestamp.dmp LOGFILE=Table_Import_$timestamp.log TABLES=$tableVar
	fi
elif [ $variable3 -eq 3 ]
then
	echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Import Dump in COLLECTCM Started..........................\033[0m"
	if [ $flag -eq 1 -o $flag -eq 2 ] 
	then
impdp system@collectcm directory=DUMP_BKUP schemas=IIMS_PRD TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=IIMSPRD_$timestamp.dmp LOGFILE=IIMSPRD_Import_$timestamp.log
	fi
	if [ $flag -eq 2 -o $flag -eq 4 ] 
	then
impdp system@collectcm directory=DUMP_BKUP TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=Table_$timestamp.dmp LOGFILE=Table_Import_$timestamp.log TABLES=$tableVar
	fi
elif [ $variable3 -eq 4 ]
then
	echo -e "\033[1;34m>>>>>>>>>>>>>>>>> Import Dump in INTCM Started..........................\033[0m"
	if [ $flag -eq 1 -o $flag -eq 2 ] 
	then
impdp system@INTCM directory=DUMP_BKUP schemas=IIMS_PRD TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=IIMSPRD_$timestamp.dmp LOGFILE=IIMSPRD_Import_$timestamp.log
	fi
	if [ $flag -eq 2 -o $flag -eq 4 ] 
	then
impdp system@INTCM directory=DUMP_BKUP TABLE_EXISTS_ACTION=REPLACE EXCLUDE=STATISTICS dumpfile=Table_$timestamp.dmp LOGFILE=Table_Import_$timestamp.log TABLES=$tableVar
	fi
else
	echo -e "\033[1;35m !!!!!!!### You Skipped this Operation ### !!!!!\033[0m"

fi
#-----if ends
exit;