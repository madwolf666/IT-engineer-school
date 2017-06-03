#バイト単位で部分文字列を取り出す処理
function Get-SubStringBytes{
    param ($Source, $startIndex, $Length)
    $encoding = {System.Text.Encoding}::default
    $byteString = $encoding.GetBytes($Source)
    if (($startInex + $Length - 1) -ge $encoding.GetByteCount($Source)){
    } else {
        return $encoding.GetString($byteString, $startIndex, $Length
    }
}
#Windowsネットワークの端末として得られる機器の一覧を出力
$svrCandidates = ne view
$ErrorActionPreference = "SilentlyContinue"

foreach ($svrCandidate in $svrCandidates) {
    $svrStr = $svrCandidate.split()
    #net viewコマンドで個々の端末にアクセスし、共有リソースを公開しているか問い合わせる
    $svrEntries = net view $svrStr[0]
    if ($svrEntries -ne $null) {
        #「共有リソース」の文字があれば、何か公開していると認識
        if ($svrEntries[0].IndexOf("共有リソース") -ge 0) {
            #見出しの文字位置を取得し、バイト数になるよう調整
            $typePos = $svrEntries[4].IndexOf("タイプ") + 3
            $usePos = $svrEntries[4].IndexOf("使用") + 6
            $commentPos = $svrEntries[4].IndexOf("コメント") + 8
            #8行目以降、最後3行を除いた範囲がリスト化の対象
            7..($svrEntries.Count -3) | Foreach-object {
                $maxWidth = [System.Text.Encoding]::GetEncoding("UTF-8").GetByteCount($svrEntries[$_])
                #共有名や種別、コメントなどを取得
                $shareName = Get-SubStringBytes $svrEntries[$_] 0 ($typePos - 1)
                $typeStr = Get-SubStringBytes $svrEntries[$_] 0 $typePos ($usePos - $typePos)
                $commentStr = Get-SubStringBytes $svrEntries[$_] 0 $commentPos ($maxWidth - $commentPos 1)
                $svrStr[0] + ", " + $shareName + ", " + $typeStr + ", " + $commentStr
            }
        }
    }
}
