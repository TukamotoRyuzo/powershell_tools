Param(
  [parameter(mandatory=$true)][string]$Src,
  [parameter(mandatory=$false)][string]$Delimiter="",  
  [parameter(mandatory=$true)][array]$ExtractColumnNumber,
  [parameter(mandatory=$true)][string]$OutFileForExtractColumn,
  [parameter(mandatory=$true)][string]$OutFileForRemainColumn,
  [parameter(mandatory=$false)][string]$InputEncoding="UTF8",
  [parameter(mandatory=$false)][string]$OutputEncoding="UTF8"
)

$csv = Get-Content $Src -Encoding $InputEncoding

# csvファイルの列数を調べる
$column_size = 0

if ($Delimiter -eq "") {
    $column_size = $csv[-1].length
}
else {
    $column_size = $csv[-1].split($Delimiter).length
}

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
    $count = 0
    $column_list = ""

    if ($Delimiter -eq "") {
        $column_list = $row.ToCharArray()
    }
    else {
        $column_list = $row.split($Delimiter)
    }

    foreach ($column in $column_list) {
        $column += $Delimiter
        # 指定された列番号なら、それ用のcsvに吐く
        if ($count -in $ExtractColumnNumber) {
            $column | Out-File $OutFileForExtractColumn -Append -NoNewLine -Encoding $OutputEncoding
        }
        else {
            $column | Out-File $OutFileForRemainColumn -Append -NoNewLine -Encoding $OutputEncoding
        }
        $count++
    }

    "" | Out-File $OutFileForExtractColumn -Append -Encoding $OutputEncoding
    "" | Out-File $OutFileForRemainColumn -Append -Encoding $OutputEncoding
}