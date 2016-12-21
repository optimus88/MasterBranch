# Deployment script for placing files on server and restarting at the end of the deployment
#!/bin/bash
# Name: DeploymentScript for automation
# Module: deploy files
# Author: Keshav & Paul
# Version 1.0
# Description: deploy files in respective dir options updated.
#==============================================================================================================
mkdir tmp deploymentTemp
export AppDEVCM="UATRel_domain"
export AppST_CM="ST_CM"
export AppPERF="perfenv"
export DevCmDomain=""
export STDomain="BaNCS_ST_Build"
export PerfDomain="Perfenv_Build"

weblogicPath=""
#javaPath=/apps/cpq/java/64bit/jdk1.6.0_31/bin/jar
export initialPath=/home0/u234695/CM_DEPLOYMENT/
export tempDest=/home0/u234695/CM_DEPLOYMENT/TempDest/
export fromCopyPath=/home0/u234695/CM_DEPLOYMENT/DeskTemp/
export backupPath=/home0/u234695/CM_DEPLOYMENT/BackUp_Files/
export logFile=/home0/u234695/CM_DEPLOYMENT/logs/DeploymentOutput.log
export processedPDN=/home0/u234695/CM_DEPLOYMENT/ProcessedPDN
export defaultPath="/home0/u234695/.jenkins/jobs/"
export workspacePath="/workspace/Base Source Code/ECLIPSEWORKSPACE/"
dateVar=`date +%d%b%Y"_"%H%M%S`
#-------------- Env and Domain selection -----------------------------
#--------------------- Function Declaration --------------------------
checkUserInput ()
{
        regularExpression='^[0-9]+$'
        if ! [[ $1 =~ $regularExpression ]]
        then
                varNum1=1
        else
                varNum1=0
        fi
        if [ $varNum1 -eq 0 ]
        then
                return 0
        else
                return 1
        fi
}

backUpFileDetails ()
{
var_arg1=$1		#-----path of the deployment
var_arg2=$2		#-----name of the file considered in this loop
#------ Deployment Proof and details --------
cd "$var_arg1"
echo "Path :" `pwd` >>$logFile
echo "File Name :" $var_arg2 >>$logFile
echo "Deployment Timestamp :" `ls -lrt $var_arg2` >>$logFile
echo "=====================================================================" >>$logFile
echo "" >>$logFile
#------ Deployment Proof and details --------
}

deploymentFiles ()
{
pwd
export nsOfFiles=`ls | grep -v "Backup"  |wc -l`
echo "no of Files $nsOfFiles"
count="$(($nsOfFiles+1))"
filesDeployed=0
utilFileName=0
for i in `seq 1 $nsOfFiles`
	do
		while [ $count -gt 1 ]
		do
			fileNameCurrent=`ls -l | grep -v "Backup" | head -$count |tail -1|awk '{print $9;}'`
			extsn=$(echo $fileNameCurrent|awk -F . '{print $NF}')
			echo "Extension of the file == "$extsn
			echo ""
			if [ "$extsn" == "jsp" ] || [ "$extsn" == "java" ] || [ "$extsn" == "xml" ]
			then
				if [ "$extsn" == "java" ] && [ "$fileNameCurrent" == "Utility.java" ] || [ "$fileNameCurrent" == "ExpenseDetailBean.java" ]
				then
					#============= SELECTING the module start ===========================
					utilFileName="$(($utilFileName+1))"
					echo " Please select the module for the Java File to deploy...! " 
					echo -e "\033[1;32m Please select the Module where to deploy the "$fileNameCurrent" file :
					#press 1 for IIMSClaim
					#press 2 for IIMSCore
					#press 3 for IIMSWeb
					#press 4 for IIMSUtil 
					#press 0 for SKIP	\033[0m"
					read moduleName
					checkUserInput $moduleName
					userInputCheck=$?
					if [ $userInputCheck -eq 1 ]
					then
						echo "Invalid Input.... The Script will exit...!! "
						exit 1
						elif [ $moduleName -eq 1 ]
						then
							moduleNameSelected="IIMSClaim"
						elif [ $moduleName -eq 2 ]
						then
							moduleNameSelected="IIMSCore"
						elif [ $moduleName -eq 3 ]
						then
							moduleNameSelected="IIMSWeb"
						elif [ $moduleName -eq 4 ]
						then
							moduleNameSelected="IIMSUtil"
						elif [ $moduleName -eq 0 ]
						then
							exit 0
					fi
						#============= SELECTING the module over ===========================
							currentFileNamePath=`find "$defaultPath$PerfDomain$workspacePath" -name "$fileNameCurrent" | grep $moduleNameSelected`
							echo "$currentFileNamePath"
							cp "$currentFileNamePath" Backup
							currentFileNamePath=`echo $currentFileNamePath | awk -F $fileNameCurrent '{print $1}'`
							echo $currentFileNamePath
							#export filesDeployed="$(($filesDeployed+1))"
						#------ Deployment Proof and details --------
						backUpFileDetails $currentFileNamePath $fileNameCurrent
						#------ Deployment Proof and details --------
						cd -
				else
					currentFileNamePath=`find "$defaultPath$PerfDomain$workspacePath" -name $fileNameCurrent`		
					cp "$currentFileNamePath" Backup
					currentFileNamePath=`echo $currentFileNamePath | awk -F $fileNameCurrent '{print $1}'`
					#cp $fileNameCurrent "$currentFileNamePath"
					export filesDeployed="$(($filesDeployed+1))"
					#------ Deployment Proof and details --------
					backUpFileDetails $currentFileNamePath $fileNameCurrent
					cd -
				fi
			fi
			#------ Deployment Proof and details --------
			count="$(($count-1))"
		done
	if [ "$utilFileName" -ge 0 ]
	then
		filesDeployed="$(($filesDeployed+$utilFileName))" 		#deployment count for the file Utility.java file present in the PDN folder
	fi
done
}


