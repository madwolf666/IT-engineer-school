#MACアドレスとベンダーの一覧を読み込む
#ダウンロードした「oui.txt」ファイルから「(hex)」とある行だけ取り出す
$addrOrg = Select-String -Pattern "\(hex\)" -Path "C:\Users\hal\Documents\NetBeansProjects\IT-engineer-school\public_html\prevention-trouble\oui.txt"

#MACアドレスの先頭「00-00-00」の部分とベンダー名の部分を取り出し、連想配列「$addrDB」に登録
$addrDB = @{}
foreach ($addrRecord in $addOrg) {
    $addrEntry = $addrRecord.Line.split("(")
    $vendorEntry = $addrRecord.Line.split(")")
    $addrDB.add($addrEntry[0].trim(), $vendorEntry[1].trim())
}

#同一ネットワークの各端末にpingを発行。タイムアウトは200ミリ秒
$mynetwork = "10.145.173."
$mynetwork = "192.168.30."
1..254 | ForEach-Object {
    $targetAddr = $mynetwork + $_
    $r = ping $targetAddr -4 -n 1 -w 200
}
#arp -aの実行結果から空白行を除き、変数「$result」に格納
$result = arp -a | Where-object { $_.trim() }
0..($result.Count - 1) | ForEach-Object {
    $line = $result[$_]
    #「インターネット」とある行を無視
    if ($line.IndexOf("インターネット") -eq -1) {
        #「インターフェース」とある行からローカルのIPアドレスを取得
        if ($line.IndexOf("インターフェイス") -ge 0) {
            $L = $line.split(":")
            $L2 = $L[1].split("---")
            $addr = $L2[0]
        } else {
            #登録されたIPアドレスとMACアドレスを取り出し、MACアドレスの一部からベンダー名を取得して画面に出力
            $hostaddr = $line.SubString(2, 15)
            $macaddr = $line.SubString(24, 17).trim()
            $vendorName = $addrDB[$macaddr.SubString(0, 8)]
            $hostaddr + "," + $macaddr + "," + $vendorName
        }
    }
}
