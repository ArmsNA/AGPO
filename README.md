# AGPO
Automated Group Policy Compliance Program for Linux or devices running Windows Subsystem for Linux.

ATTN: **Must run Terminal as system administrator.**

*AGPOv2 is out, I plan on updating this one but AGPOv2 and it's corresponding functionality with LGPO works much better (Powershell)*
i.e. apply settings from .pol AND .txt files... current iteration only allows setting application from registery command .txt file.

Depending on where this script is saved to, you may want to path out to the following paths in order to run the script...
/mnt/c/Users/$(whoami)/Desktop
/mnt/c/Users/$(whoami)/Downloads

Overview: Users can utilize the Windows Subsystem for Linux to edit, remove, and create Windows Group Policy Objects (GPOs) with this program. This program utilizes the LGPO utility from Microsoft. This program can be used to meet compliance regulations in editting Windows Security Settings and other relevant regulation standard settings dealing with GPOs. This program was created with CMMC 2.0 regulation in mind. 

I will be looking to publish a version compatible with Windows Command Prompt.
I will also be looking to publish a version that will allow GPO editting at a domain-level.
