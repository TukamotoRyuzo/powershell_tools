# powershell_tools

- 個人的に使うpowershellツール集

## csv抽出

- 指定した`.csv`ファイルから以下の2つのcsvを作成する
  - 指定列だけを抽出した`.csv`
  - 指定列だけを削除した`.csv`
- (例)
  - `src.csv`（区切り文字は`","`）から、以下のファイルを作成
    - 0列目、1列目だけを抽出した`target_extract.csv`
    - 0列目、1列目だけを削除した`target_remain.csv`

```powershell
./split_csv.ps1 `
-Src "src.csv" `
-Delimiter "," ` #区切り文字を指定しない場合は、先頭から0文字目、1文字目を抽出する
-ExtractColumnNumber (0,1) `
-OutFileForExtractColumn "target_extract.csv" `
-OutFileForRemainColumn "target_remain.csv" `
-InputEncoding "default" ` #入力ファイルの文字コード("default"=SJIS,指定しないときUTF8)
-OutputEncoding "default" ` #出力ファイルの文字コード("default"=SJIS,指定しないときUTF8)
```