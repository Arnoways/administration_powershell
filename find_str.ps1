##Find a string in multiple files
Get-ChildItem "directory\path" -recurse | select-string -pattern "string_to_find" | group path | select name
