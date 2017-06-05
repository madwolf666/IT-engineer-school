#特定ファイルに対する操作を同時に監視する
$TargetPath = ".\ProcessLog_20170605.txt"
$WmiQuery = "Select * From __InstanceModificationEvent Within 3 Where TargetInstance ISA 'CIM_DataFile' And TargetInstanceName = '$TargetPath'"
$SourceID = "FileOperation"
$LogFileName = ".\FileOperation.log"
Register-WMIEvent `
    -query $WmiQuery `
    -sourceIdentifier $SourceID `
    -Action {
        $NewEvent = $Event.SourceEventArgs.NewEvent;
        $TargetInstance = $NewEvent.TargetInstance;
        $TimeGenerated = $Event.TimeGenerated.ToString();
        $FileName = $TargetInstance.Name;
        Switch( $NewEvent.__Class.ToString() ){
            "__InstanceCreationEvent" {
                $Ope = "作成"
            }
            "__InstanceModificationEvent" {
                $Ope = "変更"
            }
            "__InstanceDeletionEvent" {
                $Ope = "削除"
            }
        }
        $FileSize = $TargetInstance.FileSize;
        $FileLastModified = $TargetInstance.LastModified;
        $Message = $TimeGenerated,$Ope,$FileName,$FileSize,$FileLastModified;
        $Message = $Message -join ",";
        $Message | Out-File -FilePath $LogFileName -Append;
    }
