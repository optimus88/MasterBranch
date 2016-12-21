###===================================== CODE FOR REFINEMENT =======================================
#set -x
. variableList.sh
if [ -f "$scriptStatus" ]
then
	echo "Deployment Script is already running.Please try after some time...!!!!"
	exit 1
else
	touch $scriptStatus
	echo "Welcome to the Deployment process through the Deployment Script....!!!"
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
if [ -f "$deployDetailsFile" ]
then
	mv $buildLog $buildLog"_"$backup
fi	
touch $logFile $deployDetailsFile $buildLog

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
							if [ "$extsn" == "java" ]
								then
								pathName=`pwd`
								pdnNos=`echo "$pathName" | awk -F '/DeskTemp/' '{print $2}' | cut -d "/" -f1` 
								jarName=`echo "$currentFileNamePath" | awk -F '/ECLIPSEWORKSPACE' '{print $2}' | cut -d "/" -f2` 
								echo "$pdnNos,$jarName:$fileNameCurrent" >> $deployDetailsFile		#for the file creation of the jar details for post build placing the jar.
							fi
							# =============  Added for the  jar name and PDN details ============= 
							#export filesDeployed="$(($filesDeployed+1))"
						#------ Deployment Proof and details --------
						backUpFileDetails "$currentFileNamePath" "$fileNameCurrent"
						#------ Deployment Proof and details --------
						cd -
				else
					currentFileNamePath=`find "$defaultPath$targetDepEnv$workspacePath" -name $fileNameCurrent`		
					cp "$currentFileNamePath" Backup
					currentFileNamePath=`echo $currentFileNamePath | awk -F $fileNameCurrent '{print $1}'`
					cp $fileNameCurrent "$currentFileNamePath"
					export filesDeployed="$(($filesDeployed+1))"
					#------ Deployment Proof and details --------
					backUpFileDetails "$currentFileNamePath" "$fileNameCurrent"
					cd -
				fi
			#$defaultAppPath"varName for the env"$appDeployPath
				if [ "$extsn" == "js" ] || [ "$fileNameCurrent" == "jsp" ]
				then
					currentFileNamePath=`find "$defaultAppPath$targetDepEnv$appDeployPath" -name $fileNameCurrent`
					cp "$currentFileNamePath" Backup
					currentFileNamePath=`echo $currentFileNamePath | awk -F $fileNameCurrent '{print $1}'`
					cp $fileNameCurrent "$currentFileNamePath"
					export filesDeployed="$(($filesDeployed+1))"
					#--------- Proof for the deployment---------------
					backUpFileDetails "$currentFileNamePath" "$fileNameCurrent"
					cd -
				elif [ "$extsn" == "xml" ]
				then
					currentFileNamePath=`find "$defaultAppPath$targetDepEnv" -name $fileNameCurrent`
					cp "$currentFileNamePath" Backup
					currentFileNamePath=`echo $currentFileNamePath | awk -F $fileNameCurrent '{print $1}'`
					cp $fileNameCurrent "$currentFileNamePath"
					export filesDeployed="$(($filesDeployed+1))"
					#--------- Proof for the deployment---------------
					backUpFileDetails "$currentFileNamePath" "$fileNameCurrent"
					cd -
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
	if [ "$jarName" == "IIMSWeb" ]
	then
		#logic for the .class files below
		fileName=$(echo $fileName| cut -d "." -f1)
		fileName="$fileName.class"
		echo "CLASS_NAME : $jarName"
		echo "PDN Nos : $pdnNos"
		echo "File Name is : $fileName"
		classFilePath=`find "$defaultAppPath$applicationEnvName$appDeployPath" -name $fileName`
		pdnNos="$pdnNos/java"
		cp $classFilePath "$processedPDN$pdnNos" 
		#jarName="" fileName="" pdnNos=""
	else
	jarName="$jarName.jar"
	pdnNos="$pdnNos/java"
	echo "JAR_NAME : $jarName"
	echo "PDN Nos : $pdnNos"
	echo "File Name is : $fileName"
	cp $defaultAppPath$applicationEnvName$appDeployPath$jarName "$processedPDN$pdnNos"
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
			elif [ "$moduleToProcess" == "jsp" ] || [ "$moduleToProcess" == "js" ] || [ "$moduleToProcess" == "xml" ]
				then
					cd jsp
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
	mv $pdnToBeProcessed $processedPDN
	nosOfPdns="$(($nosOfPdns-1))"
