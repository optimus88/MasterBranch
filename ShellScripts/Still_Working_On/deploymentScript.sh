# File Deployment in diff enviornments
#!/bin/bash
# Name: 
# Module: deploy files
# Author: Keshav & Abhijit Kumar
# Version 1.1
# Description: deploy files in respective dir options updated.
#==============================================================================================================

#============================================Variables Declaration=============================================
varFilename=""
varCount=""
extsn=""
. list.sh
. envDetails.sh
. identify.sh
touch $backupDetails
echo "------------------------------------------------------------"
echo "Is backup to be taken for the deployment (y/yes or n/no)"
echo "------------------------------------------------------------"
echo ""
read backupRequiredAns
echo $backupRequiredAns
# Condition chk for valid input
if [ "$backupRequiredAns" != "yes" ] && [ "$backupRequiredAns" != "YES" ] && [ "$backupRequiredAns" != "Y" ] && [ "$backupRequiredAns" != "y" ] && [ "$backupRequiredAns" != "no" ] && [ "$backupRequiredAns" != "NO" ] && [ "$backupRequiredAns" != "N" ] && [ "$backupRequiredAns" != "n" ]  
	then
	chkValueAns=""	
	echo "------------------------------------------------------------"
	echo "Input invalid please re-execute the script"
	echo "------------------------------------------------------------"
	echo ""
	#echo $chkValueAns
	if [ -s "$backupDetails" ]
		then
			mail -s "${env_Details} -Script Deployment Details" ${emailid} -- -f keshav.choudhary@ge.com < $backupDetails
			rm $backupDetails
	fi
	exit 1
else
	chkValueAns=1
	if [ "$backupRequiredAns" == "yes" ] || [ "$backupRequiredAns" == "YES" ] || [ "$backupRequiredAns" == "Y" ] || [ "$backupRequiredAns" == "y" ]
		then
		echo ""
		echo "You have selected for the deployment with BACKUP."
		echo ""
		echo $chkValueAns
	else
		chkValueAns=0
		echo ""
		echo "You have selected for the deployment without BACKUP."
		echo ""
		echo $chkValueAns
	fi
fi

#=============================Function to Create Backup and Deploy Files=========================================
function_deploy()
{
backup=`date +%d%b%Y"_"%H%M%S`
arg1_var=$1
arg2_var=$2
arg3_var=$3
arg4_var=$4
if [ "$arg4_var" -eq 1 ] 
	then
		echo ""
		echo "The files are being deployed after taking backup... "
		sleep 2
		backupFileName=$arg1_var"_"$userName"_"$backup
		mv $arg1_var $arg3_var$backupFileName
		mv $arg2_var$arg1_var .
		cd $arg3_var
		echo "============Backup Details for :" $arg1_var "as Follows===================" >>$backupDetails
		echo "Hostname :: "$host_name >>$backupDetails
		echo "Path     :: "$(pwd) >>$backupDetails
		ls -lrt $backupFileName >>$backupDetails
		echo "=============================================================================" >>$backupDetails
elif [ "$arg4_var" -eq 0 ] 
	then
		echo ""
		echo "The files are being deployed without taking backup... "
		sleep 2
		echo ""
		mv $arg2_var$arg1_var .
		echo "============ Deployment Details for :" $arg1_var "as Follows ===================" >>$backupDetails
		echo "Hostname :: "$host_name >>$backupDetails
		echo "Path     :: "$(pwd) >>$backupDetails
		ls -lrt $arg1_var >>$backupDetails
		echo "=============================================================================" >>$backupDetails
else
	echo ""
	echo "Deployment cannot be done.Please deploy manually..!!"
	echo ""
	if [ -s "$backupDetails" ]
		then
			mail -s "${env_Details} -Script Deployment Details" ${emailid} -- -f keshav.choudhary@ge.com < $backupDetails
			rm $backupDetails
	fi
	exit 1
fi
}
function_notFound()
{
arg1_var=$1
arg2_var=$2
arg3_var=$3
echo "File ::" $arg2_var " is beyond the scope of this Script. Please deploy manually. "
mv $arg1_var$arg2_var $arg3_var
}
#================================================================================================================

#=========================================== Copying Files from deskTemp to tempDest =======================================
cd $tempDest
rm -fr *
cp $deskTemp* .

#===============================================================================================================
varCount=`ls |wc -l`
if [ $varCount -gt 0 ]
then
for i in `seq 1 $varCount`
do
cd $tempDest

