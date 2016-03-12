#!/bin/bash
#copy files to payload folder
SGHVER=$1
echo $SGHVER
echo $HOME
echo $SGHVER > $HOME/sghdev/szero/installer/payload/SGHVER.txt

cp $HOME/sghdev/szero/szero.py $HOME/sghdev/szero/installer/payload
cp $HOME/sghdev/szero/Adafruit_I2C.py $HOME/sghdev/szero/installer/payload
cp $HOME/sghdev/szero/sgh_servod $HOME/sghdev/szero/installer/payload
cp $HOME/sghdev/szero/killsgh.sh $HOME/sghdev/szero/installer/payload
cp $HOME/sghdev/szero/nunchuck.py $HOME/sghdev/szero/installer/payload
cp $HOME/sghdev/szero/meArm.py $HOME/sghdev/szero/installer/payload
cp $HOME/sghdev/szero/kinematics.py $HOME/sghdev/szero/installer/payload


cp $HOME/sghdev/szero/sgh_*.py $HOME/sghdev/szero/installer/payload

rm -rf $HOME/sghdev/szero/installer/payload/mcpi
mkdir -p $HOME/sghdev/szero/installer/payload/mcpi
cp $HOME/sghdev/szero/mcpi/* $HOME/sghdev/szero/installer/payload/mcpi

cd $HOME/sghdev/szero/installer/payload
tar -cf ../payload.tar ./* #tar all the payload files
cd ..

if [ -e "payload.tar" ]; then
    gzip -f payload.tar #gzip the payload files

    if [ -e "payload.tar.gz" ]; then
        cat decompress.sh payload.tar.gz > install_szero${SGHVER}.sh # bolt on decompress script
    else
        echo "payload.tar.gz does not exist"
        exit 1
    fi
else
    echo "payload.tar does not exist"
    exit 1
fi
chmod +x install_szero${SGHVER}.sh #make install script executeable
echo "install_szero"$SGHVER".sh created"
cp install_szero${SGHVER}.sh $HOME/sghdev/szero #copy installer to main folder
cd $HOME/sghdev/szero

exit 0
