#新規ユーザの環境を整える
Param(
$EventRecordId,
$TargetUserName,
$TargetDomainName,
$ServerName
)
$DefaultGroupName = "FTE"
$HomeDirectory = "\\FileServer\Home" + $TargetUserName

Add-ADGroupMember -Identify $DefaultGroupName \
-Members $TargetUserName \
-Server $ServerName

Set-ADUser -Identify $TargetUserName \
-HomeDrive "H:" \
-HomeDirectory $HomeDirectory

$NewUser = $TargetDomainName + "\" + $TargetUserName
$logMessage = $NewUser + "　が新規に作成されました。"
$logMessage = $logMessage + " (EventID=" + $EventRecordId + ") "
$logMessage | Out-File C:\tmp\truck4720.log -Append