multipleFileReplace()
{
varFunctionFilename=$1
echo $varFunctionFilename
echo "In the multiple deployment loop fun"
cd $path
echo ""
varPathResult=`find . -name $varFunctionFilename`
echo $varPathResult
echo ""
varDepPathName=`echo $varPathResult | sed 's/^..//'` 
#echo $varDepPathName
#echo ""
varDepPath=`echo $varDepPathName | awk -F $varFunctionFilename '{print $1}'`
echo $varDepPath
echo ""
if [ -n "$varDepPath" ]
    then
        cd $varDepPath
        if [ -f "$varFunctionFilename" ]
            then
                rm $varFunctionFilename 	#//move the file as a backup to a backup directory.
                cp $fromCopyPath$varFunctionFilename .
                    else
                        echo "File not present in the extracted Jar..."
                        echo ""
                        sleep 1
                        exit 1
        fi
			else
				echo "Path not found for the user file to be deployed inside the Jar file.."
				echo ""
				exit 1
fi
}
pdnWiseDeloymentProcess ()
{
	cd $fromCopyPath
	nosOfPdns=`ls | wc -l` 
	echo "Total nos of PDNs to be deployed in this execution is $nosOfPdns ...!! "
	echo "List of PDNs are "
	ls -l | grep ^d | tail -$nosOfPdns | awk '{print $9;}'
	echo "End of the list"
	pdnToBeProcessed=`ls -l | grep ^d | awk '{print $9;}'| tail -1`
	echo "PDN to be processed $pdnToBeProcessed	"		#PDN to be processed
	cd $pdnToBeProcessed			#inside the PDN for deployment of files before trigring the build
	deploymentCount=`ls | grep -v "DB_CODE" | wc -l`
	if [ $deploymentCount -gt 1 ]
	then
		for i in `seq 1 $deploymentCount`
		do
			moduleToProcess=`ls -l | grep ^d | grep -v "DB_CODE" | awk '{print $9;}'| head -$deploymentCount | tail -1`
###===================================== Doing deployment for the JAVA files from the JAVA folder from the PDN =======================================
			if [ "$moduleToProcess" == "java" ]
				then
					cd java
					export javaFileProcess="Y"
					#======================= FUNCTION SPLIT ========================================
					nsOfFiles=`ls | grep -v "Backup"  |wc -l`
					count="$nsOfFiles"
					for i in `seq 1 $nsOfFiles`
					do
						fileNameCurrent=`ls -l | grep -v "Backup" | head -$count |tail -1|awk '{print $9;}'`
						currentFileNamePath=`find "$defaultPath$PerfDomain$workspacePath" -name $fileNameCurrent`
						cp "$currentFileNamePath" Backup
						currentFileNamePath=`echo $currentFileNamePath | awk -F $fileNameCurrent '{print $1}'`
						cp $fileNameCurrent "$currentFileNamePath"
						filesDeployed="$(($filesDeployed+1))"
						#------ Deployment Proof and details --------
						cd "$currentFileNamePath"
						echo "Path :" `pwd` >>test.txt
						echo "File Name :" $fileNameCurrent >>test.txt
						echo "Deployment Timestamp :" `ls -lrt $fileNameCurrent` >>test.txt
						echo "=====================================================================" >>test.txt
						echo "" >>test.txt
						#------ Deployment Proof and details --------
						while [ $count -gt 2 ]
						do
							count="$(($count-1))"
						done
					done
					#======================= FUNCTION SPLIT ========================================
					if [ $filesDeployed -eq $nsOfFiles ]
					then
						echo "-----------**********************************------------------"
						echo "All Files deployed in JSP folder from PDN $pdnToBeProcessed "
						echo "-----------**********************************------------------"
					else
						echo "-----------**********************************--------------------------"
						echo "Attention....!!! There has been some ERROR please deploy manually"
						echo "-----------**********************************------------------"
					fi
###===================================== Doing deployment for the JSP files from the JSP folder from the PDN =======================================
				elif [ "$moduleToProcess" == "jsp" ]
				then
					cd jsp
					nsOfFiles=`ls | grep -v "Backup"  |wc -l`
					count="$nsOfFiles"
					for i in `seq 1 $nsOfFiles`
					do
						fileNameCurrent=`ls -l | grep -v "Backup" | head -$count |tail -1|awk '{print $9;}'`
						currentFileNamePath=`find "$defaultPath$PerfDomain$workspacePath" -name $fileNameCurrent`
						cp "$currentFileNamePath" Backup
						currentFileNamePath=`echo $currentFileNamePath | awk -F $fileNameCurrent '{print $1}'`
						cp $fileNameCurrent "$currentFileNamePath"
						filesDeployed="$(($filesDeployed+1))"
						#------ Deployment Proof and details --------
						cd "$currentFileNamePath"
						echo "Path :" `pwd` >>test.txt
						echo "File Name :" $fileNameCurrent >>test.txt
						echo "Deployment Timestamp :" `ls -lrt $fileNameCurrent` >>test.txt
						echo "=====================================================================" >>test.txt
						echo "" >>test.txt
						#------ Deployment Proof and details --------
						while [ $count -gt 2 ]
						do
						count="$(($count-1))"
						done
						if [ $filesDeployed -eq $nsOfFiles ]
						then
						echo "-----------**********************************------------------"
						echo "All Files deployed in JSP folder from PDN $pdnToBeProcessed "
						echo "-----------**********************************------------------"
					done
				fi
			deploymentCount="$(($deploymentCount-1))"
		done
	fi
	pathOfPdnInProcess=`pwd`
	backUpPathOfPdnInProcess="$pathOfPdnInProcess/Backup"	#----for the backup of the deployed files
	echo $backUpPathOfPdnInProcess
	cd $backUpPathOfPdnInProcess
	cd -
}

