#!/bin/bash
#V A add in chmod scratch_gpio.sh
#Version B � go back to installing deb gpio package directly
#Version C � install sb files into /home/pi/Documents/Scratch Projects
#Version D � create �/home/pi/Documents/Scratch Projects� if it doesn�t exist
#Version E � change permissions on �/home/pi/Documents/Scratch Projects�
#Version F 13Oct12 � rem out rpi.gpio as now included in Raspbian
#Version G 20Mar13 - Allow otheruser option on commandline (Tnever/meltwater)
#Version H 24Mar13 - correct newline issues
#Version 29Oct13 Add in Chown commands and extra Adafruit and servod files and alter gpio_scrath2.sh and bit of chmod +x make V3
#Version 21Nov13 Change for szero V4
#Version 26Dec13 Change for szero4plus
#Version 18Dec13 Change for szero5
#Version 4Aug14 - change for szero5
#Version 17Sep15 debug creating old szero icons

SGHVER=$(<SGHVER.txt)
SGHVER=''
f_exit(){
echo ""
echo "Usage:"
echo "i.e. sudo NameOfInstaller.sh otheruser"
echo "Optional: Add a non-default 'otheruser' username after the command (default is:pi)."
exit
}
echo "Debug Info"

#echo $SUDO_USER

echo "Running Installer"
if [ -z $1 ]
then
HDIR="/home/pi"
USERID="pi"
GROUPID="pi"
RDIR="/opt"
RUSERID="root"
RGROUPID="root"
else
HDIR=/home/$1
USERID=`id -n -u $1`
GROUPID=`id -n -g $1`
fi

#Confirm if install should continue with default PI user or inform about commandline option.
echo ""
echo "Install Details:"
echo "Home Directory: "$HDIR
echo "User: "$USERID
echo "Group: "$USERID
echo ""
if [ ! -d "$HDIR" ]; then
    echo ""; echo "The home directory does not exist!";f_exit;
fi
#echo "Is the above Home directory and User/Group correct (1/2)?"
#select yn in "Continue" "Cancel"; do
#    case $yn in
#        Continue ) break;;
#        Cancel ) f_exit;;
#    esac
#done

echo "Please wait a few seconds"
pkill -f servod
sleep 1

echo "Thank you"
rm -rf $RDIR/szero${SGHVER}

mkdir -p $RDIR/szero${SGHVER}
mkdir -p $RDIR/szero${SGHVER}/mcpi


cp szero.py $RDIR/szero${SGHVER}
cp Adafruit_I2C.py $RDIR/szero${SGHVER}
cp sgh_servod $RDIR/szero${SGHVER}
cp killsgh.sh $RDIR/szero${SGHVER}
cp nunchuck.py $RDIR/szero${SGHVER}
cp meArm.py $RDIR/szero${SGHVER}
cp kinematics.py $RDIR/szero${SGHVER}
cp sgh_*.py $RDIR/szero${SGHVER}

