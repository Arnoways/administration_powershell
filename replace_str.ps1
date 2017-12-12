##Replace a string in a -or multiple- file(s) with another string.

$sc = Get-ChildItem path\tofiles\[file or *].extension -rec
foreach ($file in $sc) {
  (Get-Content $file.PSPath) |
  Foreach-Object { $_ -replace "string_to_replace", "new_string" } | Set-Content $file.PSPath
}
