$file = 'c:\Users\solin\Downloads\Hemanth_b_E309drGtPne-1773079189463\mobile_app\lib\main.dart'
$lines = Get-Content -Path $file -Encoding UTF8

# Fixed section for timetable (lines 2359 to 2428)
$fixedTimetable = @'
                                          child: ClipRect(
                                            child: SizedBox(
                                              height: studyPx + breakPx,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
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
                                                                '${_fmt(startMin)}-${_fmt(endMin)}',
                                                                style: const TextStyle(color: Colors.white70, fontSize: 8),
                                                              ),
                                                            if (studyPx > 44)
                                                              Row(
                                                                children: [
                                                                  _TinyBtn(
                                                                    label: isDone ? 'OK' : 'Mark',
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
                                                          'Break ${_fmt(endMin)}',
                                                          style: const TextStyle(color: Colors.white24, fontSize: 8)),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
'@ -split "`r?`n"

$newLines = @()
for ($i = 0; $i -lt $lines.Count; $i++) {
    $ln = $i + 1
    if ($ln -eq 2359) {
        $newLines += $fixedTimetable
        $i = 2427 # skip to 2428 (inclusive skip)
    } else {
        $newLines += $lines[$i]
    }
}

$newLines | Out-File -FilePath $file -Encoding UTF8
Write-Host "Timetable overflow fixed via line numbers."
