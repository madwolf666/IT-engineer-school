$WQL = "Select * From RegistryTreeChangeEvent Within 3 Where Hive='HKEY_LOCAL_MACHINE' And RootPath='Software\\Microsoft'"
#SourceID = "RegistryChange"
Register-WMIEvent `
    -query $WQL `
    -sourceIdentifier $SourceID `
    -Action {
        Write-Host ("���W�X�g�����ύX����܂���") -Fore Red
    }
