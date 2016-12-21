###===================================== CODE FOR REFINEMENT =======================================
#set -x
. variableList.sh
. fontFormatting.sh
if [ -f "$scriptStatus" ]
then
	echo "Deployment Script is already running.Please try after some time...!!!!"
	echo ""
	exit 1
else
	touch $scriptStatus
	echo "==============================================================================================="
	echo "|   ${GREEN} Welcome to the Deployment process through the Deployment Script....!!! ${GREEN}" |
	echo "==============================================================================================="
	echo ""
fi
start=`date +%s`
backup=`date +%d%b%Y"_"%H%M%S`
if [ -f "$logFile" ]
then
	mv $logFile $logFile"_"$backup
fi
if [ -f "$deployDetailsFile" ]
then
	mv $deployDetailsFile $deployDetailsFile"_"$backup
fi
if [ -f "$deployLog" ]
then
	mv $deployLog $deployLog"_"$backup
fi
# if [ -f "$DeployLog" ]
# then
	# mv $DeployLog $DeployLog"_"$backup
# fi
touch $logFile $deployDetailsFile $deployLog
echo "Log files created successfully."
echo ""
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
deploymentDetails ()
{
var_arg1="$1"		#-----path of the deployment
var_arg2="$2"		#-----name of the file considered in this loop
#------ Deployment Proof and details --------
cd "$var_arg1"
echo "Path :" `pwd` >>$logFile
echo "File Name :" $var_arg2 >>$logFile
echo "Deployment Timestamp :" `ls -lrt $var_arg2| tail -1` >>$logFile
echo "=====================================================================" >>$logFile
echo "" >>$logFile
#------ Deployment Proof and details --------
}

