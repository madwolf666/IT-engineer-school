#メールを送信
Param(
[string]$SMTPServer = "smtp.gmail.com",
[int]$SMTPPort = 587,
[string]$From = "madwolf699@gmail.com",
[string]$Password = "chappy666",
[string]$To = "madwolf666@live.jp",
[string]$Cc = "",
[string]$Subject = "Test",
[string]$Body = "<b>This is test mail.</b>",
[string]$Attachment = ""
)
$Credential = New-Object System.Management.Automation.PSCredential(
$From,
(ConvertTo-SecureString $Password -AsPlainText -Force)
)

$SMTPServer
$SMTPPort
$From
$Password
$To
$Cc
$Subject
$Body

try {
    Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -Credential $Credential -UseSsl -Encoding UTF8;
    #Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Port $SMTPPort -Credential $Credential -UseSsl -Encoding UTF8
    #Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -Credential $Credential -UseSsl -Encoding UTF8;
    # -Cc $Cc
    #-Attachments $Attachment
}Catch{
    Write-Warning "Error"
    $Error[0]
}
