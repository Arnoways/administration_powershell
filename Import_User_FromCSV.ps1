Import-Module ActiveDirectory 

#displaying window to fetch csv file
Function Select-FolderDialog
{
    param([string]$Description="Select Folder",[string]$RootFolder="Desktop")

 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null     

   $objForm = New-Object System.Windows.Forms.OpenFileDialog
        $objForm.InitialDirectory = $RootFolder
        #filters files to find csv ones only
        $objForm.filter = "CSV (*.csv)| *.csv"
        $objForm.ShowDialog() | Out-Null
        $objForm.FileName
}

$file = Select-FolderDialog # the variable contains user folder selection



$Users = Import-Csv -Delimiter ";" -Path $file -Encoding UTF8
$OU = ""  #OU Path. (OU=Users,DC=domain,DC=local)



foreach ($User in $Users)  
{  
    $SAMAccountName=$User.SAMAccountName
    $Surname=$User.Surname
    $GivenName=$User.GivenName
    $email=$User.emailaddress
    $script=$SAMAccountName+".bat"
    $Name=$GivenName + " " + $Surname.ToUpper()
    $upn=($SAMAccountName + "@" + $env:USERDNSDOMAIN).ToLower()
    [array]$groups=$User.groupe -split ","
    $pass=$User.password 
    New-ADUser -AccountExpirationDate $null -Enabled $true -EmailAddress $email -Name $Name -UserPrincipalName $upn -SamAccountName $SAMAccountName -ScriptPath $script -GivenName $GivenName -Surname $Surname -Path $OU -ChangePasswordAtLogon $true
    foreach ($group in $groups)
    {
    Add-ADGroupMember -Identity $group -Member $SAMAccountName
    }
} 
Write-Host "User import done" -ForegroundColor Yellow