cp ./mcpi/* $RDIR/szero${SGHVER}/mcpi

chmod +x sgh_servod
chmod +x killsgh.sh


#Instead of copying the szeroX.sh file, we will generate it
#Create a new file for szeroX.sh
echo "#!/bin/bash" > $RDIR/szero${SGHVER}/szero${SGHVER}.sh
echo "#Version 0.2 - add in & to allow simultaneous running of handler and Scratch" >> $RDIR/szero${SGHVER}/szero${SGHVER}.sh
echo "#Version 0.3 - change sp launches rsc.sb from \"/home/pi/Documents/Scratch Projects\"" >>$RDIR/szero${SGHVER}/szero${SGHVER}.sh
echo "#Version 0.4 - 20Mar13 meltwater - change to use provided name for home" >> $RDIR/szero${SGHVER}/szero${SGHVER}.sh
echo "#Version 1.0 - 29Oct13 sw - change to cd into simplesi_scratch_handler to run servods OK" >> $RDIR/szero${SGHVER}/szero${SGHVER}.sh
echo "sudo pkill -f szero.py" >> $RDIR/szero${SGHVER}/szero${SGHVER}.sh
echo "cd $RDIR/szero"$SGHVER >> $RDIR/szero${SGHVER}/szero${SGHVER}.sh
echo "sudo python szero.py &" >> $RDIR/szero${SGHVER}/szero${SGHVER}.sh
echo "scratch --document \"$HDIR/Documents/Scratch Projects/rsc.sb\" &" >> $RDIR/szero${SGHVER}/szero${SGHVER}.sh

chmod +x $RDIR/szero${SGHVER}/szero${SGHVER}.sh

#Create new desktop icon
echo "[Desktop Entry]" > $HDIR/Desktop/szero${SGHVER}.desktop
echo "Encoding=UTF-8" >> $HDIR/Desktop/szero${SGHVER}.desktop
echo "Version=1.0" >> $HDIR/Desktop/szero${SGHVER}.desktop
echo "Type=Application" >> $HDIR/Desktop/szero${SGHVER}.desktop
echo "Exec="$RDIR"/szero"$SGHVER"/szero"$SGHVER".sh" >> $HDIR/Desktop/szero${SGHVER}.desktop
echo "Icon=scratch" >> $HDIR/Desktop/szero${SGHVER}.desktop
echo "Terminal=false" >> $HDIR/Desktop/szero${SGHVER}.desktop
echo "Name=SZero "$SGHVER >> $HDIR/Desktop/szero${SGHVER}.desktop
echo "Comment= Programming system and content development tool" >> $HDIR/Desktop/szero${SGHVER}.desktop
echo "Categories=Application;Education;Development;" >> $HDIR/Desktop/szero${SGHVER}.desktop
echo "MimeType=application/x-scratch-project" >> $HDIR/Desktop/szero${SGHVER}.desktop

chown -R $USERID:$GROUPID $HDIR/Desktop/szero${SGHVER}.desktop

#mkdir -p $HDIR/Desktop/szero\ Extras
#chown -R $USERID:$GROUPID $HDIR/Desktop/szero\ Extras


# #Create a new file for oldszeroX.sh
# echo "#!/bin/bash" > $RDIR/szero${SGHVER}/oldszero${SGHVER}.sh
# echo "#Version 0.2 - add in & to allow simultaneous running of handler and Scratch" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}.sh
# echo "#Version 0.3 - change sp launches rsc.sb from \"/home/pi/Documents/Scratch Projects\"" >>$RDIR/szero${SGHVER}/oldszero${SGHVER}.sh
# echo "#Version 0.4 - 20Mar13 meltwater - change to use provided name for home" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}.sh
# echo "#Version 1.0 - 29Oct13 sw - change to cd into simplesi_scratch_handler to run servods OK" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}.sh
# echo "sudo pkill -f szero_handler" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}.sh
# echo "cd $RDIR/szero"$SGHVER >> $RDIR/szero${SGHVER}/oldszero${SGHVER}.sh
# echo "sudo python szero_handler7.py 127.0.0.1 standard &" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}.sh
# echo "scratch.old --document \"$HDIR/Documents/Scratch Projects/rsc.sb\" &" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}.sh

# chmod +x $RDIR/szero${SGHVER}/oldszero${SGHVER}.sh

# #Create new desktop icon for oldscratch version
# echo "[Desktop Entry]" > $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}.desktop
# echo "Encoding=UTF-8" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}.desktop
# echo "Version=1.0" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}.desktop
# echo "Type=Application" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}.desktop
# echo "Exec="$RDIR"/szero"$SGHVER"/oldszero"$SGHVER".sh" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}.desktop
# echo "Icon=scratch" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}.desktop
# echo "Terminal=false" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}.desktop
# echo "Name=OrigScratch szero "$SGHVER >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}.desktop
# echo "Comment= Programming system and content development tool" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}.desktop
# echo "Categories=Application;Education;Development;" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}.desktop
# echo "MimeType=application/x-scratch-project" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}.desktop

# chown -R $USERID:$GROUPID  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}.desktop



# #Create a new file for old szeroXplus.sh
# echo "#!/bin/bash" > $RDIR/szero${SGHVER}/oldszero${SGHVER}plus.sh
# echo "#Version 0.2 - add in & to allow simulatenous running of handler and Scratch" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}plus.sh
# echo "#Version 0.3 - change sp launches rsc.sb from \"/home/pi/Documents/Scratch Projects\"" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}plus.sh
# echo "#Version 0.4 - 20Mar13 meltwater - change to use provided name for home" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}plus.sh
# echo "#Version 1.0 - 29Oct13 sw - change to cd into simplesi_scratch_handler to run servods OK" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}plus.sh
# echo "sudo pkill -f szero_handler" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}plus.sh
# echo "cd $RDIR/szero"$SGHVER >> $RDIR/szero${SGHVER}/oldszero${SGHVER}plus.sh
# echo "sudo python szero_handler7.py &" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}plus.sh
# echo "scratch.old --document \"$HDIR/Documents/Scratch Projects/rsc.sb\" &" >> $RDIR/szero${SGHVER}/oldszero${SGHVER}plus.sh

# chmod +x $RDIR/szero${SGHVER}/oldszero${SGHVER}plus.sh

# #Create new desktop icon for plus version
# echo "[Desktop Entry]" > $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}plus.desktop
# echo "Encoding=UTF-8" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}plus.desktop
# echo "Version=1.0" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}plus.desktop
# echo "Type=Application" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}plus.desktop
# echo "Exec="$RDIR"/szero"$SGHVER"/oldszero"$SGHVER"plus.sh" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}plus.desktop
# echo "Icon=scratch" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}plus.desktop
# echo "Terminal=false" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}plus.desktop
# echo "Name=OrigScratch szero "$SGHVER"plus" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}plus.desktop
# echo "Comment= Programming system and content development tool" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}plus.desktop
# echo "Categories=Application;Education;Development;" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}plus.desktop
# echo "MimeType=application/x-scratch-project" >>  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}plus.desktop

# chown -R $USERID:$GROUPID  $HDIR/Desktop/szero\ Extras/oldszero${SGHVER}plus.desktop

#cp blink11.py $HDIR

#mkdir -p $HDIR/Documents
#chown -R $USERID:$GROUPID $HDIR/Documents

#mkdir -p $HDIR/Documents/Scratch\ Projects
#chown -R $USERID:$GROUPID $HDIR/Documents/Scratch\ Projects

cp rsc.sb $HDIR/Documents/Scratch\ Projects
#cp GPIOexample.sb $HDIR/Documents/Scratch\ Projects
#cp blink11.sb $HDIR/Documents/Scratch\ Projects
chown -R $USERID:$GROUPID $HDIR/Documents/Scratch\ Projects
echo ""
echo "Finished."