done	
}
#=============================================================== BEGIN OF INCREMENTAL BUILD FUNCTION ======================================================
incrementalBuildFunction ()
{
	codeEnv=$1
	appEnv=$2
	cd "/home0/u234695/.jenkins/jobs/"$codeEnv"/workspace/Base Source Code/ECLIPSEWORKSPACE/IIMSBuild/"
	ant -buildfile BuildIIMS.xml "(STEP-1.4)--BuildJar" >> $buildLog 2>&1
	cd $defaultAppPath$appEnv$appDeployPath
	chmod 777 -R *
	echo "Done"
	buildResult=`grep "BUILD SUCCESSFUL" $buildLog`
	if [ $buildResult == "BUILD SUCCESSFUL" ]
	then
		timeTaken=`grep "Total time" $buildLog`
		echo "Build has been successfully completed"
		echo "-------------------------------------------------------------------"
		echo "| 		$timeTaken					    |"
		echo "-------------------------------------------------------------------"
		echo ""	
		return 0
	else
		echo "ERROR IN THE BUILD"
		return 1
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



========================================================= UNRELEVENT DATA =============================================================
	currentFileNamePath=`find "$defaultPath$PerfDomain$workspacePath" -name "Utility.java" -exec grep 'IIMSCore'`		Utility.java

find . -type f -name "*.java" -exec grep -l StringBuffer {} \;
-a is same as using &&
-o is same as using ||

cp: cannot stat `/home0/u234695/.jenkins/jobs/Perfenv_Build/workspace/Base Source Code/ECLIPSEWORKSPACE/BancsApi/src/com/tcs/bancs/insurance/util/Utility.java\n/home0/u234695/.jenkins/jobs/Perfenv_Build/workspace/Base Source Code/ECLIPSEWORKSPACE/IIMSClaim/src/com/tcs/bancs/insurance/core/mediko/bean/Utility.java\n/home0/u234695/.jenkins/jobs/Perfenv_Build/workspace/Base Source Code/ECLIPSEWORKSPACE/IIMSCore/src/com/tcs/bancs/insurance/core/util/Utility.java\n/home0/u234695/.jenkins/jobs/Perfenv_Build/workspace/Base Source Code/ECLIPSEWORKSPACE/IIMSLoadPolicy/IIMSWeb/src/com/tcs/bancs/insurance/core/web/util/Utility.java\n/home0/u234695/.jenkins/jobs/Perfenv_Build/workspace/Base Source Code/ECLIPSEWORKSPACE/IIMSUtil/src/com/tcs/bancs/insurance/core/web/util/Utility.java\n/home0/u234695/.jenkins/jobs/Perfenv_Build/workspace/Base Source Code/ECLIPSEWORKSPACE/IIMSWeb/src/com/tcs/bancs/insurance/core/web/util/Utility.java\n/home0/u234695/.jenkins/jobs/Perfenv_Build/workspace/Base Source Code/ECLIPSEWORKSPACE/NewBusiness/src/com/tcs/bancs/insurance/nb/util/Utility.java': No such file or directory


# ============================== OLD CODEING =======================================

set -x
export AppDEVCM="UATRel_domain"
export AppST_CM="ST_CM"
export AppPERF="perfenv"
export DevCmDomain=""
export STDomain="BaNCS_ST_Build"
export PerfDomain="Perfenv_Build"
export initialPath=/home0/u234695/CM_DEPLOYMENT/
export tempDest=/home0/u234695/CM_DEPLOYMENT/TempDest/
export fromCopyPath=/home0/u234695/CM_DEPLOYMENT/DeskTemp/
export backupPath=/home0/u234695/CM_DEPLOYMENT/BackUp_Files/
export logFile=/home0/u234695/CM_DEPLOYMENT/logs/DeploymentOutput.log
export processedPDN=/home0/u234695/CM_DEPLOYMENT/ProcessedPDN
export defaultPath="/home0/u234695/.jenkins/jobs/"
export workspacePath="/workspace/Base Source Code/ECLIPSEWORKSPACE/"
export STDomain="BaNCS_ST_Build"
export PerfDomain="Perfenv_Build"

        cd $fromCopyPath
        nosOfPdns=`ls | wc -l`
        echo "Total nos of PDNs to be deployed in this execution is $nosOfPdns ...!! "
        echo "List of PDNs are "
        ls -l | grep ^d | tail -$nosOfPdns | awk '{print $9;}'
        echo "End of the list"
        pdnToBeProcessed=`ls -l | grep ^d | awk '{print $9;}'| tail -1`
        echo "PDN to be processed $pdnToBeProcessed     "               #PDN to be processed
        cd $pdnToBeProcessed                    #inside the PDN for deployment of files before trigring the build
        pwd
        deploymentCount=`ls -lrt | grep -v "DB_CODE" | wc -l`
        if [ $deploymentCount -gt 1 ]
        then
                moduleToProcess=`ls -l | grep ^d | awk '{print $9;}'| tail -1`
                        if [ "$moduleToProcess" == "java" ]
                        then
                                javaFilesDeployment                             #calling for the java files deployment
                        elif [ "$moduleToProcess" == "jsp" ]
                        then
                                cd jsp
                                nsOfFiles=`ls | grep -v "Backup"  |wc -l`
                                count="$nsOfFiles"
                                for i in `seq 1 $nsOfFiles`
                                do
                                        fileNameCurrent=`ls -l | grep -v "Backup" | head -$count |tail -1|awk '{print $9;}'`
                                        echo $fileNameCurrent
                                        find "$defaultPath$PerfDomain$workspacePath" -name $fileNameCurrent
                                        while [ $count -gt 2 ]
                                        do
                                        count="$(($count-1))"
                                        done
                                done
                        fi
        fi

		
start=`date +%s`
stuff
end=`date +%s`

runtime=$((end-start))

start=`date +%s`
n=1
while [ $n -lt 10 ]
do
echo "Iteration nos $n"
sleep 8
echo ""
n="$(($n+1))"
done
end=`date +%s`
executionTime=$((end-start))
echo "Total Execution time for Deployment is $(($executionTime / 60)) minutes and $(($executionTime % 60)) seconds."

#======== to get the Jar name ====== Post build

to get the jar name for the preparing the pdn
-------------------------------------------------------------------------------------------
echo "$currentFileNamePath" | awk -F '/ECLIPSEWORKSPACE' '{print $2}' | cut -d "/" -f2
-------------------------------------------------------------------------------------------

currentFileNamePath=`echo $currentFileNamePath | awk -F $fileNameCurrent '{print $1}'`

find . -name '*.xib' | sed 's/.xlib$/.strings/'

find . -name "*.jar" -exec awk -F '{print $1}'  \;

find . -name "*.jar" | rev | cut -d "/" f1

====================== JENKINS SETTINGS FOR INCREMENTAL BUILD(ST_CM) =========================
cp -r /home0/weblogic1035/Oracle/Middleware/user_projects/domains/ST_CM/applications/IIMS/*.jar /home0/weblogic1035/Oracle/Middleware/user_projects/domains/ST_CM/Jars_Backup/

cd /home0/u234695

chmod 777 u234695BuildST.sh

./u234695BuildST.sh

BUILD SUCCESSFUL

Total time: 6 minutes 54 seconds

================================== INCREMENTAL BUILD SCRIPT FOR ALL THE ENVs ======================
domain=BaNCS_ST_Build
one=ST_CM

echo $one
echo $domain

cd "/home0/u234695/.jenkins/jobs/"$domain"/workspace/Base Source Code/ECLIPSEWORKSPACE/IIMSBuild/"

ant -buildfile BuildIIMS.xml "(STEP-1.4)--BuildJar"

cd /home0/weblogic1035/Oracle/Middleware/user_projects/domains/$one/applications
chmod 777 -R IIMS/

echo "Done"


====== FORMATTING THE TEXT in UNIX

PATH=/bin:/usr/bin:

NONE="/033[00m"
RED="/033[01;31m"
GREEN="/033[01;32m"
YELLOW="/033[01;33m"
PURPLE="/033[01;35m"
CYAN="/033[01;36m"
WHITE="/033[01;37m"
BOLD="/033[1m"
UNDERLINE="/033[4m"
END

echo -e "This text is ${RED}red${NONE} and ${GREEN}green${NONE} and ${BOLD}bold${NONE} and ${UNDERLINE}underlined${NONE}."

tput sgr0  ----- Reset the terminal for the changes done in the terminal

30890248761