$file = 'c:\Users\solin\Downloads\Hemanth_b_E309drGtPne-1773079189463\mobile_app\lib\main.dart'
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

# Fix 1: Replace the encoding-corrupted em-dash in the time display
$content = $content -replace "'\$\{_fmt\(startMin\)\}â€"", "'\${_fmt(startMin)}-"
# Also in the break label area if broken
$content = $content -replace "â€"", "-"

# Fix 2: Fix the checkmark corruption
$content = $content -replace "'âœ\"'", "'OK'"

# Fix 3: Replace the outer Column (which overflows) with a ClipRect+Column approach
# Change: height: studyPx + breakPx  →  just let children determine height via Column inherently
# But we know total = studyPx + breakPx. The issue: (studyPx-2) + (breakPx-2) = total - 4, leaving 4px empty.
# But wait, the OVERFLOW means children are BIGGER than SizedBox. That happens when studyPx is fractional.
# Real fix: Use overflow: Overflow.clip on the column or wrap in ClipRect

# Let's change the SizedBox to use ClipRect and the Column to have MainAxisSize.min
$old = 'child: SizedBox(
                                            height: studyPx + breakPx,
                                            child: Column(
                                              children: ['
$new = 'child: ClipRect(
                                            child: SizedBox(
                                            height: studyPx + breakPx,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: ['

$content = $content -replace [regex]::Escape($old), $new

# Add the closing bracket for ClipRect
$oldEnd = '                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),'
$newEnd = '                                              ],
                                            ),
                                          ),
                                          ),
                                        );
                                      }).toList(),'

$content = $content -replace [regex]::Escape($oldEnd), $newEnd

[System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
Write-Host "Done. Total bytes: $((Get-Item $file).Length)"
