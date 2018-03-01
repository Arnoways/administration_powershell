## in order to create password file, run: read-host -assecurestring | convertfrom-securestring | out-file C:\Path\to_the_file\containingpassword.txt                    
#Note: for gmail users, you have to change some security settings into your account

$username = "username"
$password = cat C:\Path\to_the_file\containingpassword.txt | ConvertTo-SecureString
$cred = new-object -typename System.Management.Automation.PSCredential -ArgumentList $username, $password
$from = "sender email address"
$to = "recipient email address"
$subject = "Whatever you want"
$Body = "Body of the email the script will send"
$smtpserver = "smtp server"

Send-MailMessage -from $from -to $to -subject $subject -body $Body -SmtpServer $smtpserver -Port 587 -UseSsl -Credential $cred 
