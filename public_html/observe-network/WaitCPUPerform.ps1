#CPU‚Ì«”\‚ğŠÄ‹‚·‚é
$WmiQuery = "Select * From __InstanceModificationEvent Within 1 Where TargetInstance ISA 'Win32_Processor'"
$SourceID = "CPULoadPercentage"
$LogFileName = ".\CPULoadPercentage.log"
Register-WMIEvent `
    -query $WmiQuery `
    -sourceIdentifier $SourceID `
    -Action {
        $NewEvent = $Event.SourceEventArgs.NewEvent;
        $TargetInstance = $NewEvent.TargetInstance;
        $TimeGenerated = $Event.TimeGenerated.ToString();
        $LoadPercentage = $TargetInstance.LoadPercentage;
        $Message = $TimeGenerated + "," + $LoadPercentage;
        $Message | Out-File -FilePath $LogFileName -Append;
    }
