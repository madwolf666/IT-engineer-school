#新しく作成されたファイルを監視する
$TargetPath = ".\\\\"
$GroupComponent = "Win32_Directory.Name=""$TargetPath"""
$WmiQuery = "Select * From __InstanceCreationEvent Within 10 Where TargetInstance ISA 'CIM_DirectoryContainsFile' And TargetInstance.GroupComponent='$GroupComponent'"
$SourceID = "NewFile"
$LogFileName = ".\NewFile.log"
Register-WmiEvent `
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