javaFilesDeployment ()
{
	pwd
	countOfFiles=`ls | wc -l`
	for i in `seq 1 $countOfFiles`
	find . -name $varFunctionFilename
}


#---------------------- End of Function Declaration -------------------


# ----------------------- Selection of the Env for the deployment automation ------------------------------------
echo -e "\033[1;32m Select Environment where to restart the servers :
        #press 1 for STCM Env
        #press 2 for PERF Env
        #press 3 for DEVCM Env
        #press 4 for SKIP \033[0m"

read selectedEnv
checkUserInput $selectedEnv
userInputChech=$?
if [ $userInputChech -eq 1 ]
        then
                echo "User inputs are non-numeric. Hence exiting the script"
                exit 1
else
   {
        if [ $selectedEnv -eq 1 ] ;
        then
        echo "in the option 1 loop"
        deploymentBuildEnv=$STDomain
		applicationEnv=$AppST_CM
        echo "You have selected $applicationEnv Env and $deploymentBuildEnv deployment path..!!"
        #calling the function selectionForChoice to do the restart depending on the .
        selectionForChoice
        if [[ $? -eq 0 ]]; then
                echo "-----------*****************************-----------"
                echo "Process Completed in $nameOfEnv env"
                echo "-----------*****************************-----------"
        else
        echo ""
        echo "Error occurred while doing the Restart. Please check and re-run the script"
        fi
        elif [ $selectedEnv -eq 2 ] ;
        then
				deploymentBuildEnv=$PerfDomain
				applicationEnv=$AppPERF
                echo "You have selected $applicationEnv Env and $deploymentBuildEnv deployment path..!!"
                #calling the function selectionForChoice to do the restart depending on the .
                selectionForChoice
                if [[ $? -eq 0 ]]; then
                        echo "-----------*****************************-----------"
                        echo "Process Completed in $nameOfEnv env"
                        echo "-----------*****************************-----------"
                else
                        echo ""
                        echo "Error occurred while doing the Restart. Please check and re-run the script"
                fi

        elif [ $selectedEnv -eq 3 ] ;
        then
				deploymentBuildEnv=$DevCmDomain
				applicationEnv=$AppDEVCM
                echo "You have selected $applicationEnv Env and $deploymentBuildEnv deployment path..!!"
                #calling the function selectionForChoice to do the restart depending on the .
                selectionForChoice
                if [[ $? -eq 0 ]]; then
                        echo "-----------*****************************-----------"
                        echo "Process Completed in $nameOfEnv env"
                        echo "-----------*****************************-----------"
                else
                        echo ""
                        echo "Error occurred while doing the Restart. Please check and re-run the script"
                fi

        else
                echo "Sorry something went wrong..!!! Please re-execute the script"
                exit 1
        fi
   }
