$file = 'c:\Users\solin\Downloads\Hemanth_b_E309drGtPne-1773079189463\mobile_app\lib\main.dart'
$quiz = @'

// ═══════════════════════════════════════════════════════════════
//  QUIZ TAB
// ═══════════════════════════════════════════════════════════════

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
      {'q': 'What is the derivative of x²?', 'opts': ['2x', 'x²', '2', 'x'], 'ans': 0, 'exp': 'By power rule: d/dx(xⁿ) = nxⁿ⁻¹, so d/dx(x²) = 2x.', 'emoji': '📐'},
      {'q': 'What is ∫2x dx?', 'opts': ['x²+C', '2x²+C', 'x+C', '2+C'], 'ans': 0, 'exp': 'Integral of 2x: ∫2x dx = x² + C by reverse power rule.', 'emoji': '∫'},
      {'q': 'Solve: x² − 5x + 6 = 0', 'opts': ['x=2,3', 'x=1,6', 'x=−2,−3', 'x=3,4'], 'ans': 0, 'exp': 'Factor: (x−2)(x−3)=0, so x=2 or x=3.', 'emoji': '🔢'},
      {'q': 'What is sin(90°)?', 'opts': ['1', '0', '−1', '0.5'], 'ans': 0, 'exp': 'sin(90°) = 1 from the unit circle.', 'emoji': '📌'},
      {'q': 'log₂(8) = ?', 'opts': ['3', '4', '2', '8'], 'ans': 0, 'exp': '2³ = 8, so log₂(8) = 3.', 'emoji': '🔣'},
      {'q': 'Area of circle with r=7?', 'opts': ['154', '44', '49', '22'], 'ans': 0, 'exp': 'A = πr² = (22/7)×49 = 154.', 'emoji': '⭕'},
      {'q': 'Value of cos(0°)?', 'opts': ['1', '0', '−1', '∞'], 'ans': 0, 'exp': 'cos(0°) = 1 from unit circle definition.', 'emoji': '🌀'},
      {'q': 'What is 7! (7 factorial)?', 'opts': ['5040', '720', '40320', '210'], 'ans': 0, 'exp': '7! = 7×6×5×4×3×2×1 = 5040.', 'emoji': '❗'},
      {'q': 'If A={1,2} and B={2,3}, then A∩B?', 'opts': ['{2}', '{1,3}', '{1,2,3}', '{}'], 'ans': 0, 'exp': 'Intersection = elements in both sets = {2}.', 'emoji': '🔵'},
      {'q': 'tan(45°) = ?', 'opts': ['1', '0', '√2', '√3'], 'ans': 0, 'exp': 'tan(45°) = sin/cos = 1/1 = 1.', 'emoji': '📐'},
      {'q': 'Sum of angles in a triangle?', 'opts': ['180°', '360°', '90°', '270°'], 'ans': 0, 'exp': 'Sum of interior angles of any triangle = 180°.', 'emoji': '🔺'},
      {'q': 'What is the slope of y=3x+2?', 'opts': ['3', '2', '1/3', '−3'], 'ans': 0, 'exp': 'In y=mx+b, m is the slope. Here m=3.', 'emoji': '📈'},
      {'q': 'Probability of tossing heads?', 'opts': ['1/2', '1/4', '1', '0'], 'ans': 0, 'exp': 'Fair coin: P(H) = 1/2 = 0.5.', 'emoji': '🪙'},
      {'q': 'HCF of 12 and 18?', 'opts': ['6', '3', '9', '36'], 'ans': 0, 'exp': 'Factors: 12={1,2,3,4,6,12}, 18={1,2,3,6,9,18}. HCF=6.', 'emoji': '🔱'},
      {'q': 'What is 2⁸?', 'opts': ['256', '128', '512', '64'], 'ans': 0, 'exp': '2⁸ = 256.', 'emoji': '💻'},
      {'q': 'Pythagoras: a=3, b=4, c=?', 'opts': ['5', '6', '7', '4'], 'ans': 0, 'exp': 'c=√(a²+b²)=√(9+16)=√25=5.', 'emoji': '📐'},
      {'q': 'Arithmetic mean of 2,4,6,8,10?', 'opts': ['6', '5', '8', '4'], 'ans': 0, 'exp': 'Mean = (2+4+6+8+10)/5 = 30/5 = 6.', 'emoji': '📊'},
      {'q': 'How many sides does a hexagon have?', 'opts': ['6', '5', '7', '8'], 'ans': 0, 'exp': 'Hexa means 6. A hexagon has 6 sides.', 'emoji': '⬡'},
      {'q': 'What is √144?', 'opts': ['12', '14', '11', '13'], 'ans': 0, 'exp': '12 × 12 = 144, so √144 = 12.', 'emoji': '🔲'},
      {'q': 'LCM of 4 and 6?', 'opts': ['12', '6', '24', '8'], 'ans': 0, 'exp': 'LCM = smallest common multiple of 4 and 6 = 12.', 'emoji': '🔢'},
    ],
    'Physics': [
      {'q': 'Newton\'s 2nd Law: F = ?', 'opts': ['ma', 'mv', 'm/a', 'a/m'], 'ans': 0, 'exp': 'Force = mass × acceleration (F = ma).', 'emoji': '⚡'},
      {'q': 'Speed of light in vacuum?', 'opts': ['3×10⁸ m/s', '3×10⁶ m/s', '3×10¹⁰ m/s', '3×10⁵ m/s'], 'ans': 0, 'exp': 'c ≈ 3×10⁸ m/s in vacuum.', 'emoji': '💡'},
      {'q': 'Unit of electric current?', 'opts': ['Ampere', 'Volt', 'Ohm', 'Watt'], 'ans': 0, 'exp': 'Current is measured in Amperes (A).', 'emoji': '⚡'},
      {'q': 'v = u + at. What is \'a\'?', 'opts': ['Acceleration', 'Area', 'Amplitude', 'Angle'], 'ans': 0, 'exp': 'In kinematic eq v=u+at, a is acceleration.', 'emoji': '🚀'},
      {'q': 'Ohm\'s Law: V = ?', 'opts': ['IR', 'I/R', 'R/I', 'I²R'], 'ans': 0, 'exp': 'Voltage = Current × Resistance (V = IR).', 'emoji': '🔋'},
      {'q': 'Unit of power?', 'opts': ['Watt', 'Joule', 'Newton', 'Pascal'], 'ans': 0, 'exp': 'Power is measured in Watts (W = J/s).', 'emoji': '💪'},
      {'q': 'What is g on Earth?', 'opts': ['9.8 m/s²', '8.9 m/s²', '10.8 m/s²', '9.0 m/s²'], 'ans': 0, 'exp': 'Standard gravitational acceleration g ≈ 9.8 m/s².', 'emoji': '🌍'},
      {'q': 'Kinetic Energy = ?', 'opts': ['½mv²', 'mgh', 'mv', 'F×d'], 'ans': 0, 'exp': 'KE = ½mv² where m=mass, v=velocity.', 'emoji': '🏃'},
      {'q': 'Which is not a vector?', 'opts': ['Speed', 'Velocity', 'Force', 'Displacement'], 'ans': 0, 'exp': 'Speed is scalar (magnitude only). Others have direction.', 'emoji': '🧭'},
      {'q': 'Wavelength × frequency = ?', 'opts': ['Wave speed', 'Amplitude', 'Period', 'Energy'], 'ans': 0, 'exp': 'λ × f = v (wave speed). Fundamental wave equation.', 'emoji': '🌊'},
      {'q': 'Unit of pressure?', 'opts': ['Pascal', 'Newton', 'Watt', 'Joule'], 'ans': 0, 'exp': 'Pressure is measured in Pascals (Pa = N/m²).', 'emoji': '📏'},
      {'q': 'Transformer changes?', 'opts': ['Voltage', 'Current type', 'Power', 'Resistance'], 'ans': 0, 'exp': 'Transformer steps voltage up or down in AC circuits.', 'emoji': '🔌'},
      {'q': 'What does a resistor do?', 'opts': ['Opposes current', 'Stores energy', 'Amplifies signal', 'Emits light'], 'ans': 0, 'exp': 'A resistor opposes the flow of electric current.', 'emoji': '🔧'},
      {'q': 'Frequency of AC in India?', 'opts': ['50 Hz', '60 Hz', '40 Hz', '100 Hz'], 'ans': 0, 'exp': 'India uses 50 Hz AC frequency (unlike USA which is 60 Hz).', 'emoji': '🇮🇳'},
      {'q': 'Which mirror forms virtual image always?', 'opts': ['Convex', 'Concave', 'Plane', 'Both A&C'], 'ans': 0, 'exp': 'Convex mirror always forms virtual, erect, diminished images.', 'emoji': '🪞'},
      {'q': 'P = V²/R. This is?', 'opts': ['Power formula', 'Ohm\'s law', 'Watt\'s law', 'KVL'], 'ans': 0, 'exp': 'P=V²/R is derived from P=VI and V=IR.', 'emoji': '⚡'},
      {'q': 'Action-reaction is Newton\'s?', 'opts': ['3rd Law', '1st Law', '2nd Law', '4th Law'], 'ans': 0, 'exp': '3rd Law: Every action has equal & opposite reaction.', 'emoji': '🤜'},
      {'q': 'Magnetic field SI unit?', 'opts': ['Tesla', 'Weber', 'Gauss', 'Henry'], 'ans': 0, 'exp': 'B field is measured in Tesla (T) in SI.', 'emoji': '🧲'},
      {'q': 'Sound cannot travel through?', 'opts': ['Vacuum', 'Water', 'Steel', 'Air'], 'ans': 0, 'exp': 'Sound needs a medium – it cannot travel through vacuum.', 'emoji': '🔇'},
      {'q': 'Boyle\'s Law: P is inversely propl to?', 'opts': ['V', 'T', 'm', 'n'], 'ans': 0, 'exp': 'PV = constant (at const T). P ∝ 1/V.', 'emoji': '🫧'},
    ],
    'Chemistry': [
      {'q': 'Atomic number of Carbon?', 'opts': ['6', '12', '8', '4'], 'ans': 0, 'exp': 'Carbon has 6 protons, so atomic number = 6.', 'emoji': '⚗️'},
      {'q': 'H₂O is the formula for?', 'opts': ['Water', 'Hydrogen Peroxide', 'Oxygen', 'Acid'], 'ans': 0, 'exp': 'H₂O = 2 hydrogen atoms + 1 oxygen atom = water.', 'emoji': '💧'},
      {'q': 'pH of neutral water?', 'opts': ['7', '0', '14', '5'], 'ans': 0, 'exp': 'Neutral water has pH 7. Below 7 = acidic, above 7 = basic.', 'emoji': '🧪'},
      {'q': 'Valency of Oxygen?', 'opts': ['2', '1', '3', '4'], 'ans': 0, 'exp': 'Oxygen has 6 valence electrons, gains 2 more → valency 2.', 'emoji': '🌬️'},
      {'q': 'NaCl is?', 'opts': ['Common salt', 'Baking soda', 'Lime', 'Bleach'], 'ans': 0, 'exp': 'NaCl = Sodium Chloride = common table salt.', 'emoji': '🧂'},
      {'q': 'Avogadro\'s Number ≈ ?', 'opts': ['6.022×10²³', '6.022×10²⁰', '3.14×10²³', '1.6×10⁻¹⁹'], 'ans': 0, 'exp': 'One mole contains 6.022×10²³ particles.', 'emoji': '🔬'},
      {'q': 'Bonds formed by sharing electrons?', 'opts': ['Covalent', 'Ionic', 'Metallic', 'Hydrogen'], 'ans': 0, 'exp': 'Covalent bonds involve sharing of electron pairs.', 'emoji': '🤝'},
      {'q': 'Lightest element?', 'opts': ['Hydrogen', 'Helium', 'Lithium', 'Carbon'], 'ans': 0, 'exp': 'Hydrogen (H) is the lightest element with atomic mass 1.', 'emoji': '🎈'},
      {'q': 'Group 18 elements are called?', 'opts': ['Noble gases', 'Halogens', 'Alkali metals', 'Lanthanides'], 'ans': 0, 'exp': 'Group 18 = noble/inert gases (He, Ne, Ar, Kr, Xe, Rn).', 'emoji': '🌟'},
      {'q': 'Acid + Base = ?', 'opts': ['Salt + Water', 'Only Salt', 'Gas + Water', 'Oxide'], 'ans': 0, 'exp': 'Neutralisation: Acid + Base → Salt + Water.', 'emoji': '⚗️'},
      {'q': 'Symbol for Gold?', 'opts': ['Au', 'Go', 'Gd', 'Ag'], 'ans': 0, 'exp': 'Au from Latin "Aurum". Ag = Silver.', 'emoji': '🥇'},
      {'q': 'Rusting of iron involves?', 'opts': ['Oxidation', 'Reduction', 'Sublimation', 'Fusion'], 'ans': 0, 'exp': 'Iron reacts with O₂+H₂O → Fe₂O₃ (oxidation).', 'emoji': '🔴'},
      {'q': 'CO₂ in our atmosphere causes?', 'opts': ['Greenhouse effect', 'Ozone hole', 'Acid rain', 'Photosynthesis only'], 'ans': 0, 'exp': 'CO₂ traps heat → greenhouse effect → global warming.', 'emoji': '🌡️'},
      {'q': 'Physical state of mercury at room temp?', 'opts': ['Liquid', 'Solid', 'Gas', 'Plasma'], 'ans': 0, 'exp': 'Mercury is the only metal that is liquid at room temperature.', 'emoji': '🌡️'},
      {'q': 'Electrolysis of water gives?', 'opts': ['H₂ & O₂', 'H₂ only', 'O₂ only', 'H₂O₂'], 'ans': 0, 'exp': '2H₂O → 2H₂ + O₂ via electrolysis.', 'emoji': '⚡'},
      {'q': 'Hardest natural substance?', 'opts': ['Diamond', 'Quartz', 'Graphite', 'Iron'], 'ans': 0, 'exp': 'Diamond is the hardest naturally occurring substance.', 'emoji': '💎'},
      {'q': 'Baking soda formula?', 'opts': ['NaHCO₃', 'Na₂CO₃', 'NaCl', 'NaOH'], 'ans': 0, 'exp': 'Baking soda = Sodium Bicarbonate = NaHCO₃.', 'emoji': '🍞'},
      {'q': 'Ionic bonds form between?', 'opts': ['Metal & Non-metal', 'Two metals', 'Two non-metals', 'Noble gases'], 'ans': 0, 'exp': 'Ionic bonds = electron transfer between metal & non-metal.', 'emoji': '⚡'},
      {'q': 'Carbon\'s valency?', 'opts': ['4', '2', '1', '3'], 'ans': 0, 'exp': 'Carbon has 4 valence electrons → valency 4.', 'emoji': '🔗'},
      {'q': 'Photosynthesis equation product?', 'opts': ['Glucose+O₂', 'CO₂+H₂O', 'Starch only', 'Protein'], 'ans': 0, 'exp': '6CO₂ + 6H₂O + light → C₆H₁₂O₆ + 6O₂.', 'emoji': '🌿'},
    ],
    'English': [
      {'q': '"She __ to school daily." (go)', 'opts': ['goes', 'go', 'going', 'went'], 'ans': 0, 'exp': 'She (3rd person singular) → use "goes" in simple present.', 'emoji': '📖'},
      {'q': 'Opposite of "ancient"?', 'opts': ['Modern', 'Old', 'New', 'Historic'], 'ans': 0, 'exp': 'Ancient = very old. Antonym = Modern.', 'emoji': '🔄'},
      {'q': 'A word that describes a noun?', 'opts': ['Adjective', 'Adverb', 'Verb', 'Pronoun'], 'ans': 0, 'exp': 'Adjectives modify/describe nouns (e.g. "big", "red").', 'emoji': '🏷️'},
      {'q': 'Synonym of "Happy"?', 'opts': ['Joyful', 'Sad', 'Angry', 'Tired'], 'ans': 0, 'exp': 'Joyful means feeling great happiness – synonym of happy.', 'emoji': '😊'},
      {'q': '"She is singing." – Tense?', 'opts': ['Present Continuous', 'Simple Present', 'Past', 'Future'], 'ans': 0, 'exp': '"is + verb-ing" = Present Continuous tense.', 'emoji': '🎵'},
      {'q': 'Noun form of "educate"?', 'opts': ['Education', 'Educated', 'Educating', 'Educator'], 'ans': 0, 'exp': 'Education is the noun form of the verb educate.', 'emoji': '📚'},
      {'q': 'A word that modifies a verb?', 'opts': ['Adverb', 'Adjective', 'Noun', 'Preposition'], 'ans': 0, 'exp': 'Adverbs modify verbs (e.g. "quickly", "slowly").', 'emoji': '⚡'},
      {'q': 'Plural of "child"?', 'opts': ['Children', 'Childs', 'Childes', 'Childrens'], 'ans': 0, 'exp': 'Child is an irregular noun; plural = children.', 'emoji': '👶'},
      {'q': 'I __ the book yesterday. (read)', 'opts': ['read', 'reads', 'reading', 'readed'], 'ans': 0, 'exp': '"Read" is both past and present form (irregular). Pronounced "red" in past.', 'emoji': '📒'},
      {'q': 'What is a simile?', 'opts': ['Comparison using like/as', 'Direct comparison', 'Contradiction', 'Repetition'], 'ans': 0, 'exp': 'Simile = comparison using "like" or "as" (e.g. fast as lightning).', 'emoji': '🌟'},
      {'q': 'Passive of "He writes a letter"?', 'opts': ['A letter is written by him', 'Letter was written', 'He wrote letter', 'A letter has been written'], 'ans': 0, 'exp': 'Simple present passive: Object + is/are + V3 + by + subject.', 'emoji': '✉️'},
      {'q': 'Meaning of "eloquent"?', 'opts': ['Fluent & persuasive', 'Quiet', 'Rude', 'Confused'], 'ans': 0, 'exp': 'Eloquent means skilled at speaking clearly and effectively.', 'emoji': '🗣️'},
      {'q': '"Neither … nor …" is?', 'opts': ['Correlative conjunction', 'Preposition', 'Adjective', 'Adverb'], 'ans': 0, 'exp': 'Neither…nor is a correlative conjunction pair.', 'emoji': '🔗'},
      {'q': 'One who has retired from work?', 'opts': ['Retiree', 'Trainee', 'Employee', 'Volunteer'], 'ans': 0, 'exp': 'A retiree is a person who has retired.', 'emoji': '👴'},
      {'q': '"To kill two birds with one stone" means?', 'opts': ['Achieve two goals at once', 'Harm birds', 'Waste effort', 'Work very hard'], 'ans': 0, 'exp': 'Idiom: completing two tasks with a single action.', 'emoji': '🐦'},
      {'q': 'Which is a proper noun?', 'opts': ['Delhi', 'city', 'river', 'mountain'], 'ans': 0, 'exp': 'Delhi is a specific place name → proper noun (capitalised).', 'emoji': '🏙️'},
      {'q': 'Antonym of "genuine"?', 'opts': ['Fake', 'Real', 'True', 'Honest'], 'ans': 0, 'exp': 'Genuine = real/authentic. Antonym = fake.', 'emoji': '🎭'},
      {'q': '"Best" is the ___ form of good', 'opts': ['Superlative', 'Comparative', 'Positive', 'Negative'], 'ans': 0, 'exp': 'Good → Better → Best (positive, comparative, superlative).', 'emoji': '🏆'},
      {'q': 'What is an oxymoron?', 'opts': ['Contradictory words together', 'Word repetition', 'Sound imitation', 'Exaggeration'], 'ans': 0, 'exp': 'Oxymoron = contradictory terms combined (e.g. "living dead").', 'emoji': '☯️'},
      {'q': 'Article used before "hour"?', 'opts': ['An', 'A', 'The', 'No article'], 'ans': 0, 'exp': '"Hour" starts with silent H, vowel sound → use "an".', 'emoji': '🕐'},
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
              // Subject selector
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
              // Question count selector
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
              // Info card
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
                    Expanded(child: Text('$_questionCount questions from $_selectedSubject\nWrong answers will show explanations', style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5))),
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
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.white10,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ).copyWith(
                  backgroundColor: WidgetStateProperty.resolveWith((s) =>
                    s.contains(WidgetState.disabled) ? Colors.white10 : const Color(0xFF6366F1)),
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

// ═══════════════════════════════════════════════════════════════
//  QUIZ SCREEN (Animated Questions)
// ═══════════════════════════════════════════════════════════════

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
            // Header
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
            // Subject chip
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
            // Question card
            Expanded(
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    // Emoji + question
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                        boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.1), blurRadius: 20, spreadRadius: 2)],
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
                    // Options
                    ...opts.asMap().entries.map((e) {
                      final i = e.key; final label = e.value;
                      Color? bg; Color border = Colors.white12;
                      if (ans != null) {
                        if (i == correct) { bg = const Color(0xFF10B981).withOpacity(0.25); border = const Color(0xFF10B981); }
                        else if (i == ans && ans != correct) { bg = const Color(0xFFEF4444).withOpacity(0.25); border = const Color(0xFFEF4444); }
                      }
                      final optLabel = String.fromCharCode(65 + i); // A, B, C, D
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
                              child: Text(optLabel, style: TextStyle(fontWeight: FontWeight.bold, color: ans == null ? _optColors[i] : (i == correct ? const Color(0xFF10B981) : (i == ans ? const Color(0xFFEF4444) : Colors.white38)))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
                            if (ans != null && i == correct) const Icon(LucideIcons.checkCircle2, color: Color(0xFF10B981), size: 20),
                            if (ans != null && i == ans && ans != correct) const Icon(LucideIcons.xCircle, color: Color(0xFFEF4444), size: 20),
                          ]),
                        ),
                      );
                    }),
                    // Explanation
                    if (ans != null) ...[
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (ans == correct ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: (ans == correct ? const Color(0xFF10B981) : const Color(0xFFEF4444)).withOpacity(0.3)),
                        ),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Icon(ans == correct ? LucideIcons.lightbulb : LucideIcons.alertCircle,
                              color: ans == correct ? const Color(0xFF10B981) : const Color(0xFFEF4444), size: 18),
                          const SizedBox(width: 10),
                          Expanded(child: Text(q['exp'] as String,
                              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5))),
                        ]),
                      ),
                    ],
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
            ),
            // Next / Finish button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: ElevatedButton(
                onPressed: ans == null ? null : _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _current == widget.questions.length - 1 ? const Color(0xFF10B981) : const Color(0xFF6366F1),
                  disabledBackgroundColor: Colors.white10,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 8,
                ),
                child: Text(
                  _current == widget.questions.length - 1 ? 'See Results 🎉' : 'Next Question →',
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  QUIZ RESULT SCREEN
// ═══════════════════════════════════════════════════════════════

class QuizResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  const QuizResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final int score = result['score'];
    final int total = result['total'];
    final pct = score / total;
    final List<Map<String, dynamic>> questions = (result['questions'] as List).cast();
    final List<int?> answers = (result['answers'] as List).cast();
    final String subject = result['subject'];

    Color scoreColor = pct >= 0.8 ? const Color(0xFF10B981) : pct >= 0.5 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444);
    String badge = pct >= 0.8 ? '🏆 Excellent!' : pct >= 0.6 ? '🌟 Good Job!' : pct >= 0.4 ? '📚 Keep Practising' : '💪 Try Again!';

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Stack(children: [
        const AnimatedMeshBackground(),
        SafeArea(
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(children: [
                  // Score circle
                  Container(
                    width: 130, height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [scoreColor.withOpacity(0.2), scoreColor.withOpacity(0.05)]),
                      border: Border.all(color: scoreColor, width: 3),
                      boxShadow: [BoxShadow(color: scoreColor.withOpacity(0.4), blurRadius: 30)],
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('$score/$total', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: scoreColor)),
                      Text('${(pct * 100).toInt()}%', style: TextStyle(fontSize: 14, color: scoreColor.withOpacity(0.8))),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  Text(badge, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(subject, style: const TextStyle(color: Colors.white54, fontSize: 14)),
                  const SizedBox(height: 20),
                  // Stat bar chart
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.06))),
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        _statChip('Correct', '$score', const Color(0xFF10B981)),
                        _statChip('Wrong', '${total - score}', const Color(0xFFEF4444)),
                        _statChip('Total', '$total', const Color(0xFF6366F1)),
                      ]),
                      const SizedBox(height: 16),
                      // Beautiful bar chart
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _bar('Correct', score / total, const Color(0xFF10B981)),
                          const SizedBox(width: 20),
                          _bar('Wrong', (total - score) / total, const Color(0xFFEF4444)),
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  Text('Question Review', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                ]),
              ),
            ),
            // Per-question review
            SliverList(delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                final q = questions[i];
                final userAns = answers[i];
                final correctAns = q['ans'] as int;
                final isCorrect = userAns == correctAns;
                final opts = (q['opts'] as List).cast<String>();
                return Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: isCorrect ? const Color(0xFF10B981).withOpacity(0.3) : const Color(0xFFEF4444).withOpacity(0.3), width: 1.5),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Icon(isCorrect ? LucideIcons.checkCircle2 : LucideIcons.xCircle,
                          color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444), size: 18),
                      const SizedBox(width: 8),
                      Text('Q${i + 1}', style: TextStyle(fontWeight: FontWeight.bold, color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444), fontSize: 13)),
                    ]),
                    const SizedBox(height: 8),
                    Text(q['q'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, height: 1.4)),
                    const SizedBox(height: 8),
                    Text('✅ Correct: ${opts[correctAns]}',
                        style: const TextStyle(color: Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.w500)),
                    if (!isCorrect && userAns != null)
                      Text('❌ Your answer: ${opts[userAns]}',
                          style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13)),
                    const SizedBox(height: 6),
                    Text(q['exp'] as String, style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.5)),
                  ]),
                );
              },
              childCount: questions.length,
            )),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1), foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: Text('Back to Dashboard', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _statChip(String label, String value, Color color) => Column(children: [
    Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
    Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
  ]);

  Widget _bar(String label, double pct, Color color) => Column(children: [
    Container(
      width: 60, height: 90 * pct + 10,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color, color.withOpacity(0.4)]),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      alignment: Alignment.center,
      child: Text('${(pct * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
    ),
    const SizedBox(height: 6),
    Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
  ]);
}

