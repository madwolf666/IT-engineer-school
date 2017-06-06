#プロセスの起動と停止を監視
Register-WMIEvent `
    -Class Win32_ProcessStartTrace `
    -SourceIdentifier "NewProcess" `
    -Action {
        $ProcessName = $Event.SourceEventArgs.NewEvent.ProcessName;
        $TimeCreated = $Event.SourceEventArgs.NewEvent.TIME_CREATED;
        $DT = [DateTime]::FromFileTime($TimeCreated);
        Write-Host ("起動:$DT $ProcessName") -Fore Blue
    }

Register-WMIEvent `
    -Class Win32_ProcessStopTrace `
    -SourceIdentifier "EndProcess" `
    -Action {
        $ProcessName = $Event.SourceEventArgs.NewEvent.ProcessName;
        $TimeCreated = $Event.SourceEventArgs.NewEvent.TIME_CREATED;
        $DT = [DateTime]::FromFileTime($TimeCreated);
        Write-Host ("停止:$DT $ProcessName") -Fore Red
    }
