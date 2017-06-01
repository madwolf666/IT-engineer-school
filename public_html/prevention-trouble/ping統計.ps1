#「xx=00ms」の文字列から、数値の部分だけを取り出して返す関数を定義
Function separatems {
	param($timeData)
	$L = $timeData.split("=")
	$L2 = $L[1].split("m")
	return $L2[0]
}

$outfile = "C:\chappy\study\network\Result.txt"
$switchList = "sutekinakaso.com"
#配列「$switchList」から要素を取り出し、変数「$switch」に代入して順次実行
foreach($switch in $switchList) {
	$TimeStamp = (Get-Date).ToString("f")
        #名前解決に時間がかかる可能性があるので、１度ping実行
	$r = ping $switch -n 1
        #pingを実行し、結果を変数「$result」に入れる
	$result = ping $switch -4 -w 1 -n 4
        #11行目に「平均」の表示があれば、pingは通っている
	if ($result[10].IndexOf("平均") -ge 0 ) {
                #「、」で11行目の文字列を分割して変数「＄L」い入れる
		$L = ($result[10].split("、"))
                #「最小」「最大」「平均」の順に、値だけ取り出す
		$turnRoundmin = separatems $L[0]
		$turnRoundmax = separatems $L[1]
		$turnRoundavg = separatems $L[2]
		$pinData = $switch + "," + $turnRoundmin + "," + $turnRoundmax + "," + $turnRoundavg + "," + $TimeStamp
	}
	else {
		$pinData = $switch + ", Timeout, Timeout, Timeout, " + $TimeStamp
	}
	Add-Content -value $pinData -path $outfile -Encoding UTF8
}
