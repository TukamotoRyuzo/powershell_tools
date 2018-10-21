Param(
  [parameter(mandatory=$true)][string]$Src,
  [parameter(mandatory=$true)][string]$Delimiter,  
  [parameter(mandatory=$true)][array]$ExtractColumnNumber,
  [parameter(mandatory=$true)][string]$OutFileForExtractColumn,
  [parameter(mandatory=$true)][string]$OutFileForRemainColumn
)

$csv = Get-Content $Src

# csvファイルの列数を調べる
$column_size = $csv[-1].split($Delimiter).length

foreach ($column_number in $ExtractColumnNumber) {
    # csvの列数を超える列番号が指定されたら警告吐いて終了
    if ($column_size -lt $column_number + 1) {
        Write-Output "column_size = $column_size, ExtractColumnNumber = $ExtractColumnNumber"
        return
    }
}

if (Test-Path $OutFileForExtractColumn) {
    Remove-Item $OutFileForExtractColumn
}
if (Test-Path $OutFileForRemainColumn) {
    Remove-Item $OutFileForRemainColumn
}

# 指定された列番号のカラムを抜き出して別のcsvファイルに保存する
foreach ($row in $csv) {
    $column_list = $row.split($Delimiter)
    $count = 0

    foreach ($column in $column_list) {
        $column += $Delimiter
        # 指定された列番号なら、それ用のcsvに吐く
        if ($count -in $ExtractColumnNumber) {
            $column | Out-File $OutFileForExtractColumn -Append -NoNewLine
        }
        else {
            $column | Out-File $OutFileForRemainColumn -Append -NoNewLine
        }
        $count++
    }

    "" | Out-File $OutFileForExtractColumn -Append
    "" | Out-File $OutFileForRemainColumn -Append
}