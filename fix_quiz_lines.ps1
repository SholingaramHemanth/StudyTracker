$file = 'c:\Users\solin\Downloads\Hemanth_b_E309drGtPne-1773079189463\mobile_app\lib\main.dart'
$lines = Get-Content -Path $file -Encoding UTF8

# Rewrite the Quiz section starting from the comment block
$quizPart = @'
// =================================================================
//  QUIZ TAB
// =================================================================

class QuizTab extends StatefulWidget {
  final List<String> subjects;
  final Function(Map<String, dynamic>) onQuizComplete;
  const QuizTab({super.key, required this.subjects, required this.onQuizComplete});
  @override
  State<QuizTab> createState() => _QuizTabState();
}

class _QuizTabState extends State<QuizTab> {
  String? _selectedSubject;
  int _questionCount = 10;

  static Map<String, List<Map<String, dynamic>>> get _questionBank => {
    'Mathematics': [
      {'q': 'What is the derivative of x^2?', 'opts': ['2x', 'x^2', '2', 'x'], 'ans': 0, 'exp': 'By power rule: d/dx(x^n) = nx^(n-1), so d/dx(x^2) = 2x.', 'emoji': '📐'},
      {'q': 'What is integral 2x dx?', 'opts': ['x^2+C', '2x^2+C', 'x+C', '2+C'], 'ans': 0, 'exp': 'Integral of 2x: integral 2x dx = x^2 + C by reverse power rule.', 'emoji': '∫'},
      {'q': 'Solve: x^2 - 5x + 6 = 0', 'opts': ['x=2,3', 'x=1,6', 'x=-2,-3', 'x=3,4'], 'ans': 0, 'exp': 'Factor: (x-2)(x-3)=0, so x=2 or x=3.', 'emoji': '🔢'},
      {'q': 'What is sin(90 deg)?', 'opts': ['1', '0', '-1', '0.5'], 'ans': 0, 'exp': 'sin(90) = 1 from the unit circle.', 'emoji': '📌'},
      {'q': 'log2(8) = ?', 'opts': ['3', '4', '2', '8'], 'ans': 0, 'exp': '2^3 = 8, so log2(8) = 3.', 'emoji': '🔣'},
      {'q': 'Area of circle with r=7?', 'opts': ['154', '44', '49', '22'], 'ans': 0, 'exp': 'A = pi*r^2 = (22/7)*49 = 154.', 'emoji': '⭕'},
      {'q': 'Value of cos(0 deg)?', 'opts': ['1', '0', '-1', 'inf'], 'ans': 0, 'exp': 'cos(0) = 1 from unit circle definition.', 'emoji': '🌀'},
      {'q': 'What is 7! (7 factorial)?', 'opts': ['5040', '720', '40320', '210'], 'ans': 0, 'exp': '7! = 7*6*5*4*3*2*1 = 5040.', 'emoji': '❗'},
      {'q': 'If A={1,2} and B={2,3}, then A intersection B?', 'opts': ['{2}', '{1,3}', '{1,2,3}', '{}'], 'ans': 0, 'exp': 'Intersection = elements in both sets = {2}.', 'emoji': '🔵'},
      {'q': 'tan(45 deg) = ?', 'opts': ['1', '0', 'sqrt(2)', 'sqrt(3)'], 'ans': 0, 'exp': 'tan(45) = sin/cos = 1/1 = 1.', 'emoji': '📐'},
      {'q': 'Sum of angles in a triangle?', 'opts': ['180 deg', '360 deg', '90 deg', '270 deg'], 'ans': 0, 'exp': 'Sum of interior angles of any triangle = 180.', 'emoji': '🔺'},
      {'q': 'What is the slope of y=3x+2?', 'opts': ['3', '2', '1/3', '-3'], 'ans': 0, 'exp': 'In y=mx+b, m is the slope. Here m=3.', 'emoji': '📈'},
      {'q': 'Probability of tossing heads?', 'opts': ['1/2', '1/4', '1', '0'], 'ans': 0, 'exp': 'Fair coin: P(H) = 1/2 = 0.5.', 'emoji': '🪙'},
      {'q': 'HCF of 12 and 18?', 'opts': ['6', '3', '9', '36'], 'ans': 0, 'exp': 'Factors: 12={1,2,3,4,6,12}, 18={1,2,3,6,9,18}. HCF=6.', 'emoji': '🔱'},
      {'q': 'What is 2^8?', 'opts': ['256', '128', '512', '64'], 'ans': 0, 'exp': '2^8 = 256.', 'emoji': '💻'},
      {'q': 'Pythagoras: a=3, b=4, c=?', 'opts': ['5', '6', '7', '4'], 'ans': 0, 'exp': 'c=sqrt(a^2+b^2)=sqrt(9+16)=sqrt(25)=5.', 'emoji': '📐'},
      {'q': 'Arithmetic mean of 2,4,6,8,10?', 'opts': ['6', '5', '8', '4'], 'ans': 0, 'exp': 'Mean = (2+4+6+8+10)/5 = 30/5 = 6.', 'emoji': '📊'},
      {'q': 'How many sides does a hexagon have?', 'opts': ['6', '5', '7', '8'], 'ans': 0, 'exp': 'Hexa means 6. A hexagon has 6 sides.', 'emoji': '⬡'},
      {'q': 'What is sqrt(144)?', 'opts': ['12', '14', '11', '13'], 'ans': 0, 'exp': '12 * 12 = 144, so sqrt(144) = 12.', 'emoji': '🔲'},
      {'q': 'LCM of 4 and 6?', 'opts': ['12', '6', '24', '8'], 'ans': 0, 'exp': 'LCM = smallest common multiple of 4 and 6 = 12.', 'emoji': '🔢'},
    ],
    'Physics': [
      {'q': "Newton's 2nd Law: F = ?", 'opts': ['ma', 'mv', 'm/a', 'a/m'], 'ans': 0, 'exp': 'Force = mass * acceleration (F = ma).', 'emoji': '⚡'},
      {'q': 'Speed of light in vacuum?', 'opts': ['3x10^8 m/s', '3x10^6 m/s', '3x10^10 m/s', '3x10^5 m/s'], 'ans': 0, 'exp': 'c approx 3x10^8 m/s in vacuum.', 'emoji': '💡'},
      {'q': 'Unit of electric current?', 'opts': ['Ampere', 'Volt', 'Ohm', 'Watt'], 'ans': 0, 'exp': 'Current is measured in Amperes (A).', 'emoji': '⚡'},
      {'q': 'v = u + at. What is a?', 'opts': ['Acceleration', 'Area', 'Amplitude', 'Angle'], 'ans': 0, 'exp': 'In kinematic eq v=u+at, a is acceleration.', 'emoji': '🚀'},
      {'q': "Ohm's Law: V = ?", 'opts': ['IR', 'I/R', 'R/I', 'I^2R'], 'ans': 0, 'exp': 'Voltage = Current * Resistance (V = IR).', 'emoji': '🔋'},
      {'q': 'Unit of power?', 'opts': ['Watt', 'Joule', 'Newton', 'Pascal'], 'ans': 0, 'exp': 'Power is measured in Watts (W = J/s).', 'emoji': '💪'},
      {'q': 'What is g on Earth?', 'opts': ['9.8 m/s^2', '8.9 m/s^2', '10.8 m/s^2', '9.0 m/s^2'], 'ans': 0, 'exp': 'Standard gravitational acceleration g approx 9.8.', 'emoji': '🌍'},
      {'q': 'Kinetic Energy = ?', 'opts': ['1/2mv^2', 'mgh', 'mv', 'F*d'], 'ans': 0, 'exp': 'KE = 1/2mv^2 where m=mass, v=velocity.', 'emoji': '🏃'},
      {'q': 'Which is not a vector?', 'opts': ['Speed', 'Velocity', 'Force', 'Displacement'], 'ans': 0, 'exp': 'Speed is scalar (magnitude only). Others have direction.', 'emoji': '🧭'},
      {'q': 'Wavelength * frequency = ?', 'opts': ['Wave speed', 'Amplitude', 'Period', 'Energy'], 'ans': 0, 'exp': 'lambda * f = v (wave speed). Fundamental wave equation.', 'emoji': '🌊'},
      {'q': 'Unit of pressure?', 'opts': ['Pascal', 'Newton', 'Watt', 'Joule'], 'ans': 0, 'exp': 'Pressure is measured in Pascals (Pa = N/m^2).', 'emoji': '📏'},
      {'q': 'Transformer changes?', 'opts': ['Voltage', 'Current type', 'Power', 'Resistance'], 'ans': 0, 'exp': 'Transformer steps voltage up or down in AC circuits.', 'emoji': '🔌'},
      {'q': 'What does a resistor do?', 'opts': ['Opposes current', 'Stores energy', 'Amplifies signal', 'Emits light'], 'ans': 0, 'exp': 'A resistor opposes the flow of electric current.', 'emoji': '🔧'},
      {'q': 'Frequency of AC in India?', 'opts': ['50 Hz', '60 Hz', '40 Hz', '100 Hz'], 'ans': 0, 'exp': 'India uses 50 Hz AC frequency.', 'emoji': '🇮🇳'},
      {'q': 'Which mirror forms virtual image always?', 'opts': ['Convex', 'Concave', 'Plane', 'Both A & C'], 'ans': 0, 'exp': 'Convex mirror always forms virtual, erect, diminished images.', 'emoji': '🪞'},
      {'q': 'P = V^2/R. This is?', 'opts': ['Power formula', 'Ohm law', 'Watt law', 'KVL'], 'ans': 0, 'exp': 'P=V^2/R is derived from P=VI and V=IR.', 'emoji': '⚡'},
      {'q': "Action-reaction is Newton's?", 'opts': ['3rd Law', '1st Law', '2nd Law', '4th Law'], 'ans': 0, 'exp': '3rd Law: Every action has equal & opposite reaction.', 'emoji': '🤜'},
      {'q': 'Magnetic field SI unit?', 'opts': ['Tesla', 'Weber', 'Gauss', 'Henry'], 'ans': 0, 'exp': 'B field is measured in Tesla (T) in SI.', 'emoji': '🧲'},
      {'q': 'Sound cannot travel through?', 'opts': ['Vacuum', 'Water', 'Steel', 'Air'], 'ans': 0, 'exp': 'Sound needs a medium - it cannot travel through vacuum.', 'emoji': '🔇'},
      {'q': "Boyle's Law: P is inversely propl to?", 'opts': ['V', 'T', 'm', 'n'], 'ans': 0, 'exp': 'PV = constant (at const T). P varies 1/V.', 'emoji': '🫧'},
    ],
  };

