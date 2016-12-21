mkdir tmp gemsFile
javaPath=/apps/cpq/java/64bit/jdk1.6.0_31/bin/jar
export initialPath=/data/cpq/CMQA_TEMP_FILES/
export tempDest=/data/cpq/CMQA_TEMP_FILES/tempDest
export pathDest=/data/cpq/selectica/apps/cpq/classes/
export path=/data/cpq/CMQA_TEMP_FILES/tmp/
export fromCopyPath=/data/cpq/CMQA_TEMP_FILES/gemsFile/
export fileName=GemsCPQPlugin.jar
export logFile=/data/cpq/CMQA_TEMP_FILES/logs/output.log
echo "Copy files to the temp location"
cp /data/cpq/CMQA_TEMP_FILES/deskTemp/* /data/cpq/CMQA_TEMP_FILES/gemsFile/     #copy files to be deployed to the temp location
sleep 1
>$logFile
cp $pathDest$fileName $path                     #copying the gemsplugin jar to the remote location
cd $path                                                        #moving to the remote location
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
#========================== Function for the multiple files ====================================
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
                rm $varFunctionFilename
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
#===============================================================================================

#============================ Function for the Single files ====================================
singleFileReplace ()
{
	singleFunFilename=$1
	echo "In the single deployment loop fun"
    #varFilename=`ls -lrt | awk '{print $9}'|tail -1`
    cd $path
    singleSearchResult=`find . -name $singleFunFilename`
    depPathSingleName=`echo $singleSearchResult | sed 's/^..//'`
	depPathSingle=`echo $depPathSingleName | awk -F $singleFunFilename '{print $1}'`
	echo $depPathSingle
    sleep 2
    if [ -n "$depPathSingle" ]
        then
            cd $depPathSingle
            if [ -f "$singleFunFilename" ]
				then
                    rm $singleFunFilename
                    cp $fromCopyPath$singleFunFilename .
					singleFunFilename=""
                else
                    echo "File not present in the extracted Jar..."
                    echo ""
                    sleep 1
                    exit 1
            fi
		else
			echo "User file to be deployed was not found inside the Jar file.."
			echo ""
			echo "Exititng the Process incomplete"
			exit 1
    fi
}
#===============================================================================================

echo "Checking for the UserProvide file to place in jar."
echo ""
cd $fromCopyPath
filePresentCount=`ls | wc -l`
if [ $filePresentCount -eq 1 ]
	then 
		echo "In the single chk deployment loop....."
		varFilename=`ls -lrt | awk '{print $9}'|tail -1`
		singleFileReplace $varFilename
				
	elif [ $filePresentCount -gt 1 ]
		then
			echo "In the multiple chk deployment loop...."
			for i in `seq 1 $filePresentCount`
				do
					varFilename=`ls -lrt | awk '{print $9}'|tail -1`
					multipleFileReplace $varFilename
					cd $fromCopyPath
					rm $varFilename
					varFilename=""
				done
	else
		echo "File not present to be placed in the jar"
		exit 1
fi
				
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
	chmod 755 $fileName
	ls -lrt $fileName
	cp $fileName $tempDest
	pwd
	rm -fr *
	echo "Dir $path has been cleared..."
	echo ""
	cd $initialPath
	rm -fr tmp gemsFile
	pwd
	cd /data/cpq/CMQA_TEMP_FILES/deskTemp/
	rm -fr *
	mv $tempDest/$fileName .
	rm $tempDest/*
