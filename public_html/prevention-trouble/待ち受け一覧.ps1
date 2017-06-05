#netstatの実行結果から「LISTENING」を含む行を取り出し、変数「$ListeningPorts」に格納
$ListeningPorts = netstat -ano | select-string LISTENING
foreach ($ListeningPort in $ListeningPorts) {
    $PortInfo = -split $ListeningPort.line
    #情報の５番目の要素がプロセスIDなので、対応するプロセス名を取得している
    $ProcessName = (Get-Process -id $PortInfo[4]).ProcessName
    write-host $PortInfo[0],",", $PortInfo[1],",", $ProcessName
}