// ═══════════════════════════════════════════════════════════════
//  QUIZ REPORT TAB
// ═══════════════════════════════════════════════════════════════

class QuizReportTab extends StatelessWidget {
  final List<Map<String, dynamic>> quizHistory;
  const QuizReportTab({super.key, required this.quizHistory});

  @override
  Widget build(BuildContext context) {
    if (quizHistory.isEmpty) {
      return Stack(children: [
        const AnimatedMeshBackground(),
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(LucideIcons.barChart2, size: 60, color: Colors.white24),
          const SizedBox(height: 16),
          Text('No quizzes yet!', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white54)),
          const SizedBox(height: 8),
          const Text('Take a quiz to see your performance here', style: TextStyle(color: Colors.white38, fontSize: 14)),
        ])),
      ]);
    }

    // Aggregate by subject
    final Map<String, List<double>> subjectScores = {};
    for (final h in quizHistory) {
      final sub = h['subject'] as String;
      final pct = (h['score'] as int) / (h['total'] as int) * 100;
      subjectScores.putIfAbsent(sub, () => []).add(pct);
    }

    return Stack(children: [
      const AnimatedMeshBackground(),
      SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            Text('Quiz Reports', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1)),
            const SizedBox(height: 4),
            Text('${quizHistory.length} quiz${quizHistory.length > 1 ? "zes" : ""} completed', style: const TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 24),
            // Bar graph per subject
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(22), border: Border.all(color: Colors.white.withOpacity(0.06))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Performance by Subject', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 20),
                ...subjectScores.entries.toList().asMap().entries.map((entry) {
                  final colors = [const Color(0xFF6366F1), const Color(0xFF2DD4BF), const Color(0xFFF59E0B), const Color(0xFFEC4899)];
                  final color = colors[entry.key % colors.length];
                  final sub = entry.value.key;
                  final scores = entry.value.value;
                  final avg = scores.reduce((a, b) => a + b) / scores.length;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(sub, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                        Text('${avg.toInt()}% avg', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                      ]),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: avg / 100,
                          minHeight: 12,
                          backgroundColor: Colors.white10,
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('${scores.length} attempt${scores.length > 1 ? "s" : ""}', style: const TextStyle(color: Colors.white38, fontSize: 10)),
                    ]),
                  );
                }),
              ]),
            ),
            const SizedBox(height: 20),
            // History list
            const Text('History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            ...quizHistory.reversed.toList().asMap().entries.map((entry) {
              final h = entry.value;
              final int score = h['score'];
              final int total = h['total'];
              final pct = score / total;
              final color = pct >= 0.8 ? const Color(0xFF10B981) : pct >= 0.5 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withOpacity(0.06))),
                child: Row(children: [
                  Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.15), border: Border.all(color: color, width: 2)),
                    alignment: Alignment.center,
                    child: Text('${(pct * 100).toInt()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(h['subject'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('$score / $total correct', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ])),
                  Icon(pct >= 0.6 ? LucideIcons.trendingUp : LucideIcons.trendingDown, color: color, size: 18),
                ]),
              );
            }),
          ],
        ),
      ),
    ]);
  }
}
'@

Add-Content -Path $file -Value $quiz -Encoding UTF8
Write-Host "QuizTab code appended. File size: $((Get-Item $file).Length) bytes"
