############################ Server Restart Script for the DEV1 Env - By CMQA ################################
echo "Enter 1 to kill the processes"
echo "Enter 2 to start processes after kill"
echo "Enter 3 to do clean bounce (kill + start) "
read NUM

############################################# End of Choice making Loop ######################################





kill_servers ()
{

ps_kill=`ps auxgww|grep DACE_SERVER|grep -v grep |awk '{print $2 " "}'`
echo "Processes runnig are :"

echo $ps_kill

############################ Killing Processes ################################

echo "Killing processes..."

kill -9 $ps_kill

echo "Processes killed"

/apps/cpq/scripts/aceps

}

start_servers ()
{

echo "Please enter number of Pricer you want to restart..."
read p
echo "Please enter number of Pricer you want to restart..."
read q
echo "Please enter number of Pricer you want to restart..."
read con


#############check p not null , not equal to zero and less than/equal to 3###############

z=0
if [ -n "$p" ] && [ $p != "$z" ] && [ $p -le 3 ]
then
echo ""
else
echo "Error!!!"
echo "Please enter number of Pricer you want to restart..."
read p
if [ -n "$p" ] && [ $p != "$z" ] && [ $p -le 3 ]
then
echo ""
else
echo "You have entered wrong values twice,hence aborting the script.Please execute it again with correct values."
exit 1
fi


fi

echo "Please enter number of Quoter you want to restart..."
read q

#############check q not null , not equal to zero and less than/equal to 4###############

z=0
if [ -n "$q" ] && [ $q != "$z" ] && [ $q -le 4 ]
then
echo ""
else
echo "Error!!!"
echo "Please enter number of Quoter you want to restart..."
read q
if [ -n "$q" ] && [ $q != "$z" ] && [ $q -le 4 ]
then
echo ""
else
echo "You have entered wrong values twice,hence aborting the script.Please execute it again with correct values."
exit 1
fi

fi

echo "Please enter number of Configurator you want to restart..."
read con

#############check con not null , not equal to zero and less than/equal to 10###############
z=0
if [ -n "$con" ] && [ $con != "$z" ] && [ $con -le 10 ]
then
echo ""
else
echo "Error!!!"
echo "Please enter number of Configurators you want to restart..."
read con
if [ -n "$con" ] && [ $con != "$z" ] && [ $con -le 10 ]
then
echo ""
else
echo " You have entered wrong values twice,hence aborting the script.Please execute it again with correct values."
exit 1
fi

fi

echo "You have entered correct entries"

echo "Restarting servers"

############################# Starting Pricers In DEV1################################
hn=$HOSTNAME
h=${hn:13:1}

for m in `seq 1 $p`

do

/apps/cpq/selectica/Pricer/PricerServer_$m/pricerServer.unix

echo "Pricer $m is starting..."


sleep 90
echo "Out of sleep loop..."

c=0
while [ $c == "0" ]
do
chck=`tail -20 /logs/cpq/pricer/pricer"$m"_console.out|grep -o "711$m"`
echo $chck

if [ $chck == "711$m" ]
then

c=1
break

else
sleep 10

fi
echo $c
done

if [ $c == "1" ]
then
echo "Pricer $i started Successfully"
fi

done

/apps/cpq/selectica_validation/Pricer/PricerServer_1/pricerServer.unix

echo "Validation Pricer is starting...."
sleep 90

t=0
while [ $t == "0" ]
do
chck=`tail -2 /logs/cpq/pricer/val_pricer1_console.out|grep -o "7131"`
echo $chck
if [ $chck == "7131" ]
then

t=1
break

else
sleep 20

fi
done

if [ $t == "1" ]
then
echo "Validation Pricer has started..!!!"
fi




############################# Starting Quoters ################################

for j in `seq 1 $q`
do
cd /apps/cpq/selectica/Quoter_$j
./runquoter.unix
sleep 5
echo "Quoter $j started"
done



############################# Starting Configurators ################################

for k in `seq 1 $con`
do
cd /apps/cpq/selectica/Configurator_$k
./runserver.unix
sleep 5
echo "Configurator $k started"
done

cd /apps/cpq/scripts
./aceps

}

restart_servers ()
{
kill_servers
start_servers
}

case $NUM in
        1) kill_servers ;;
        2) start_servers ;;
        3) restart_servers ;;
        *) echo "INVALID NUMBER!" ;;
esac




