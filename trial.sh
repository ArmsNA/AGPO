#!/bin/bash

echo "Hello, $(whoami). Welcome to Armsna's Automated Group Policy Object Program."

LGPOLoc="/mnt/c/Program Files/LGPO/LGPO_30" 
LGPOLocM="C:\Program Files\LGPO\LGPO_30"
LGPODl="/mnt/c/Users/$(whoami)/Downloads/LGPO.zip"
LGPODest="/mnt/c/Program Files/LGPO"
LGPODestM="C:\Program Files\LGPO"
LGPODlUri=https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip

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
        curl -o $LGPODl $LGPODlUri 
		echo "Unzipping lgpo.zip..."

        #MAY need to excute the following command to ensure rwe
        #sudo chmod 711 "$LGPODest"

		unzip "$LGPODl" -d "$LGPODest"

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

echo "Creating a backup directory if none is found..."

cd "$LGPOLoc"

# == and -ef work here
if [[ $(pwd) == "$LGPOLoc" ]]; then
	if [ -d "$LGPOLoc/Backup" ]; then
        LGPOBack="$LGPOLoc/Backup"
        LGPOBackM="C:\Program Files\LGPO\LGPO_30\Backup"
		echo "Backup directory found. Storing GPO information in $LGPOBack."

        echo -n "Would you like to overwrite the previous backup? Y/N: "
        for ((i=1; i>0; i++)); do
            read answer
            if [[ $answer = "y" ]] || [[ $answer = "Y" ]]; then
             rm -r "$LGPOBack"
             ./LGPO.exe /b "$LGPOLocM" /n "Backup"
             LGPOBack="$LGPOLoc/Backup"
             LGPOBackM="C:\Program Files\LGPO\LGPO_30\Backup"
             latest=$(ls -td -- */ | head -n 1)
             mv "$LGPOLoc/$latest" "$LGPOBack"
  	         echo "Backup directory overwritten. Storing GPO information in $LGPOBack."
  	         ((i=-1))
            elif [[ $answer = "n" ]] || [[ $answer = "N" ]]; then
  	         echo "OK."
             ((i=-1))
            else
  	         echo "Invalid response. Please specify answer with Y/N: "; fi
        done
	else
		#mkdir Backup
        ./LGPO.exe /b "$LGPOLocM" /n "Backup"
        LGPOBack="$LGPOLoc/Backup"
        LGPOBackM="C:\Program Files\LGPO\LGPO_30\Backup"
        #Sorts directories by latest mod time and returns 1st on list stored in latest var
        latest=$(ls -td -- */ | head -n 1)
        mv "$LGPOLoc/$latest" "$LGPOBack"

		echo "Backup directory created. Storing GPO information in $LGPOBack."
    fi
fi

mRegLoc="$LGPOBackM\DomainSysvol\GPO\Machine\registry.pol"
uRegLoc="$LGPOBackM\DomainSysvol\GPO\User\registry.pol"
echo "Please select options from the list below. Press 11 to quit."
options='ParseMachineRegistryFile ParseUserRegistryFile ParseAllRegistryFiles ApplyExistingGPOsToMachineSettings ApplyExistingGPOsToUserSettings ApplyExistingGPOsToAllSettings ApplyMeetComplianceSettings ApplyBackupMachineSettings ApplyBackupUserSettings ApplyBackupToAllSettings Quit'
select option in $options
do
    if [[ $option == 'ParseMachineRegistryFile' ]]; then
        ./LGPO.exe /parse /m "$mRegLoc" > lgpoMachine.txt
    fi
    if [[ $option == 'ParseUserRegistryFile' ]]; then
        ./LGPO.exe /parse /u "$uRegLoc" > lgpoUser.txt
    fi
    if [[ $option == 'ParseAllRegistryFiles' ]]; then
        ./LGPO.exe /parse /m "$mRegLoc" > lgpoMachine.txt
        ./LGPO.exe /parse /u "$uRegLoc" > lgpoUser.txt
    fi
    if [[ $option == 'ApplyExistingGPOsToMachineSettings' ]]; then
        echo -n "Provide a path to existing GPO Machine registry commands (.txt format, C:\...): "
        read answer
        ./LGPO.exe /t "$answer"
    fi
    if [[ $option == 'ApplyExistingGPOsToUserSettings' ]]; then
        echo -n "Provide a path to existing GPO User registry commands (.txt format, C:\...): "
        read answer
        ./LGPO.exe /t "$answer"
    fi
    if [[ $option == 'ApplyExistingGPOsToAllSettings' ]]; then
        echo -n "Provide a path to existing GPO Machine registry commands (.txt format, C:\...): "
        echo -n "Provide a path to existing GPO User registry commands (.txt format, C:\...): "
        read answer
        read answerTwo
        ./LGPO.exe /t "$answer"
        ./LGPO.exe /t "$answerTwo"
    fi
    if [[ $option == 'ApplyMeetComplianceSettings' ]]; then
        #echo "Compliance Settings Applied"
        echo "WIP..."
        #Ideally create a backup with all correct compliance settings, save for reference, revert to previous settings, and apply when called for.
    fi
    if [[ $option == 'ApplyBackupMachineSettings' ]]; then
        ./LGPO.exe /m "$mRegLoc"
    fi
    if [[ $option == 'ApplyBackupUserSettings' ]]; then
        ./LGPO.exe /u "$uRegLoc"
    fi
    if [[ $option == 'ApplyBackupToAllSettings' ]]; then
        ./LGPO.exe /m "$mRegLoc"
        ./LGPO.exe /u "$uRegLoc"
    fi 
    if [[ $option == 'Quit' ]]; then
        break
    fi
done