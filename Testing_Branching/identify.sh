#Checking for the email Id of the working person
#Abhijit=lg234806/abhijitkumar@ge.com
#Aditya=lg184866/aditya.dheeraj@ge.com
#Amit=lg262729/amitchauhan@ge.com
#Amlendu=lg213174/amlendu.kumar@ge.com
#Annu=lg133712/Annu.Singh@ge.com
#Keshav=lg170891/keshav.choudhary@ge.com
#Niranjan=lg262728/niranjan.borate@ge.com


echo "Please enter your UNIX LG ID"
read LG_ID
if [ $LG_ID = 'lg234806' ]
then
echo "ABHIJIT is the User"
emailID="abhijitkumar@ge.com"
echo "Mailing address is : "$emailID
elif [ $LG_ID = 'lg262729' ]
then
echo "Amit is the User"
emailID="amitchauhan@ge.com"
echo "Mailing address is : "$emailID
elif [ $LG_ID = 'lg213174' ]
then
echo "Amlendu is the User"
emailID="amlendu.kumar@ge.com"
echo "Mailing address is : "$emailID
elif [ $LG_ID = 'lg133712' ]
then
echo "Annu is the User"
emailID="Annu.Singh@ge.com"
echo "Mailing address is : "$emailID
elif [ $LG_ID = 'lg170891' ]
then
echo "Keshav is the User"
emailID="keshav.choudhary@ge.com"
echo "Mailing address is : "$emailID
elif [ $LG_ID = 'lg262728' ]
then
echo "Niranjan is the User"
emailID="niranjan.borate@ge.com"
echo "Mailing address is : "$emailID
else  
echo "Unknow User"
fi
export emailid=$emailID
echo $emailid;
echo "Deployment Requested by "
read userName
export userName

