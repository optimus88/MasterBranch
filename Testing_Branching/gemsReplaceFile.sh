javaPath=/apps/cpq/java/64bit/jdk1.6.0_31/bin/jar
initialPath=/data/cpq/CMQA_TEMP_FILES/
path=/data/cpq/CMQA_TEMP_FILES/tmp/
tempDest=/data/cpq/CMQA_TEMP_FILES/tempDest
pathDest=/data/cpq/selectica/apps/cpq/classes/
fromCopyPath=/data/cpq/CMQA_TEMP_FILES/gemsFile/
fileName=GemsCPQPlugin.jar
logFile=/data/cpq/CMQA_TEMP_FILES/logs/output.log
>$logFile
cp $pathDest$fileName $path			#copying the gemsplugin jar to the remote location
cd $path							#moving to the remote location
pwd
echo "Jar Extraction in process"
echo ""
dateVar=`date +%d%b%Y"_"%H%M%S`
echo "=======================$dateVar==============================">>$logFile
$javaPath -xvf $fileName >>$logFile
dateVar=`date +%d%b%Y"_"%H%M%S`
echo "=======================$dateVar==============================">>$logFile
echo "">>$logFile
sleep 2
echo "Checking for the UserProvide file to place in jar."
echo ""
cd $fromCopyPath
filePresentCount=`ls | wc -l`
if [ $filePresentCount -eq 1 ]
	then
		varFilename=`ls -lrt | awk '{print $9}'|tail -1`
		cd $path
		var=`find . -name $varFilename`
		depPath=`echo $var | sed 's/^..//' | awk -F 'PriceInfoProvider.class' '{print $1}'`
		sleep 2
		if [ -n "$depPath" ]
			then
				cd $depPath
				if [ -f "$varFilename" ]
					then
						rm $varFilename
						cp $fromCopyPath$varFilename .
					else
						echo "File not present in the extracted Jar..."
						echo ""
						sleep 1
						exit 1
				fi
			else
				echo "User file to be deployed was not found inside the Jar file.."
				echo ""
				exit 1
		fi
	else
		echo "User provided file not present. Hence quiting."
		echo ""
		exit 1
fi
#cp $varFilename ${PATH}
cd $path
echo "Removing jar file to create the new Jar file...."
echo ""
rm $fileName
dateVar=`date +%d%b%Y"_"%H%M%S`
echo "=======================$dateVar==============================">>$logFile
$javaPath -cvf $fileName * >>$logFile
dateVar=`date +%d%b%Y"_"%H%M%S`
echo "=======================$dateVar==============================">>$logFile
echo "">>$logFile
sleep 1
echo "Jar file created successfully...."
echo ""
ls -lrt $fileName
cp $fileName $tempDest
pwd
rm -fr *
echo "Dir $path has been cleared..."
echo ""
cd $initialPath
pwd
#latest.sh