deployFiles ()
{
targetDepEnv=$1
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
			if [ "$extsn" == "jsp" ] || [ "$extsn" == "java" ] || [ "$extsn" == "xml" ] || [ "$extsn" == "js" ]
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
							currentFileNamePath=`find "$defaultPath$targetDepEnv$workspacePath" -name "$fileNameCurrent" | grep $moduleNameSelected`
							echo "$currentFileNamePath"
							cp "$currentFileNamePath" Backup
							currentFileNamePath=`echo $currentFileNamePath | awk -F $fileNameCurrent '{print $1}'`
							echo $currentFileNamePath
							cp $fileNameCurrent "$currentFileNamePath"
							# =============  Added for the  jar name and PDN details ============= 
#							if [ "$extsn" == "java" ]
#								then
								pathName=`pwd`
								pdnNos=`echo "$pathName" | awk -F '/DeskTemp/' '{print $2}' | cut -d "/" -f1` 
								jarName=`echo "$currentFileNamePath" | awk -F '/ECLIPSEWORKSPACE' '{print $2}' | cut -d "/" -f2` 
								echo "$pdnNos,$jarName:$fileNameCurrent" >> $deployDetailsFile		#for the file creation of the jar details for post build placing the jar.
#							fi
							# =============  Added for the  jar name and PDN details ============= 
						#export filesDeployed="$(($filesDeployed+1))"
						#------ Deployment Proof and details --------
						deploymentDetails "$currentFileNamePath" "$fileNameCurrent"
						#------ Deployment Proof and details --------
						cd -
				elif [ "$extsn" == "java" ]
				then
					currentFileNamePath=`find "$defaultPath$targetDepEnv$workspacePath" -name $fileNameCurrent`		
					cp "$currentFileNamePath" Backup
					currentFileNamePath=`echo $currentFileNamePath | awk -F $fileNameCurrent '{print $1}'`
					cp $fileNameCurrent "$currentFileNamePath"
					export filesDeployed="$(($filesDeployed+1))"
							# =============  Added for the  jar name and PDN details ============= 
#							if [ "$extsn" == "java" ]
#								then
								pathName=`pwd`
								pdnNos=`echo "$pathName" | awk -F '/DeskTemp/' '{print $2}' | cut -d "/" -f1` 
								jarName=`echo "$currentFileNamePath" | awk -F '/ECLIPSEWORKSPACE' '{print $2}' | cut -d "/" -f2` 
								echo "$pdnNos,$jarName:$fileNameCurrent" >> $deployDetailsFile		#for the file creation of the jar details for post build placing the jar.
#							fi
							# =============  Added for the  jar name and PDN details ============= 
					#------ Deployment Proof and details --------
					deploymentDetails "$currentFileNamePath" "$fileNameCurrent"
					cd -
			#$defaultAppPath"varName for the env"$appDeployPath
				elif [ "$extsn" == "js" ] || [ "$extsn" == "jsp" ]
				then
					echo "In the JSP and JS deployment function for $fileNameCurrent file deployment"
					echo ""
					currentFileNamePath=`find "$defaultAppPath$targetDepEnv$appDeployPath" -name $fileNameCurrent`
					cp "$currentFileNamePath" Backup
					currentFileNamePath=`echo $currentFileNamePath | awk -F $fileNameCurrent '{print $1}'`
					cp $fileNameCurrent "$currentFileNamePath"
					export filesDeployed="$(($filesDeployed+1))"
					#--------- Proof for the deployment---------------
					deploymentDetails "$currentFileNamePath" "$fileNameCurrent"
					cd -
				elif [ "$extsn" == "xml" ]
				then
					echo "In the XML deployment function for $fileNameCurrent file deployment"
					echo ""
					currentFileNamePath=`find "$defaultAppPath$targetDepEnv/Reports" -name $fileNameCurrent`
					cp "$currentFileNamePath" Backup
					currentFileNamePath=`echo $currentFileNamePath | awk -F $fileNameCurrent '{print $1}'`
					cp $fileNameCurrent "$currentFileNamePath"
					export filesDeployed="$(($filesDeployed+1))"
					#--------- Proof for the deployment---------------
					deploymentDetails "$currentFileNamePath" "$fileNameCurrent"
					cd -
					echo "2nd Path display"
					pwd
				else 
					echo "The deployment You are looking for is beyond the scope of this script....!!!"
					echo ""
				fi
			else
				echo "The File name provided doesnot seems to be present on the server...!!!"
				exit 0
			fi
			#------ Deployment Proof and details --------
			count="$(($count-1))"
		done
	if [ "$utilFileName" -gt 0 ]
	then
		filesDeployed="$(($filesDeployed+$utilFileName))" 		#deployment count for the file Utility.java file present in the PDN folder
	fi
done
}
#=========================================== Declaration of Function to place the Jar file in the respective PDNs ===============================
jarPlacementFuntion ()
{
applicationEnvName="$1"
echo "Name of the ENV is : $applicationEnvName"
echo ""
filename="$deployDetailsFile"
while read -r line
do
    name="$line"
	jarName=`echo "$name" | cut -d ":" -f1 | cut -d "," -f2`
	pdnNos=`echo "$name" | cut -d "," -f1`
	fileName=`echo "$name" | cut -d ":" -f2`
	if [ "$jarName" == "IIMSWeb" ] || [ "$jarName" == "JMSMessageListener" ]
	then
		#logic for the .class files below
		fileName=$(echo $fileName| cut -d "." -f1)
		fileName="$fileName.class"
		echo "CLASS_NAME : $jarName"
		echo "PDN Nos : $pdnNos"
		echo "File Name is : $fileName"
		classFilePath=`find "$defaultAppPath$applicationEnvName$appDeployPath" -name $fileName`
		pdnNos="$pdnNos/java"
		cp $classFilePath "$processedPDN/$pdnNos" 
		#jarName="" fileName="" pdnNos=""
	else
	jarName="$jarName.jar"
	pdnNos="$pdnNos/java"
	echo "JAR_NAME : $jarName"
	echo "PDN Nos : $pdnNos"
	echo "File Name is : $fileName"
	cp $defaultAppPath$applicationEnvName$appDeployPath$jarName "$processedPDN/$pdnNos"
	echo "Name read from file - $name"
	#jarName="" fileName="" pdnNos=""
	fi
done < "$filename"
}
#============================================== END of Function to place the Jar file in the respective PDNs ==================================

