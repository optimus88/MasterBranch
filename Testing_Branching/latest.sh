# File Deployment in diff enviornments
#!/bin/bash
# Name: 
# Module: deploy files
# Author: Keshav & Abhijit Kumar
# Version 1.0
# Description: deploy files in respective dir
#==============================================================================================================

#============================================Variables Declaration=============================================
varFilename=""
varCount=""
extsn=""
. list.sh
. envDetails.sh
. identify.sh
touch $backupDetails
#=============================Function to Create Backup and Deploy Files=========================================
function_deploy()
{
backup=`date +%d%b%Y"_"%H%M%S`
arg1_var=$1
arg2_var=$2
backupFileName=$arg1_var"_"$backup
mv $arg1_var $backupFileName
mv $arg2_var$arg1_var .
echo "============Backup Details for :" $arg1_var "as Follows===================" >>$backupDetails
echo "Hostname :: "$host_name >>$backupDetails
echo "Path     :: "$(pwd) >>$backupDetails
ls -lrt $backupFileName >>$backupDetails
echo "=============================================================================" >>$backupDetails
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

#===========================================Copying Files from WEBTST2 Box=======================================
cd $tempDest
#rm -fr *					#clearing the tempDest folder

#Copy command for all the files from the WEB-TST2 Server
scp weblogic@swb-web-tst-02.am.health.ge.com:/export/home/weblogic/CMQA_FILES/* $tempDest

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
function_deploy $varFilename $tempDest 
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
function_deploy $varFilename $tempDest
else
echo "File not found in "$dest_classes "dir."
cd $dest_ui
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_ui
function_deploy $varFilename $tempDest
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
function_deploy $varFilename $tempDest
else
#echo "file not in " $dest_docs
cd $dest_ssp
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_ssp
function_deploy $varFilename $tempDest
else
#echo "file not in " $dest_ssp
cd $dest_xml
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_xml
function_deploy $varFilename $tempDest
else 
#echo "file not in " $dest_xml
cd $dest_workflow
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_workflow
function_deploy $varFilename $tempDest
else
#echo "file not in " $dest_workflow
cd $dest_xsl
if [ -f "$varFilename" ]
then
echo "File Found in " $dest_xsl
function_deploy $varFilename $tempDest
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
fi
else 
rm $backupDetails
echo ""
echo "============================================================================="
echo "Temporary Directory is not having any file to Deploy."
echo "============================================================================="
fi
#ssh weblogic@swb-web-tst-02.am.health.ge.com 'rm /export/home/weblogic/CMQA_FILES/*'
echo "The deployment is done"

/apps/cpq/scripts/conf_bounce.sh



