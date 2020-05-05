#!/bin/bash
#Created by Kyle Ericson
#Version 5.0
#For new and Existing OneDrive setups

#Get the current user
currentUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

#currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )


#OneDrive Location
oneDriveDirectory="/Users/$currentUser/OneDrive - Replacewithyourcompanyname"

#Remove OneDrive
sudo killall OneDrive


if [[ ! -d $oneDriveDirectory ]]
then
    echo "Folder not found. You need to setup OneDrive first, then run again"
    exit 1
fi

echo "OneDrive Setup Script Starting" 
cd "$oneDriveDirectory/"
    
echo "Renaming folders in existing OneDrive to name -old"
mv Desktop Desktop-old
mv Documents Documents-old 

              
echo "Move User home folders"
for dir_to_link1 in Desktop Documents 
do
sudo mv -f "/Users/$currentUser/$dir_to_link1" "$oneDriveDirectory" 
done
	    
echo "Create the symbolic links"
for dir_to_link2 in Desktop Documents 
do
sudo ln -s "$oneDriveDirectory/$dir_to_link2" "/Users/$currentUser/$dir_to_link2"
done
		
echo "Copy old OneDrive content to OneDrive"
sudo Ditto "$oneDriveDirectory/Desktop-old" "$oneDriveDirectory/Desktop" 
sudo Ditto "$oneDriveDirectory/Documents-old" "$oneDriveDirectory/Documents"  
 
		
echo "Remove old folders"
for dir_to_link5 in Desktop-old Documents-old Movies-old Pictures-old Music-old
do
sudo rm -rf "$oneDriveDirectory/$dir_to_link5" 
done

echo "OneDrive Setup Script has finished"

sudo -u $(ls -l /dev/console | awk '{print $3}') open /Applications/OneDrive.app

loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`
sudo -u $loggedInUser open -a OneDrive.app 
exit 0    