pdnWiseDeloymentProcess ()
{
#====================== Normal Code for the folder transaction ================================
depEnv=$1
appDepEnv=$2
echo "Deployment Env from pdnWiseDeloymentProcess func $depEnv"
cd $fromCopyPath
nosOfPdns=`ls | wc -l` 
echo "Total nos of PDNs to be deployed in this execution is $nosOfPdns ...!! "
echo "List of PDNs are "
ls -l | grep ^d | tail -$nosOfPdns | awk '{print $9;}'
echo "End of the list"
javaCount=0; jspCount=0; jsCount=0; xmlCount=0
while [ $nosOfPdns -gt 0 ]
do
	pdnToBeProcessed=`ls -l | grep ^d | awk '{print $9;}'| tail -1`
	echo "PDN to be processed $pdnToBeProcessed	"		#PDN to be processed
	cd $pdnToBeProcessed			#inside the PDN for deployment of files before trigring the build
	deploymentCount=`ls | grep -v "DB_CODE" | wc -l`
	depCount=$deploymentCount
	if [ $deploymentCount -ge 1 ]
	then
		for i in `seq 1 $deploymentCount`
		do
			moduleToProcess=`ls -l | grep ^d | grep -v "DB_CODE" | awk '{print $9;}'| head -$deploymentCount | tail -1`
###===================================== Doing deployment for the JAVA files from the JAVA folder from the PDN =======================================
			if [ "$moduleToProcess" == "java" ]
				then
					cd java
					javaCount=1
					export javaFileProcess="Y"
					deployFiles $depEnv
					if [ $filesDeployed -eq $nsOfFiles ]
					then
						echo "-----------**********************************--------------------------"
						echo "All Files deployed in JAVA folder from PDN $pdnToBeProcessed "
						echo "-----------**********************************--------------------------"
						echo ""
					else
						echo "-----------**********************************--------------------------"
						echo "Attention....!!! There has been some ERROR please deploy manually"
						echo "-----------**********************************--------------------------"
						echo ""
					fi
					cd ..
					pwd
###===================================== Doing deployment for the JSP files from the JSP folder from the PDN =======================================
			elif [ "$moduleToProcess" == "jsp" ]
				then
					cd jsp
					jspCount=1
					deployFiles $appDepEnv
						if [ $filesDeployed -eq $nsOfFiles ]
						then
							echo "-----------**********************************------------------"
							echo "All Files deployed in JSP folder from PDN $pdnToBeProcessed "
							echo "-----------**********************************------------------"
							echo ""
						else
							echo "-----------**********************************--------------------------"
							echo "Attention....!!! There has been some ERROR please deploy manually"
							echo "-----------**********************************--------------------------"
							echo ""
						fi
					cd ..
					pwd
			elif [ "$moduleToProcess" == "js" ]
				then
					cd js
					jsCount=1
					deployFiles $appDepEnv
						if [ $filesDeployed -eq $nsOfFiles ]
						then
							echo "-----------**********************************------------------"
							echo "All Files deployed in JSP folder from PDN $pdnToBeProcessed "
							echo "-----------**********************************------------------"
							echo ""
						else
							echo "-----------**********************************--------------------------"
							echo "Attention....!!! There has been some ERROR please deploy manually"
							echo "-----------**********************************--------------------------"
							echo ""
						fi
					cd ..
					pwd
			elif [ "$moduleToProcess" == "xml" ]
				then
					cd xml
					xmlCount=1
					deployFiles $appDepEnv
						if [ $filesDeployed -eq $nsOfFiles ]
						then
							echo "-----------**********************************------------------"
							echo "All Files deployed in JSP folder from PDN $pdnToBeProcessed "
							echo "-----------**********************************------------------"
							echo ""
						else
							echo "-----------**********************************--------------------------"
							echo "Attention....!!! There has been some ERROR please deploy manually"
							echo "-----------**********************************--------------------------"
							echo ""
						fi
					cd ..
					pwd					
			fi
			deploymentCount="$(($deploymentCount-1))" 
		done
	fi
	cd $fromCopyPath
	totalCount="$(($javaCount+$jspCount+$jsCount+$xmlCount))"
	if [ $depCount -eq $totalCount ]
	then
		mv $pdnToBeProcessed $processedPDN
		echo "Processed PDN nos $pdnToBeProcessed has been moved to Processed PDN folder..!!!"
		echo ""
	else
		echo "Error...!!! As all the files were not deployed, Hence PDN : $pdnToBeProcessed not moved to Processed PDN folder..!!!"
		exit 0
	fi
	javaCount=0; jspCount=0; jsCount=0; xmlCount=0
	nosOfPdns="$(($nosOfPdns-1))"
done	
}
#=============================================================== BEGIN OF INCREMENTAL BUILD FUNCTION ======================================================
incrementalBuildFunction ()
{
	codeEnv=$1
	appEnv=$2
	buildNoOld=`grep -i build "$buildNos" | cut -d ":" -f2`
	buildNoNew="$(($buildNoOld+1))"
	if [ $buildNoNew -lt 10 ]
	then
		>$buildNos
		echo "Build Nos : 0$buildNoNew" >>$buildNos
	else
		>$buildNos
		echo "Build Nos : $buildNoNew" >>$buildNos
	fi
	#cd "/home0/u234695/.jenkins/jobs/"$codeEnv"/workspace/Base Source Code/ECLIPSEWORKSPACE/IIMSBuild/"
	varBuildFile="$defaultPath$codeEnv"$workspacePath"IIMSBuild/BuildIIMS.xml"
	#ant -buildfile BuildIIMS.xml "(STEP-1.4)--BuildJar" >> $buildLog 2>&1
	echo "Build will be done as there was a java file deployed."
	echo ""
	ant -buildfile "$varBuildFile" "(STEP-1.4)--BuildJar" >> $buildLog 2>&1
	cd $defaultAppPath$appEnv$appDeployPath
	chmod 777 -R * >> $buildLog 2>&1
	echo "Done"
	buildResult=""
	buildResult=`grep 'BUILD SUCCESSFUL' $buildLog` 
	echo "$buildResult" >> $buildLog
	if [ "$buildResult" == "BUILD SUCCESSFUL" ]
	then
		timeTaken=`grep "Total time" $buildLog`
		echo "Build has been successfully completed"
		echo "-------------------------------------------------------------------"
		echo "| $timeTaken				|"
		echo "-------------------------------------------------------------------"
		echo ""
		buildResult=""
	else
		echo "ERROR IN THE BUILD"
		exit 1
	fi
}
#================================================================ END OF INCREMENTAL BUILD FUNCTION =======================================================

