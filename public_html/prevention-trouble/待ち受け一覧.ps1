#netstat�̎��s���ʂ���uLISTENING�v���܂ލs�����o���A�ϐ��u$ListeningPorts�v�Ɋi�[
$ListeningPorts = netstat -ano | select-string LISTENING
foreach ($ListeningPort in $ListeningPorts) {
    $PortInfo = -split $ListeningPort.line
    #���̂T�Ԗڂ̗v�f���v���Z�XID�Ȃ̂ŁA�Ή�����v���Z�X�����擾���Ă���
    $ProcessName = (Get-Process -id $PortInfo[4]).ProcessName
    write-host $PortInfo[0],",", $PortInfo[1],",", $ProcessName
}
