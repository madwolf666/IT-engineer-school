#OutlookÇÃê´î\ÇäƒéãÇ∑ÇÈ
$WmiQuery = "Select * From __InstanceModificationEvent Within 1 Where TargetInstance ISA 'Win32_PerfFormattedData_PerfProc_Process' And TargetInstance.Name = 'outlook'"
$SourceID = "OutlookPercentage"
$LogFileName = "c:\tmp\OutlookPercentage.log"
Register-WMIEvent `
    -query $WmiQuery `
    -sourceIdentifier $SourceID `
    -Action {
        $NewEvent = $Event.SourceEventArgs.NewEvent;
        $TargetInstance = $NewEvent.TargetInstance;
        $TimeGenerated = $Event.TimeGenerated.ToString();
        $ProcessName = $TargetInstance.Name;
        $IDProcess = $TargetInstance.IDProcess;
        $IODataBytesPerSec = $TargetInstance.IODataBytesPerSec;
        $PercentProcessorTime = $TargetInstance.PercentProcessTime;
        $WorkingSet = $TargetInstance.WorkingSet;
        $Message = $TimeGenerated,$ProcessName,$IDProcess,$IODataBytesPerSec,$PercentProcessorTime,$WorkingSet;
        $Message join "," | Out-File -FilePath $LogFileName -Append;
    }
