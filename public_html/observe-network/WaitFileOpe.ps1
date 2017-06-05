#����t�@�C���ɑ΂��鑀��𓯎��ɊĎ�����
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
                $Ope = "�쐬"
            }
            "__InstanceModificationEvent" {
                $Ope = "�ύX"
            }
            "__InstanceDeletionEvent" {
                $Ope = "�폜"
            }
        }
        $FileSize = $TargetInstance.FileSize;
        $FileLastModified = $TargetInstance.LastModified;
        $Message = $TimeGenerated,$Ope,$FileName,$FileSize,$FileLastModified;
        $Message = $Message -join ",";
        $Message | Out-File -FilePath $LogFileName -Append;
    }
