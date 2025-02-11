#!/bin/sh

set -e
cd `dirname $0`

#install usb.id
#remove old entry
if [ -f "/usr/share/hwdata/usb.ids" ] ; then
	FILE=/usr/share/hwdata/usb.ids
elif [ -f "/usr/share/usb.ids" ] ; then
	FILE=/usr/share/usb.ids
elif [ -f "/usr/share/misc/usb.ids" ] ; then
	FILE=/usr/share/misc/usb.ids
fi

if [ -f "$FILE" ] ; then
	echo ""
	echo "Checking if $FILE must be updated"
	LINE_START=`grep -n -m 1 BASLER_START $FILE | cut -d: -f1`
	LINE_END=`grep -n -m 1 BASLER_END $FILE | cut -d: -f1`

	if [ -n "$LINE_START" -a -n "$LINE_END" ] && [ "$LINE_START" -lt "$LINE_END" ] ; then
		echo "Remove old Basler device entries from $FILE"
		cp $FILE usb.ids.old
		$SUDO sed -i -e "$LINE_START,$LINE_END d" $FILE
	fi
	
	#test if there are already basler entries in the file
	FOUND=`grep -e '^2676' $FILE || true`

	if [ -n "$FOUND" ] ; then
		echo "Your usb hardware database is up to date. Nothing to do."
	else
		echo "Add Basler device entries to $FILE"

		#Append the data into usb.ids

		$SUDO sh -c "echo \"###BASLER_START ###################################################
# These lines were automatically added by the pylon installer.
# Please leave the BASLER_... markers in place as the lines between 
# them will be overwritten on the next install.
2676  Basler AG
	ba02  ace USB3 Vision Camera
	ba03  dart USB3 Vision Camera
	ba04  pulse USB3 Vision Camera
	ba05  USB3 Vision Camera
	ba06  USB3 Vision Camera
	ba07  USB3 Vision Camera
	ba08  USB3 Vision Camera
	ba09  USB3 Vision Camera
	ba0a  USB3 Vision Camera
	ba0b  USB3 Vision Camera
	ba0c  USB3 Vision Camera
	ba0d  USB3 Vision Camera
	ba0e  USB3 Vision Camera
	ba0f  USB3 Vision Camera
###BASLER_END #####################################################\" >> $FILE"
	fi

else
	echo ""
	echo "Couldn't locate the usb-ids database. This is no big problem, you will only miss descriptions for Basler devices when calling lsusb."
fi

echo ""
echo "Installation successful"
echo ""
