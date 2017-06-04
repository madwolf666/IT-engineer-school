#新しく作成されたファイルを監視する
$TargetPath = "c:\\\\Tools"
$GroupComponent = "Win32_Directory.Name=""$TargetPath"""
$WmiQuery = "Select * From __InstanceCreationEvent Within 10 Where TargetInstance ISA 'CIM_DirectoryContainsFile' And TargetInstance.GroupComponent = '$GroupComponent'"
$SourceID = "NewFile"
$LogFileName = "c:\tmp\NewFile.txt"
Register-WMIEvent `
    -query $WmiQuery `
    -sourceIdentifier $SourceID `
    -Action {
        $TargetInstance = $Event.SourceEventArgs.NewEvent.TargetInstance;
        $TimeGenerated = $Event.TimeGenerated.ToString();
        $FileName = $TargetInstance.PartComponent.Split("=")[1];
        $FileInfo = Get-item $FileName.Replace("""","");
        $TimeGenerated + "," `
        + $FileName.Replace("\\","\") + "," `
        + $FileInfo.Length.ToString() + "," `
        + $FileInfo.LastWriteTime.ToString() `
        | Out-File -FilePath $LogFileName -Append;
    }
