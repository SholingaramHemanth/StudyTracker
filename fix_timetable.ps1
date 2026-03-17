$file = 'c:\Users\solin\Downloads\Hemanth_b_E309drGtPne-1773079189463\mobile_app\lib\main.dart'
$lines = Get-Content $file

# Find start and end of the corrupt block
$startLine = -1
$endLine = -1

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s+// Session cards\s*$' -and $startLine -eq -1) {
        $startLine = $i
    }
    if ($startLine -ne -1 -and $lines[$i] -match '^\s+\}\)\.toList\(\),\s*$') {
        $endLine = $i
        break
    }
}

Write-Host "Found block at lines $($startLine+1) to $($endLine+1)"

$replacement = @'
                                     // Session cards
                                     ...daySessions.map((session) {
                                       final startMin = session['startMin'] as int;
                                       final endMin = session['endMin'] as int;
                                       final breakEndMin = session['breakEndMin'] as int;
                                       final subjectIdx = session['subjectIdx'] as int;
                                       final sessionKey = session['key'] as String;
                                       final Sub = _planSubjects[subjectIdx];
                                       final color = _subjectColors[subjectIdx % _subjectColors.length];
                                       final isDone = _doneSessions[sessionKey] == true;

                                       final topPx = ((startMin - minMinute) / 60) * rowHeight;
                                       final studyPx = ((endMin - startMin) / 60) * rowHeight;
                                       final breakPx = ((breakEndMin - endMin) / 60) * rowHeight;

                                       return Positioned(
                                         top: topPx,
                                         left: 2,
                                         right: 2,
                                         child: SizedBox(
                                           height: studyPx + breakPx,
                                           child: Column(
                                             children: [
                                               GestureDetector(
                                                 onTap: () => setState(() =>
                                                     _doneSessions[sessionKey] = !isDone),
                                                 child: AnimatedContainer(
                                                   duration: const Duration(milliseconds: 250),
                                                   height: studyPx - 2,
                                                   decoration: BoxDecoration(
                                                     color: isDone ? color.withOpacity(0.35) : color.withOpacity(0.85),
                                                     borderRadius: BorderRadius.circular(8),
                                                     border: isDone ? Border.all(color: Colors.white38, width: 1.5) : null,
                                                   ),
                                                   padding: const EdgeInsets.all(5),
                                                   child: ClipRect(
                                                     child: Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       mainAxisSize: MainAxisSize.min,
                                                       children: [
                                                         Text(
                                                           Sub['name'] as String,
                                                           style: TextStyle(
                                                               color: isDone ? Colors.white54 : Colors.white,
                                                               fontWeight: FontWeight.bold,
                                                               fontSize: 10,
                                                               decoration: isDone ? TextDecoration.lineThrough : null),
                                                           maxLines: 1,
                                                           overflow: TextOverflow.ellipsis,
                                                         ),
                                                         if (studyPx > 30)
                                                           Text(
                                                             '${_fmt(startMin)}–${_fmt(endMin)}',
                                                             style: const TextStyle(color: Colors.white70, fontSize: 8),
                                                           ),
                                                         if (studyPx > 44)
                                                           Row(
                                                             children: [
                                                               _TinyBtn(
                                                                 label: isDone ? '✓' : 'Mark',
                                                                 color: Colors.white24,
                                                                 onTap: () => setState(() =>
                                                                     _doneSessions[sessionKey] = !isDone),
                                                               ),
                                                               const SizedBox(width: 4),
                                                               _TinyBtn(
                                                                 label: 'Start',
                                                                 color: Colors.white24,
                                                                 onTap: () {},
                                                               ),
                                                             ],
                                                           ),
                                                       ],
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                               if (breakPx > 4)
                                                 Container(
                                                   height: breakPx - 2,
                                                   alignment: Alignment.centerLeft,
                                                   padding: const EdgeInsets.only(left: 4),
                                                   child: Text(
                                                       'Break  ${_fmt(endMin)}',
                                                       style: const TextStyle(color: Colors.white24, fontSize: 8)),
                                                 ),
                                             ],
                                           ),
                                         ),
                                       );
                                     }).toList(),
'@

$replacementLines = $replacement -split "`r?`n" | Where-Object { $_ -ne $null }
# Remove last empty element if present
if ($replacementLines[-1] -eq '') { $replacementLines = $replacementLines[0..($replacementLines.Count-2)] }

$newLines = @()
$newLines += $lines[0..($startLine-1)]
$newLines += $replacementLines
$newLines += $lines[($endLine+1)..($lines.Count-1)]

$newLines | Set-Content $file -Encoding UTF8
Write-Host "Done! File has $($newLines.Count) lines."