  List<Map<String, dynamic>> _getQuestions(String subject) {
    final bank = _questionBank[subject] ?? _questionBank['Mathematics']!;
    final allQ = List<Map<String, dynamic>>.from(bank);
    allQ.shuffle();
    return allQ.take(_questionCount).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.subjects.isEmpty) {
      return const Center(child: Text('No subjects added yet.', style: TextStyle(color: Colors.white38)));
    }
    return Stack(children: [
      const AnimatedMeshBackground(),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 28),
              Text('Quiz Mode', style: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -1)),
              const SizedBox(height: 4),
              const Text('Test your knowledge subject-by-subject', style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 28),
              _buildLabel('Select Subject'),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.subjects.map((s) {
                    final sel = _selectedSubject == s;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedSubject = s),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: sel ? const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFC084FC)]) : null,
                          color: sel ? null : const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: sel ? Colors.transparent : Colors.white12, width: 1.5),
                          boxShadow: sel ? [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.4), blurRadius: 12)] : [],
                        ),
                        child: Text(s, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: sel ? Colors.white : Colors.white60)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              _buildLabel('Number of Questions'),
              const SizedBox(height: 10),
              Row(
                children: [5, 10, 15, 20].map((n) {
                  final sel = _questionCount == n;
                  return GestureDetector(
                    onTap: () => setState(() => _questionCount = n),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 12),
                      width: 60, height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: sel ? const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF6366F1), Color(0xFF2DD4BF)]) : null,
                        color: sel ? null : const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: sel ? Colors.transparent : Colors.white12, width: 1.5),
                        boxShadow: sel ? [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.5), blurRadius: 14)] : [],
                      ),
                      child: Text('$n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: sel ? Colors.white : Colors.white54)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              if (_selectedSubject != null)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    const Icon(LucideIcons.info, color: Color(0xFF6366F1), size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text( _selectedSubject! + ' : ' + _questionCount.toString() + ' questions\nExplanations shown for wrong answers', style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5))),
                  ]),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: _selectedSubject == null ? null : () {
                  final qs = _getQuestions(_selectedSubject!);
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => QuizScreen(
                    subject: _selectedSubject!,
                    questions: qs,
                    onComplete: widget.onQuizComplete,
                  )));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.white10,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(LucideIcons.zap, size: 18),
                  const SizedBox(width: 8),
                  Text('Start Quiz', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold)),
                ]),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _buildLabel(String text) => Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white70));
}

