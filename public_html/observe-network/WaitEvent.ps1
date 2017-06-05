#新しく起動したプログラムを取得する
$WmiQuery = "SELECT * FROM __InstanceCreationEvent within 10 WHERE TargetInstance ISA 'Win32_Process'"
$SourceID = "NewProcess"
$LogFileName = ".\NewProcess.log"
Register-WMIEvent `
    -query $WmiQuery `
    -sourceIdentifier $SourceID `
    -Action { $Event.TimeGenerated.ToString() + "," `
            + $Event.SourceEventArgs.NewEvent.TargetInstance.ProcessID + "," `
            + $Event.SourceEventArgs.NewEVent.TargetInstance.Name `
            | Out-File -FilePath $LogFileName -Append }