varFilename=`ls -lrt | awk '{print $9}' | head -n2 |tail -1`
echo ""
echo "The file to be Processed is ==  "$varFilename
echo ""
extsn=$(echo $varFilename|awk -F . '{print $NF}')
echo "Extension of the file == "$extsn
echo ""
if [ -n "$extsn" ] && [ "$extsn" != "db" ] && [ "$extsn" != "jar" ] && [ "$extsn" != "properties" ] && [ "$extsn" != "xml" ] && [ "$extsn" != "ssp" ] && [ "$extsn" != "html" ] && [ "$extsn" != "xsl" ]
then 
function_notFound $tempDest $varFilename $dest_notFound
fi
#========================================Comparision for DB EXTENSION===========================================
if [ "$extsn" = "db" ]
then
echo "Checking for the Directory having db as extension"
echo ""
cd $dest_cpq
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_cpq
function_deploy $varFilename $tempDest $backup_dest_cpq $chkValueAns
fi
#========================================Comparision for JAR/PROPERTIES=========================================
elif [ "$extsn" = "jar" ] || [ "$extsn" = "properties" ]
then
echo "Checking for the Directory having jar or properties as extension"
echo ""
cd $dest_classes
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_classes
function_deploy $varFilename $tempDest $backup_dest_classes $chkValueAns
else
echo "File not found in "$dest_classes "dir."
cd $dest_ui
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_ui
function_deploy $varFilename $tempDest $backup_dest_ui $chkValueAns
else
echo "File not found in "$dest_ui " dir."
fi
fi
#========================================Comparision for HTML/SSP/XML=============================================
elif [ "$extsn" = "xml" ] || [ "$extsn" = "ssp" ] || [ "$extsn" = "html" ] || [ "$extsn" = "xsl" ]
then
echo "Checking for the file having html,ssp or xml as extension"
cd $dest_docs
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_docs
function_deploy $varFilename $tempDest $backup_dest_docs $chkValueAns
else
#echo "file not in " $dest_docs
cd $dest_ssp
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_ssp
function_deploy $varFilename $tempDest $backup_dest_ssp $chkValueAns
else
#echo "file not in " $dest_ssp
cd $dest_xml
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_xml
function_deploy $varFilename $tempDest $backup_dest_xml $chkValueAns
else 
#echo "file not in " $dest_xml
cd $dest_workflow
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_workflow
function_deploy $varFilename $tempDest $backup_dest_workflow $chkValueAns
else
#echo "file not in " $dest_workflow
cd $dest_xsl
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_xsl
function_deploy $varFilename $tempDest $backup_dest_xsl $chkValueAns
else 
echo "File ::" $varFilename " is NOT FOUND at any dir. Please deploy manually..!!!"
function_notFound $tempDest $varFilename $dest_notFound
fi
fi
fi
fi 
fi
fi
done
cd $tempDest
leftFileCount=`ls |wc -l`
if [ $leftFileCount -gt 0 ]
then
mv * $dest_notFound
echo ""
echo "============================================================================="
echo "Please chk  "$dest_notFound "dir for left over files"
echo "============================================================================="
else
echo ""
echo "============================================================================="
echo "All files are Found and Deployed...."
echo "============================================================================="
echo ""
fi
if [ -s "$backupDetails" ]
then
mail -s "${env_Details} -Script Deployment Details" ${emailid} -- -f keshav.choudhary@ge.com < $backupDetails
#mail -s "${env_Details} -Script Deployment Details" ${emailid} < $backupDetails
echo "Mails sent Please chk your Inbox @ :" ${emailid}
rm $backupDetails
else
echo "============================================================================="
echo "NO Mails Sent....."
echo "============================================================================="
echo ""
fi
else 
rm $backupDetails
echo ""
echo "============================================================================="
echo "Temporary Directory is not having any file to Deploy."
echo "============================================================================="
echo ""
fi
#ssh weblogic@swb-web-tst-02.am.health.ge.com 'rm /export/home/weblogic/CMQA_FILES/*'
echo "-----------------------------------------------------------------------------"
echo "|*****************  The Deployment Is Done  ********************************|"
echo "-----------------------------------------------------------------------------"
echo ""
echo "-----------------------------------------------------------------------------"
echo "|***Please clear the $deskTemp directory for the uploaded files. Thanks*****|"
echo "-----------------------------------------------------------------------------"
sleep 4
cd $deskTemp
rm -fr *

/apps/cpq/scripts/bounce.sh