class QuizScreen extends StatefulWidget {
  final String subject;
  final List<Map<String, dynamic>> questions;
  final Function(Map<String, dynamic>) onComplete;
  const QuizScreen({super.key, required this.subject, required this.questions, required this.onComplete});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  int _current = 0;
  final List<int?> _answers = [];
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  static const List<Color> _optColors = [Color(0xFF6366F1), Color(0xFF2DD4BF), Color(0xFFF59E0B), Color(0xFFEC4899)];

  @override
  void initState() {
    super.initState();
    _answers.addAll(List<int?>.filled(widget.questions.length, null));
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _slideAnim = Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOut));
    _slideCtrl.forward();
  }

  @override
  void dispose() { _slideCtrl.dispose(); super.dispose(); }

  void _select(int opt) {
    if (_answers[_current] != null) return;
    setState(() => _answers[_current] = opt);
  }

  void _next() {
    if (_current < widget.questions.length - 1) {
      setState(() => _current++);
      _slideCtrl.reset();
      _slideCtrl.forward();
    } else {
      _finish();
    }
  }

  void _finish() {
    int score = 0;
    for (int i = 0; i < widget.questions.length; i++) {
      if (_answers[i] == widget.questions[i]['ans']) score++;
    }
    final result = {
      'subject': widget.subject,
      'score': score,
      'total': widget.questions.length,
      'date': DateTime.now().toIso8601String(),
      'questions': widget.questions,
      'answers': List<int?>.from(_answers),
    };
    widget.onComplete(result);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => QuizResultScreen(result: result),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.questions[_current];
    final opts = (q['opts'] as List).cast<String>();
    final ans = _answers[_current];
    final correct = q['ans'] as int;
    final progress = (_current + 1) / widget.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Stack(children: [
        const AnimatedMeshBackground(),
        SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LucideIcons.x, color: Colors.white54, size: 20)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF6366F1)),
                        minHeight: 6,
                      ),
                    ),
                  ),
                ),
                Text('${_current + 1}/${widget.questions.length}',
                    style: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.bold)),
              ]),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(widget.subject, style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Column(children: [
                        Text(q['emoji'] as String, style: const TextStyle(fontSize: 42)),
                        const SizedBox(height: 16),
                        Text(q['q'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700, height: 1.4)),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    ...opts.asMap().entries.map((e) {
                      final i = e.key; final label = e.value;
                      Color? bg; Color border = Colors.white12;
                      if (ans != null) {
                        if (i == correct) { bg = const Color(0xFF10B981).withOpacity(0.25); border = const Color(0xFF10B981); }
                        else if (i == ans && ans != correct) { bg = const Color(0xFFEF4444).withOpacity(0.25); border = const Color(0xFFEF4444); }
                      }
                      return GestureDetector(
                        onTap: () => _select(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: bg ?? const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: border, width: 1.5),
                          ),
                          child: Row(children: [
                            Container(
                              width: 32, height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ans == null ? _optColors[i].withOpacity(0.2) : (i == correct ? const Color(0xFF10B981).withOpacity(0.2) : (i == ans ? const Color(0xFFEF4444).withOpacity(0.2) : Colors.white10)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(String.fromCharCode(65 + i), style: TextStyle(fontWeight: FontWeight.bold, color: ans == null ? _optColors[i] : (i == correct ? const Color(0xFF10B981) : (i == ans ? const Color(0xFFEF4444) : Colors.white38)))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
                          ]),
                        ),
                      );
                    }),
                    if (ans != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (ans == correct ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(q['exp'] as String, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ),
                    ],
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: ElevatedButton(
                onPressed: ans == null ? null : _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: Text(_current == widget.questions.length - 1 ? 'See Results' : 'Next Question'),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class QuizResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  const QuizResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final int score = result['score'];
    final int total = result['total'];
    final pct = score / total;
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
           Text('Score: $score/$total', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
           const SizedBox(height: 20),
           ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Back')),
        ]),
      ),
    );
  }
}

class QuizReportTab extends StatelessWidget {
  final List<Map<String, dynamic>> quizHistory;
  const QuizReportTab({super.key, required this.quizHistory});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Quiz Reports (Under Construction)'));
  }
}
'@ -split "`r?`n"

$newLines = @()
for ($i = 0; $i -lt $lines.Count; $i++) {
    $ln = $i + 1
    if ($ln -eq 2614) {
        $newLines += $quizPart
        break # Exit loop as we've replaced everything from here to end
    } else {
        $newLines += $lines[$i]
    }
}

$newLines | Out-File -FilePath $file -Encoding UTF8
Write-Host "Quiz section fixed."