#=============================================================== END OF THE FUNCTION ======================================================

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
		nameOfEnv="STCM"
        echo "You have selected $applicationEnv Env and $deploymentBuildEnv deployment path..!!"
        #calling the function selectionForChoice to do the restart depending on the .
        pdnWiseDeloymentProcess $deploymentBuildEnv $applicationEnv
		if [ $javaFileProcess == "Y" ]
		then
			incrementalBuildFunction $deploymentBuildEnv $applicationEnv
			jarPlacementFuntion $applicationEnv
		fi
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
				nameOfEnv="PERF"
                echo "You have selected $applicationEnv Env and $deploymentBuildEnv deployment path..!!"
                #calling the function selectionForChoice to do the restart depending on the .
                pdnWiseDeloymentProcess $deploymentBuildEnv
				if [ $javaFileProcess == "Y" ]
				then
					incrementalBuildFunction $deploymentBuildEnv $applicationEnv
					jarPlacementFuntion $applicationEnv
				fi
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
				nameOfEnv="DEVCM"
                echo "You have selected $applicationEnv Env and $deploymentBuildEnv deployment path..!!"
                #calling the function selectionForChoice to do the restart depending on the .
                pdnWiseDeloymentProcess $deploymentBuildEnv
				if [ $javaFileProcess == "Y" ]
				then
					incrementalBuildFunction $deploymentBuildEnv $applicationEnv
					jarPlacementFuntion $applicationEnv
				fi
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
end=`date +%s`
executionTime=$((end-start))
echo "Total Execution time for Deployment is $(($executionTime / 60)) minutes and $(($executionTime % 60)) seconds."
#	echo "Total Execution time for Deployment is $executionTime"
rm $scriptStatus		#-------- to remove the lock for the next execution of deployment script.