fi

#====================== Normal Code for the folder transaction ================================
cd $fromCopyPath
nosOfPdns=`ls | wc -l` 
echo "Total nos of PDNs to be deployed in this execution is $nosOfPdns ...!! "
echo "List of PDNs are "
ls -l | grep ^d | tail -$nosOfPdns | awk '{print $9;}'
echo "End of the list"
while [ $nosOfPdns -gt 0 ]
do
	pdnToBeProcessed=`ls -l | grep ^d | awk '{print $9;}'| tail -1`
	echo "PDN to be processed $pdnToBeProcessed	"		#PDN to be processed
	cd $pdnToBeProcessed			#inside the PDN for deployment of files before trigring the build
	deploymentCount=`ls | grep -v "DB_CODE" | wc -l`
	if [ $deploymentCount -ge 1 ]
	then
		for i in `seq 1 $deploymentCount`
		do
			moduleToProcess=`ls -l | grep ^d | grep -v "DB_CODE" | awk '{print $9;}'| head -$deploymentCount | tail -1`
###===================================== Doing deployment for the JAVA files from the JAVA folder from the PDN =======================================
			if [ "$moduleToProcess" == "java" ]
				then
					cd java
					export javaFileProcess="Y"
					deploymentFiles
					if [ $filesDeployed -eq $nsOfFiles ]
					then
						echo "-----------**********************************--------------------------"
						echo "All Files deployed in JAVA folder from PDN $pdnToBeProcessed "
						echo "-----------**********************************--------------------------"
					else
						echo "-----------**********************************--------------------------"
						echo "Attention....!!! There has been some ERROR please deploy manually"
						echo "-----------**********************************--------------------------"
					fi
					cd ..
					pwd
###===================================== Doing deployment for the JSP files from the JSP folder from the PDN =======================================
			elif [ "$moduleToProcess" == "jsp" ]
				then
					cd jsp
					deploymentFiles
						if [ $filesDeployed -eq $nsOfFiles ]
						then
							echo "-----------**********************************------------------"
							echo "All Files deployed in JSP folder from PDN $pdnToBeProcessed "
							echo "-----------**********************************------------------"
						else
							echo "-----------**********************************--------------------------"
							echo "Attention....!!! There has been some ERROR please deploy manually"
							echo "-----------**********************************--------------------------"
						fi
					cd ..
					pwd
			fi
			deploymentCount="$(($deploymentCount-1))" 
		done
	fi
	cd $fromCopyPath
	mv $pdnToBeProcessed $processedPDN
	nosOfPdns="$(($nosOfPdns-1))"
done
