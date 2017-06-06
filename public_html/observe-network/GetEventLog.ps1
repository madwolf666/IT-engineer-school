#イベントを取得してメール送信
Function SendMail($Subject, $Body){
    $SMTPServer = "smtp.gmail.com"
    $SMTPPort = 587
    $From = "madwolf699@gmail.com"
    $Password = "chappy666"
    $To = "madwolf666@live.jp"

    $Credential = New-Object System.Management.Automation.PSCredential(
    $From,
    (ConvertTo-SecureString $Password -AsPlainText -Force)
    )

    Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Port $SMTPPort -Credential $Credential -UseSsl -Encoding UTF8;
}

Write-Host "End to [Ctrl + C]"

$EventLog = "EventLogSink"
Register-WmiEvent -Query "SELECT * FROM __InstanceCreationEvent WHERE TargetInstance ISA 'Win32_NTLogEvent'" -SourceIdentifier $EventLog

try{
    While ($True) {
        $NewEvent = Wait-Event -SourceIdentifier $EventLog
        $Log = $NewEvent.SourceEventArgs.NewEvent.TargetInstance
        $LogName = $Log.LogFile; $SourceName = $Log.SourceName
        $EventCode = $Log.EventCode; $TimeGenerated = $Log.TimeGenerated
        $Year = $TimeGenerated.SubString(0, 4); $Month = $TimeGenerated.SubString(4, 2)
        $Day = $TimeGenerated.SubString(6, 2); $Hour = $TimeGenerated.SubString(8, 2)
        $Minutes = $TimeGenerated.SubString(10, 2)
        $Date = $Year + "/" + $Month + "/" + $Day + " " + $Hour + ":" + $Minutes
        $Date = (([DateTime]$Date)).AddHours(9).ToString("yyyy/MM/dd HH:mm:ss")
        $Message = $Log.Message

        $Body = `
@"
ソース:$SourceName
イベントID:$EventCode
日時:$Date
メッセージ:$Message
"@
        SendMail($LogName + "イベントログ") $Body
        Write-Output $Body
        Remove-Event $EventLog
    }
}Catch{
    Write-Warning "Error"
    $Error[0]
}Finally{
    Get-Event | Remove-Event
    Get-EventSubscriber | Unregister-Event
}
