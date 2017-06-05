#����t�@�C���̑傫���̕ω����Ď�����
$TargetPath = ".\ProcessLog_20170605.txt"
if (!(Test-Path $TargetPath)){
    Echo "�t�@�C�������݂��܂���:$TargetPath";Exit
}
$WmiQuery = "Select * From __InstanceModificationEvent Within 3 Where TargetInstance ISA 'CIM_DataFile' And TargetInstanceName = '$TargetPath'"
$SourceID = "LogFileModification"
$LogFileName = ".\FileSizeModification.log"
Register-WMIEvent `
    -query $WmiQuery `
    -sourceIdentifier $SourceID `
    -Action {
        $TargetInstance = $Event.SourceEventArgs.NewEvent.TargetInstance;
        $TimeGenerated = $Event.TimeGenerated.ToString();
        $FileName = $TargetInstance.Name;
        $FileInfo = Get-item $FileName.Replace("""","");
        $TimeGenerated + "," `
        + $FileName.Replace("\\","\") + "," `
        + $FileInfo.Length.ToString() + "," `
        + $FileInfo.LastWriteTime.ToString() `
        | Out-File -FilePath $LogFileName -Append;
    }
