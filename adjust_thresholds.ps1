$file = 'c:\Users\solin\Downloads\Hemanth_b_E309drGtPne-1773079189463\mobile_app\lib\main.dart'
$lines = Get-Content -Path $file -Encoding UTF8

$newLines = @()
for ($i = 0; $i -lt $lines.Count; $i++) {
    $ln = $i + 1
    # Line 2392 in the current file (was 2392 in view_file 241)
    if ($lines[$i] -match "if \(studyPx > 30\)") {
        $newLines += "                                                            if (studyPx > 40)"
    }
    elseif ($lines[$i] -match "if \(studyPx > 44\)") {
        $newLines += "                                                            if (studyPx > 55)"
    }
    else {
        $newLines += $lines[$i]
    }
}

$newLines | Out-File -FilePath $file -Encoding UTF8
Write-Host "Overflow thresholds adjusted."
