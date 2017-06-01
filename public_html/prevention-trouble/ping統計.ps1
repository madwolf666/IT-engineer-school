#�uxx=00ms�v�̕����񂩂�A���l�̕������������o���ĕԂ��֐����`
Function separatems {
	param($timeData)
	$L = $timeData.split("=")
	$L2 = $L[1].split("m")
	return $L2[0]
}

$outfile = "C:\chappy\study\network\Result.txt"
$switchList = "sutekinakaso.com"
#�z��u$switchList�v����v�f�����o���A�ϐ��u$switch�v�ɑ�����ď������s
foreach($switch in $switchList) {
	$TimeStamp = (Get-Date).ToString("f")
        #���O�����Ɏ��Ԃ�������\��������̂ŁA�P�xping���s
	$r = ping $switch -n 1
        #ping�����s���A���ʂ�ϐ��u$result�v�ɓ����
	$result = ping $switch -4 -w 1 -n 4
        #11�s�ڂɁu���ρv�̕\��������΁Aping�͒ʂ��Ă���
	if ($result[10].IndexOf("����") -ge 0 ) {
                #�u�A�v��11�s�ڂ̕�����𕪊����ĕϐ��u��L�v�������
		$L = ($result[10].split("�A"))
                #�u�ŏ��v�u�ő�v�u���ρv�̏��ɁA�l�������o��
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
