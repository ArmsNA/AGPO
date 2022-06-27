# AGPO
Automated Group Policy Compliance Program for Linux or devices running Windows Subsystem for Linux.

ATTN: **Must run Terminal as system administrator.**

Lines 24, 28, 42, 58, 70, 85, 86, 89, 90, 93-96, 99, 102, 105, and 106 will require path reconfiguration local to your machine. Instantiating a path to where the LGPO utility is stored and utilizing that path throughout the program will save some trouble. 

Depending on where this script is saved to, you may want to path out to the following paths in order to run the script...
/mnt/c/Users/$user/Desktop
/mnt/c/Users/$user/Downloads
...where $user is to be replaced with your user name

Overview: Users can utilize the Windows Subsystem for Linux to edit, remove, and create Windows Group Policy Objects (GPOs) with this program. This program utilizes the LGPO utility from Microsoft. This program can be used to meet compliance regulations in editting Windows Security Settings and other relevant regulation standard settings dealing with GPOs. This program was created with CMMC 2.0 regulation in mind. 

I will be looking to publish a version compatible with Windows Command Prompt.
