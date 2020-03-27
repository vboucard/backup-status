# Author: Vladimir Eremin
# Created Date: 3/24/2015
# http://forums.veeam.com/member31097.html
# 
##################################################################
#                   User Defined Variables
##################################################################

# Names of VMs to backup separated by semicolon (Mandatory)
$VMNames = "SVR-AV"

# Retention settings (Optional; By default, VeeamZIP files are not removed and kept in the specified location for an indefinite period of time. 
# Possible values: Never , Tonight, TomorrowNight, In3days, In1Week, In2Weeks, In1Month)
$Retention = "In1Month"

##################################################################
#                   Notification Settings
##################################################################

# Enable notification (Optional)
$EnableNotification = $False

# Email subject
$EmailSubject = "Sauvegardes Quotidiennes " + $VMNames + " 19h00"

. "$PSScriptRoot\GlobalSettings.ps1"