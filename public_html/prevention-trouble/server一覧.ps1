#�o�C�g�P�ʂŕ�������������o������
function Get-SubStringBytes{
    param ($Source, $startIndex, $Length)
    $encoding = {System.Text.Encoding}::default
    $byteString = $encoding.GetBytes($Source)
    if (($startInex + $Length - 1) -ge $encoding.GetByteCount($Source)){
    } else {
        return $encoding.GetString($byteString, $startIndex, $Length
    }
}
#Windows�l�b�g���[�N�̒[���Ƃ��ē�����@��̈ꗗ���o��
$svrCandidates = ne view
$ErrorActionPreference = "SilentlyContinue"

foreach ($svrCandidate in $svrCandidates) {
    $svrStr = $svrCandidate.split()
    #net view�R�}���h�ŌX�̒[���ɃA�N�Z�X���A���L���\�[�X�����J���Ă��邩�₢���킹��
    $svrEntries = net view $svrStr[0]
    if ($svrEntries -ne $null) {
        #�u���L���\�[�X�v�̕���������΁A�������J���Ă���ƔF��
        if ($svrEntries[0].IndexOf("���L���\�[�X") -ge 0) {
            #���o���̕����ʒu���擾���A�o�C�g���ɂȂ�悤����
            $typePos = $svrEntries[4].IndexOf("�^�C�v") + 3
            $usePos = $svrEntries[4].IndexOf("�g�p") + 6
            $commentPos = $svrEntries[4].IndexOf("�R�����g") + 8
            #8�s�ڈȍ~�A�Ō�3�s���������͈͂����X�g���̑Ώ�
            7..($svrEntries.Count -3) | Foreach-object {
                $maxWidth = [System.Text.Encoding]::GetEncoding("UTF-8").GetByteCount($svrEntries[$_])
                #���L�����ʁA�R�����g�Ȃǂ��擾
                $shareName = Get-SubStringBytes $svrEntries[$_] 0 ($typePos - 1)
                $typeStr = Get-SubStringBytes $svrEntries[$_] 0 $typePos ($usePos - $typePos)
                $commentStr = Get-SubStringBytes $svrEntries[$_] 0 $commentPos ($maxWidth - $commentPos 1)
                $svrStr[0] + ", " + $shareName + ", " + $typeStr + ", " + $commentStr
            }
        }
    }
}
