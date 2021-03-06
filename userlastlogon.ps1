##This script lists and orders Active Directory Users by their last logon date.
##Usage: ./userlastlogon.ps1 -userName 'username' ; if you want to list all users, just run the script without parameters.
param([string]$userName="*")

Import-Module ActiveDirectory 

function UserLastlogon()
{
$list=@{}
if ($userName -eq "*")
    {
     $user = Get-AdUser -Filter * | Get-ADObject -Properties lastLogon
    }
else
    {
     $user = Get-AdUser $userName | Get-ADObject -Properties lastLogon
    }

foreach ($u in $user)
    {
        $name = $u.Name
        #converts the lastLogon property to a human readable string
        $time = [DateTime]::FromFileTime($u.lastLogon).ToString('yyyy/MM/dd')
        $list."$name" = $time
    }
#orders the values by date and changes the columns headers with 'Name' and 'Last logon date' 
$list.GetEnumerator() | Sort-Object Value | Select-Object @{Label='Name';Expression={$_.Key}},@{Label='Last Logon Date';Expression={$_.Value}}

}
UserLastlogon 