#プロセスの開始と終了を監視
Write-Host "End to [Ctrl + C]"

$ProcessStart = "ProcessStartSink"
$ProcessEnd = "ProcessEndSink"
Register-WmiEvent -Class Win32_ProcessStartTrace -SourceIdentifier $ProcessStart
Register-WmiEvent -Class Win32_ProcessStopTrace -SourceIdentifier $ProcessEnd

try{
    While ($True) {
        $NewEvent = Wait-Event
        $ProcessName = $NewEvent.SourceEventArgs.NewEvent.ProcessName
        $Time = $NewEvent.TimeGenerated.DateTime
$NewEvent
$ProcessName
$Time
$NewEvent.SourceIdentifier;

        Switch($NewEvent.SourceIdentifier){
            $ProcessStart{
                ([DateTime]$Time).ToString("HH:mm:ss") + " " + $ProcessName + " Start" | Out-File (".\ProcessLog_" + (Get-Date -Format "yyyyMMdd") + ".txt") -Encoding UTF8 -Append;
                Break
            }
            $ProcessEnd{
                ([DateTime]$Time).ToString("HH:mm:ss") + " " + $ProcessName + " End" | Out-File (".\ProcessLog_" + (Get-Date -Format "yyyyMMdd") + ".txt") -Encoding UTF8 -Append;
                Break
            }
        }
        Get-Event | Remove-Event
    }
}Catch{
    Write-Warning "Error"
    $Error[0]
}Finally{
    Get-Event | Remove-Event
    Get-EventSubscriber | Unregister-Event
}
