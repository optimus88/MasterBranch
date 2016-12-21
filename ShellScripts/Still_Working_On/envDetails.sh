hostname_variable=$(hostname)
#echo $hostname_variable;

######################### Initialising Default names of the Env ######################

defaultValueDev1="uswauswbapvmd1l.am.health.ge.com"
defaultValueDev3="uswauswbapvmd2l.am.health.ge.com"
defaultValuetst1="uswauswbapvmt1l.am.health.ge.com"
defaultValuetst2Box1="usmkeswbapvmt1l.am.health.ge.com"
defaultValuetst2Box2="usmkeswbapvmt2l.am.health.ge.com"
defaultValuetst2Box3="usmkeswbapvmt3l.am.health.ge.com"
defaultValuetst2Box4="usmkeswbapvmt4l.am.health.ge.com"
defaultValueStgBox1="usmkeswbapvms1l.am.health.ge.com"
defaultValueStgBox2="usmkeswbapvms2l.am.health.ge.com"
defaultValueStgBox3="usmkeswbapvms3l.am.health.ge.com"
defaultValueStgBox4="usmkeswbapvms4l.am.health.ge.com"
defaultValueDev4="usmkeswbapvmd2l.am.health.ge.com"
defaultValueDev5="usmkeswbapvmd3l.am.health.ge.com"


######################## Checking for the Env ##############################

if [ "$hostname_variable" = "$defaultValueDev1" ]
then
env_is="DEV-1"
echo "The env is "$env_is
sleep 3
elif [ "$hostname_variable" = "$defaultValueDev3" ]
then
env_is="DEV-3"
elif [ "$hostname_variable" = "$defaultValuetst1" ]
then
env_is="TST-1"
echo "The env is "$env_is
elif [ "$hostname_variable" = "$defaultValuetst2Box1" ]
then
env_is="Tst2-Box-1"
elif [ "$hostname_variable" = "$defaultValuetst2Box2" ]
then
env_is="Tst2-Box-2"
elif [ "$hostname_variable" = "$defaultValuetst2Box3" ]
then
env_is="Tst2-Box-3"
elif [ "$hostname_variable" = "$defaultValuetst2Box4" ]
then
env_is="Tst2-Box-4"
elif [ "$hostname_variable" = "$defaultValueStgBox1" ]
then
env_is="STG-Box-1"
elif [ "$hostname_variable" = "$defaultValueStgBox2" ]
then
env_is="STG-Box-2"
elif [ "$hostname_variable" = "$defaultValueStgBox3" ]
then
env_is="STG-Box-3"
elif [ "$hostname_variable" = "$defaultValueStgBox4" ]
then
env_is="STG-Box-4"
elif [ "$hostname_variable" = "$defaultValueDev4" ]
then
env_is="DEV-4"
elif [ "$hostname_variable" = "$defaultValueDev5" ]
then
env_is="DEV-5"
fi

export env_Details=$env_is

