Param(
$RootFolder = "C:\Program Files"
)

$Items = (Get-ChildItem -Path $RootFolder -Recurse -ErrorAction "SilentlyContinue" | Where-Object {$_.GetType().Name -eq "FileInfo"} | Measure-Object -Property Length -Sum)
[Array]$Folders = [PSCustomObject]@{
    "FullName" = $RootFolder
    "Size(MB)" = ("{0:N1}" -F ($Items.Sum / 1MB))
}

$Items = (Get-ChildItem -Path $RootFolder -Recurse -ErrorAction "SilentlyContinue" | Where-Object {$_.GetType().Name -eq "DirectoryInfo"})
$Folders += ForEach($i in $Items)
{
    $SubFolderItems = (Get-ChildItem -Path $i.FullName -Recurse -ErrorAction "SilentlyContinue" | Where-Object {$_.GetType().Name -eq "FileInfo"} | Measure-Object -Property Length -Sum)
    #"{0:N2} -f ($SubFolderItems.Sum / 1MB) + " MB" -- " + $i.FullName

    [PSCustomObject]@{
        "FullName" = $i.FullName
        "Size(MB)" = [decimal]("{0:N1}" -F ($SubFolderItems.Sum / 1MB))
    }
}

$Folders | Sort "Size(MB)" -Descending | Select-Object -First 10 | Format-Table -AutoSize
