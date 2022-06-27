#!/bin/bash

user=$(whoami)

echo "Hello, $user. Welcome to ArmsNA's Automated Group Policy Object Program."

if ! command unzip -v &> /dev/null; then
	echo "Unzip not found... installing now."
	apt install unzip
fi

echo -n "Do you have the LGPO utility installed? Y/N: "
for ((i=1; i>0; i++)); do
  read answer
  if [[ $answer = "y" ]] || [[ $answer = "Y" ]]; then
  	echo "Great, thank you for confirming."
  	((i=-1))
  elif [[ $answer = "n" ]] || [[ $answer = "N" ]]; then
  	echo -n "Would you like to install it now? Y/N: "
  	for ((j=1; j>0; j++)); do
  	  read answer
      if [[ $answer = "y" ]] || [[ $answer = "Y" ]]; then
  	    echo "Installing now..."
        wget https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip -P ~/Downloads/LGPO.zip
				echo "Unzipping lgpo.zip..."
                #Can be swapped to /Documents

				unzip ~/Downloads/LGPO.zip -d /mnt/c/Users/$user/Desktop
  	    ((j=-1))
  	    ((i=-1))
      elif [[ $answer = "n" ]] || [[ $answer = "N" ]]; then
  	    echo "OK."
  	    ((j=-1))
  	    ((i=-1))
      else
  	    echo -n "Invalid response. Please specify answer with Y/N: "; fi
    done
  else
  	echo -n "Invalid response. Please specify answer with Y/N: "; fi
done

path=/mnt/c/Users/Rabbithole/Desktop/LGPO_30

echo "Creating a backup directory if none is found..."

cd $path

# == and -ef work here
if [[ $(pwd) == $path ]]; then
	if [ -d "$path/Backup" ]; then
		echo "Backup directory found. Storing GPO information in $path/Backup."

        echo -n "Would you like to overwrite the previous backup? Y/N: "
        for ((i=1; i>0; i++)); do
            read answer
            if [[ $answer = "y" ]] || [[ $answer = "Y" ]]; then
             rm -r $path/Backup
             ./LGPO.exe /b "C:\Users\Rabbithole\Desktop\LGPO_30" /n "Backup"
             latest=$(ls -td -- */ | head -n 1)
             mv $path/$latest $path/Backup
  	         echo "Backup directory overwritten. Storing GPO information in $path/Backup."
  	         ((i=-1))
            elif [[ $answer = "n" ]] || [[ $answer = "N" ]]; then
  	         echo "OK."
             ((i=-1))
            else
  	         echo "Invalid response. Please specify answer with Y/N: "; fi
        done
	else
        ./LGPO.exe /b "C:\Users\Rabbithole\Desktop\LGPO_30" /n "Backup"

        #Sorts directories by latest mod time and returns 1st on list stored in latest var
        latest=$(ls -td -- */ | head -n 1)
        mv $path/$latest $path/Backup

		echo "Backup directory created. Storing GPO information in $path/Backup."
    fi
fi

echo "Please select options from the list below. Press 11 to quit."
options='ParseMachineRegistryFileANDApplySettings ParseUserRegistryFileANDApplySettings ParseAllRegistryFilesANDApplySettings ApplyBlankGPOsToMachineSettings ApplyBlankGPOsToUserSettings ApplyBlankGPOsToAllSettings ApplyExistingGPOsToMachineSettings ApplyExistingGPOsToUserSettings ApplyExistingGPOsToAllSettings ApplyMeetComplianceSettings Quit'
select option in $options
do
    if [[ $option == 'ParseMachineRegistryFileANDApplySettings' ]]; then
        ./LGPO.exe /parse /m "C:\Users\Rabbithole\Desktop\LGPO_30\Backup\DomainSysvol\GPO\Machine\registry.pol" > lgpoMachine.txt
        ./LGPO.exe /t "C:\Users\Rabbithole\Desktop\LGPO_30\lgpoMachine.txt"
    fi
    if [[ $option == 'ParseUserRegistryFileANDApplySettings' ]]; then
        ./LGPO.exe /parse /u "C:\Users\Rabbithole\Desktop\LGPO_30\Backup\DomainSysvol\GPO\User\registry.pol" > lgpoUser.txt
        ./LGPO.exe /u "C:\Users\Rabbithole\Desktop\LGPO_30\lgpoUser.txt"
    fi
    if [[ $option == 'ParseAllRegistryFilesANDApplySettings' ]]; then
        ./LGPO.exe /parse /m "C:\Users\Rabbithole\Desktop\LGPO_30\Backup\DomainSysvol\GPO\Machine\registry.pol" > lgpoMachine.txt
        ./LGPO.exe /parse /u "C:\Users\Rabbithole\Desktop\LGPO_30\Backup\DomainSysvol\GPO\User\registry.pol" > lgpoUser.txt
        ./LGPO.exe /t "C:\Users\Rabbithole\Desktop\LGPO_30\lgpoMachine.txt"
        ./LGPO.exe /u "C:\Users\Rabbithole\Desktop\LGPO_30\lgpoUser.txt"
    fi
    if [[ $option == 'ApplyBlankGPOsToMachineSettings' ]]; then
        ./LGPO.exe /t "C:\Users\Rabbithole\Desktop\LGPO_30\blankMachineGPO.txt"
    fi
    if [[ $option == 'ApplyBlankGPOsToUserSettings' ]]; then
        ./LGPO.exe /u "C:\Users\Rabbithole\Desktop\LGPO_30\blankUserGPO.txt"
    fi
    if [[ $option == 'ApplyBlankGPOsToAllSettings' ]]; then
        ./LGPO.exe /t "C:\Users\Rabbithole\Desktop\LGPO_30\blankMachineGPO.txt"
        ./LGPO.exe /u "C:\Users\Rabbithole\Desktop\LGPO_30\blankUserGPO.txt"
    fi
    if [[ $option == 'ApplyExistingGPOsToMachineSettings' ]]; then
        echo -n "Provide a path to existing GPO Machine Settings: "
        read answer
        ./LGPO.exe /t "$answer"
    fi
    if [[ $option == 'ApplyExistingGPOsToUserSettings' ]]; then
        echo -n "Provide a path to existing GPO User Settings: "
        read answer
        ./LGPO.exe /u "$answer"
    fi
    if [[ $option == 'ApplyExistingGPOsToAllSettings' ]]; then
        echo -n "Provide a path to existing GPO Machine Settings: "
        echo -n "Provide a path to existing GPO User Settings: "
        read answer
        read answerTwo
        ./LGPO.exe /t "$answer"
        ./LGPO.exe /u "$answerTwo"
    fi
    if [[ $option == 'ApplyMeetComplianceSettings' ]]; then
        echo "Compliance Settings Applied"
        #Ideally create a backup with all correct compliance settings, save for reference, revert to previous settings, and apply when called for.
    fi
    if [[ $option == 'Quit' ]]; then
        break
    fi
done
