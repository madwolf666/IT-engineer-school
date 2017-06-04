#プロセスの開始と終了を監視
Write-Host "End to [Ctrl + C]"

$ProcessStart = "ProcessStartSink"
$ProcessEnd = "ProcessEndSink"
Register-WmiEvent -Class Win32_ProcessStartTrace -SourceIdentifier $ProseccStart
Register-WmiEvent -Class Win32_ProcessStopTrace -SourceIdentifier $ProcessEnd

try{
    While ($True) {
        $NewEvent = Wait-Event
        $ProcessName = $NewEvent.SourceEventArgs.NewEvent.ProcessName
        $Time = $NewEvent.TimeGenerated.DateTime
$NewEvent
$ProcessName
$Time

        Switch($NewEvent.SourceIdentifier){
            $ProcessStart{
                ([DateTime]$Time).ToString("HH:mm:ss") + " " + $ProcessName + " Start" | Out-File ("C:\Users\ict\Documents\NetBeansProjects\IT-engineer-school\public_html\observe-network\ProcessLog_" + (Get-Date -Format "yyyyMMdd") + ".txt") -Encoding UTF8 -Append;
                #([DateTime]$Time).ToString("HH:mm:ss") + " " + $ProcessName + " Start" | Out-File ("C:\Users\ict\Documents\NetBeansProjects\IT-engineer-school\public_html\observe-network\ProcessLog_" + (Get-Date -Format "yyyyMMdd") + ".txt") -Encoding UTF8 -Append Write-Host $Time $ProcessName "が開始しました";
                Break
            }
            $ProcessEnd{
                ([DateTime]$Time).ToString("HH:mm:ss") + " " + $ProcessName + " End" | Out-File ("C:\Users\ict\Documents\NetBeansProjects\IT-engineer-school\public_html\observe-network\ProcessLog_" + (Get-Date -Format "yyyyMMdd") + ".txt") -Encoding UTF8 -Append;
                #([DateTime]$Time).ToString("HH:mm:ss") + " " + $ProcessName + " End" | Out-File ("C:\Users\ict\Documents\NetBeansProjects\IT-engineer-school\public_html\observe-network\ProcessLog_" + (Get-Date -Format "yyyyMMdd") + ".txt") -Encoding UTF8 -Append Write-Host $Time $ProcessName "が終了しました";
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
