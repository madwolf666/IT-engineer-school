Register-WMIEvent `
    -Class Win32_ProcessStartTrace `
    -SourceIdentifier "NewProcess" `
    -Action {
        $ProcessName = $Event.SourceEventArgs.NewEvent.ProcessName;
        $TimeGenerated = $Event.SourceEventArgs.NewEvent.TIME_CREATED;
        $DT = [(DateTime)]::FromFileTime($TimeCreated);
        Write-Host ("‹N“®:$DT $ProcessName") -Fore Blue
    }

Register-WMIEvent `
    -Class Win32_ProcessStopTrace `
    -SourceIdentifier "EndProcess" `
    -Action {
        $ProcessName = $Event.SourceEventArgs.NewEvent.ProcessName;
        $TimeGenerated = $Event.SourceEventArgs.NewEvent.TIME_CREATED;
        $DT = [(DateTime)]::FromFileTime($TimeCreated);
        Write-Host ("’âŽ~:$DT $ProcessName") -Fore Red
    }
