#MAC�A�h���X�ƃx���_�[�̈ꗗ��ǂݍ���
#�_�E�����[�h�����uoui.txt�v�t�@�C������u(hex)�v�Ƃ���s�������o��
$addrOrg = Select-String -Pattern "\(hex\)" -Path "C:\Users\hal\Documents\NetBeansProjects\IT-engineer-school\public_html\prevention-trouble\oui.txt"

#MAC�A�h���X�̐擪�u00-00-00�v�̕����ƃx���_�[���̕��������o���A�A�z�z��u$addrDB�v�ɓo�^
$addrDB = @{}
foreach ($addrRecord in $addOrg) {
    $addrEntry = $addrRecord.Line.split("(")
    $vendorEntry = $addrRecord.Line.split(")")
    $addrDB.add($addrEntry[0].trim(), $vendorEntry[1].trim())
}

#����l�b�g���[�N�̊e�[����ping�𔭍s�B�^�C���A�E�g��200�~���b
$mynetwork = "10.145.173."
$mynetwork = "192.168.30."
1..254 | ForEach-Object {
    $targetAddr = $mynetwork + $_
    $r = ping $targetAddr -4 -n 1 -w 200
}
#arp -a�̎��s���ʂ���󔒍s�������A�ϐ��u$result�v�Ɋi�[
$result = arp -a | Where-object { $_.trim() }
0..($result.Count - 1) | ForEach-Object {
    $line = $result[$_]
    #�u�C���^�[�l�b�g�v�Ƃ���s�𖳎�
    if ($line.IndexOf("�C���^�[�l�b�g") -eq -1) {
        #�u�C���^�[�t�F�[�X�v�Ƃ���s���烍�[�J����IP�A�h���X���擾
        if ($line.IndexOf("�C���^�[�t�F�C�X") -ge 0) {
            $L = $line.split(":")
            $L2 = $L[1].split("---")
            $addr = $L2[0]
        } else {
            #�o�^���ꂽIP�A�h���X��MAC�A�h���X�����o���AMAC�A�h���X�̈ꕔ����x���_�[�����擾���ĉ�ʂɏo��
            $hostaddr = $line.SubString(2, 15)
            $macaddr = $line.SubString(24, 17).trim()
            $vendorName = $addrDB[$macaddr.SubString(0, 8)]
            $hostaddr + "," + $macaddr + "," + $vendorName
        }
    }
}
