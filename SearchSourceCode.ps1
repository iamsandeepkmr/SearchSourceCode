$sourceCodePath = "D:\SourceCode\ProjectABC"
$text = "COMPANY XYZ PROPRIETARY. This document and its accompanying elements, contain information which is proprietary and confidential"
$includeFiles = "*.cs, *.ts, *.html, *.htm"
$excludeFolders = "bin, obj, node_modules, dist"
$outputFile = "D:\SourceCode\ProjectABC\IPRReport.txt"

$excludeFolders = $excludeFolders.Replace(',','|') -replace '\s',''
$files = Get-ChildItem -Path $sourceCodePath\* -Include $includeFiles.split(", ") -Recurse | Select-Object FullName | Select-Object FullName | Where-Object {$_.FullName -notmatch $excludeFolders}

Write-Host 'Total source files found:' $files.Count

$fileCountWithText = 0
$fileCountWithoutText = 0
$filesWithoutText = @()

Foreach ($file in $files)
{
 $contents = Get-Content -Path $file.FullName | Where-Object {$_.Contains($text)}
 if($contents.Count -eq 0)
	{
		$fileCountWithoutText++
		$filesWithoutText += $file.FullName
	}
	else
	{
		$fileCountWithText++
	}
}

Write-Host 'Total source files with text:' $fileCountWithText
Write-Host 'Total source files without text:' $fileCountWithoutText

Write-Host 'Below are the source files with missing text:'
Foreach ($fileWithoutText in $filesWithoutText)
{
	Write-Host $fileWithoutText
}

if($outputFile.Contains('.'))
{
	if (Test-Path $outputFile) {
	    Remove-Item $outputFile
	}
	$parentFolder = Split-Path $outputFile -parent
	if (!(Test-Path $parentFolder)) {
	   New-Item -Path $parentFolder -ItemType Directory
	}
}
else{
	if (!(Test-Path $outputFile)) {
	   New-Item -Path $outputFile -ItemType Directory
	}
	$outputFile = -join($outputFile, "\Report.txt")
}

-join("Total source files found: ", $files.Count) | Out-File -FilePath $outputFile -Append
-join("Total source files with text:", $fileCountWithText) | Out-File -FilePath $outputFile -Append
-join("Total source files without text:", $fileCountWithoutText) | Out-File -FilePath $outputFile -Append
"Below are the source files with missing text:" | Out-File -FilePath $outputFile -Append
$filesWithoutText | Out-File -FilePath $outputFile -Append



