import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:ui';
import 'dart:math' as math;

void main() {
  runApp(const StudyTrackerApp());
}

class StudyTrackerApp extends StatelessWidget {
  const StudyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Study Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF020617), // Deepest Navy
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFFC084FC),
          tertiary: const Color(0xFF2DD4BF),
          surface: const Color(0xFF0F172A),
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      ),
      home: const AuthScreen(),
    );
  }
}

// --- Background Components ---

class AnimatedMeshBackground extends StatefulWidget {
  const AnimatedMeshBackground({super.key});

  @override
  State<AnimatedMeshBackground> createState() => _AnimatedMeshBackgroundState();
}

class _AnimatedMeshBackgroundState extends State<AnimatedMeshBackground> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: MeshPainter(_controller.value),
          child: Container(),
        );
      },
    );
  }
}

class MeshPainter extends CustomPainter {
  final double animationValue;
  MeshPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    
    // Base Gradient
    final paint1 = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          math.sin(animationValue * 2 * math.pi) * 0.5,
          math.cos(animationValue * 2 * math.pi) * 0.5 - 1.0,
        ),
        radius: 1.5,
        colors: [const Color(0xFF1E1B4B), const Color(0xFF020617)],
      ).createShader(rect);
    canvas.drawRect(rect, paint1);

    // Accent Blob 1
    final paint2 = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          math.cos(animationValue * 2 * math.pi) * 0.8,
          math.sin(animationValue * 2 * math.pi) * 0.8,
        ),
        radius: 1.0,
        colors: [const Color(0xFF6366F1).withOpacity(0.15), Colors.transparent],
      ).createShader(rect);
    canvas.drawRect(rect, paint2);

    // Accent Blob 2
    final paint3 = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          math.sin(animationValue * 2 * math.pi + math.pi) * 0.7,
          math.cos(animationValue * 2 * math.pi + math.pi) * 0.7,
        ),
        radius: 1.2,
        colors: [const Color(0xFFC084FC).withOpacity(0.12), Colors.transparent],
      ).createShader(rect);
    canvas.drawRect(rect, paint3);
  }

  @override
  bool shouldRepaint(covariant MeshPainter oldDelegate) => true;
}

// --- Auth Screen (Exact Web Look) ---

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MouseRegion(
        child: Stack(
          children: [
            const AnimatedMeshBackground(),
            
                          // Grid removed - was causing network crash

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Header Branding
                      FadeInDown(
                        duration: const Duration(milliseconds: 800),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                                    blurRadius: 30,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: const Icon(LucideIcons.graduationCap, size: 42, color: Colors.white),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Smart Study Tracker',
                              style: GoogleFonts.outfit(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Track your learning journey and achieve your goals',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white60, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),

                      // Auth Card with Glassmorphism and Spotlight
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: Stack(
                          children: [
                            // Card Border Glow
                            Container(
                              width: double.infinity,
                              height: isLogin ? 480 : 560,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                    Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                                  ],
                                ),
                              ),
                            ),
                            
                            // The Card
                            Padding(
                              padding: const EdgeInsets.all(1.5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.5),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                  child: Container(
                                    padding: const EdgeInsets.all(32),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F172A).withOpacity(0.85),
                                      borderRadius: BorderRadius.circular(30.5),
                                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          isLogin ? 'Welcome back' : 'Create account',
                                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          isLogin ? 'Sign in to continue your journey' : 'Start your professional tracking',
                                          style: const TextStyle(color: Colors.white54),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 32),
                                        if (!isLogin) ...[
                                          _InputField(label: 'Full Name', hint: 'John Doe', icon: LucideIcons.user),
                                          const SizedBox(height: 20),
                                        ],
                                        _InputField(label: 'Email Address', hint: 'you@example.com', icon: LucideIcons.mail),
                                        const SizedBox(height: 20),
                                        _InputField(label: 'Password', hint: '••••••••', icon: LucideIcons.lock, obscure: true),
                                        const SizedBox(height: 32),
                                        
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context, animation, second) => const OnboardingScreen(),
                                                transitionsBuilder: (context, animation, second, child) {
                                                  return FadeTransition(opacity: animation, child: child);
                                                },
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 18),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            elevation: 12,
                                            shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                          ),
                                          child: Text(
                                            isLogin ? 'Sign In' : 'Get Started',
                                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 24),
                                        
                                        TextButton(
                                          onPressed: () => setState(() => isLogin = !isLogin),
                                          child: Text(
                                            isLogin ? "Don't have an account? Sign up" : "Already have an account? Sign in",
                                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Onboarding Screen (New) ---

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Steps: 0=Category, 1=Dept(Engg)/Year(Inter), 2=University(Engg), 3=Sem(Engg)
  int step = 0;
  String? selectedCategory;
  String? selectedDept;        // for Engg: branch; for Inter: year
  String? selectedUniversity;  // Engg only
  String? selectedSem;         // Engg only

  final List<Map<String, dynamic>> categories = [
    {'title': 'Class 1 to 5',            'subtitle': 'Foundational Learning',      'icon': LucideIcons.baby},
    {'title': 'Class 6 to 10',           'subtitle': 'Secondary Education',        'icon': LucideIcons.bookOpen},
    {'title': 'Intermediate (Inter)',     'subtitle': '11th & 12th Standard',       'icon': LucideIcons.school},
    {'title': 'Engineering',             'subtitle': 'Technical & Professional',   'icon': LucideIcons.cpu},
    {'title': 'Other',                   'subtitle': 'Skill-based & Competitive',  'icon': LucideIcons.layoutGrid},
  ];

  final List<String> departments = [
    'Computer Science (CSE)',
    'Electronics (ECE)',
    'Mechanical (ME)',
    'Civil Engineering (CE)',
    'Information Technology (IT)',
  ];

  final List<Map<String,dynamic>> interYears = [
    {'title': '1st Year (11th)', 'subtitle': 'MPC / BiPC / CEC / MEC', 'icon': LucideIcons.bookMarked},
    {'title': '2nd Year (12th)', 'subtitle': 'Board Exam Preparation',   'icon': LucideIcons.award},
  ];

  // University-specific subject data: 'Univ_Branch_Sem' -> subjects
  final Map<String, List<String>> universitySubjects = {
    // VTU
    'VTU_Computer Science (CSE)_Sem 1': ['Engineering Maths I', 'Engineering Physics', 'Engineering Chemistry', 'C Programming', 'Workshop'],
    'VTU_Computer Science (CSE)_Sem 2': ['Engineering Maths II', 'Data Structures', 'Digital Logic', 'OOPs with Java', 'Environmental Science'],
    'VTU_Computer Science (CSE)_Sem 3': ['Data Structures & Algorithms', 'Discrete Math', 'Digital Logic Design', 'OOPs with C++', 'Computer Organisation'],
    'VTU_Computer Science (CSE)_Sem 4': ['Operating Systems', 'DBMS', 'Design & Analysis of Algorithms', 'Computer Networks', 'Microprocessors'],
    'VTU_Computer Science (CSE)_Sem 5': ['Software Engineering', 'Web Technologies', 'Computer Graphics', 'Automata Theory', 'Elective I'],
    'VTU_Computer Science (CSE)_Sem 6': ['Compiler Design', 'Artificial Intelligence', 'Cloud Computing', 'Machine Learning', 'Elective II'],
    'VTU_Computer Science (CSE)_Sem 7': ['Big Data Analytics', 'Cyber Security', 'Soft Computing', 'Project Phase I', 'Elective III'],
    'VTU_Computer Science (CSE)_Sem 8': ['Project Phase II', 'Seminar', 'Elective IV', 'Mobile Computing', 'Technical Writing'],
    'VTU_Electronics (ECE)_Sem 3': ['Network Theory', 'Electronic Devices & Circuits', 'Signals & Systems', 'Engineering Maths III', 'Field Theory'],
    'VTU_Electronics (ECE)_Sem 4': ['Analog Circuits', 'Digital Electronics', 'Microcontrollers', 'Control Systems', 'Communication Theory'],
    // JNTU
    'JNTU_Computer Science (CSE)_Sem 1': ['Engineering Maths I', 'Engineering Physics', 'C Programming', 'Environmental Studies', 'English'],
    'JNTU_Computer Science (CSE)_Sem 2': ['Engineering Maths II', 'Data Structures', 'Digital Logic', 'OOPs with Java', 'Constitution of India'],
    'JNTU_Computer Science (CSE)_Sem 3': ['Data Structures', 'Computer Organisation', 'OOPs with C++', 'Discrete Maths', 'Probability & Statistics'],
    'JNTU_Computer Science (CSE)_Sem 4': ['Operating Systems', 'DBMS', 'Formal Languages', 'Computer Networks', 'Software Engineering'],
    // Anna University
    'Anna University_Computer Science (CSE)_Sem 1': ['Matrices & Calculus', 'Engineering Physics', 'Engineering Chemistry', 'C Programming', 'English'],
    'Anna University_Computer Science (CSE)_Sem 3': ['Data Structures', 'Digital Principles', 'Computer Architecture', 'Discrete Maths', 'OOPs'],
    'Anna University_Computer Science (CSE)_Sem 4': ['DBMS', 'Operating Systems', 'Computer Networks', 'Theory of Computation', 'Microprocessors'],
    // Default fallback
    'default': ['Mathematics', 'Physics', 'Chemistry', 'English', 'Coding'],
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AnimatedMeshBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const SizedBox(height: 32),
                  Expanded(
                    child: step == 0
                        ? _buildCategoryList()
                        : step == 1 && selectedCategory == 'Engineering'
                            ? _buildDeptList()
                            : step == 1 && selectedCategory == 'Intermediate (Inter)'
                                ? _buildInterYearList()
                                : step == 2 && selectedCategory == 'Engineering'
                                    ? _buildUniversitySearch()
                                    : _buildSemList(),
                  ),
                  const SizedBox(height: 16),
                  _buildActionBar(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    String title = 'Personalize your\nlearning journey';
    String sub = 'Select your current education level to customize your path.';

    if (step == 1 && selectedCategory == 'Engineering') {
      title = 'Select your\nDepartment';
      sub = 'Choose your engineering branch to get relevant subjects.';
    } else if (step == 1 && selectedCategory == 'Intermediate (Inter)') {
      title = 'Select your\nYear';
      sub = 'Choose 1st Year (11th) or 2nd Year (12th).';
    } else if (step == 2 && selectedCategory == 'Engineering') {
      title = 'Your University';
      sub = 'Search your college/university to get accurate syllabus.';
    } else if (step == 3) {
      title = 'Choose your\nSemester';
      sub = 'Select current semester — ${selectedUniversity ?? ''} • $selectedDept.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInDown(
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 32, fontWeight: FontWeight.w800,
              height: 1.2, letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        FadeInDown(
          delay: const Duration(milliseconds: 200),
          child: Text(sub, style: const TextStyle(color: Colors.white60, fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = selectedCategory == cat['title'];
        return _buildSelectionItem(
          index: index,
          title: cat['title'],
          subtitle: cat['subtitle'],
          icon: cat['icon'],
          isSelected: isSelected,
          onTap: () {
            setState(() {
              selectedCategory = cat['title'];
            });
          },
        );
      },
    );
  }

  Widget _buildDeptList() {
    return ListView.builder(
      itemCount: departments.length,
      itemBuilder: (context, index) {
        final dept = departments[index];
        final isSelected = selectedDept == dept;
        return _buildSelectionItem(
          index: index,
          title: dept,
          subtitle: 'Engineering Branch',
          icon: LucideIcons.binary,
          isSelected: isSelected,
          onTap: () => setState(() => selectedDept = dept),
        );
      },
    );
  }

  Widget _buildInterYearList() {
    return ListView.builder(
      itemCount: interYears.length,
      itemBuilder: (context, index) {
        final yr = interYears[index];
        final isSelected = selectedDept == yr['title'];
        return _buildSelectionItem(
          index: index,
          title: yr['title'],
          subtitle: yr['subtitle'],
          icon: yr['icon'],
          isSelected: isSelected,
          onTap: () => setState(() => selectedDept = yr['title']),
        );
      },
    );
  }

  Widget _buildSemList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.5,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        final sem = 'Sem ${index + 1}';
        final isSelected = selectedSem == sem;
        return GestureDetector(
          onTap: () => setState(() => selectedSem = sem),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                  : const Color(0xFF0F172A).withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white10,
                width: 2,
              ),
            ),
            child: Text(sem,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.white70)),
          ),
        );
      },
    );
  }

  Widget _buildUniversitySearch() {
    final universities = [
      'Amrita Viswa Vidyapeetham',
      'VTU', 'JNTU Hyderabad', 'JNTU Kakinada', 'JNTU Anantapur',
      'Anna University', 'GTU', 'RGPV', 'Mumbai University',
      'Pune University (SPPU)', 'Osmania University', 'Bangalore University',
      'Calicut University', 'Kerala University', 'KTU', 'Madras University',
      'Andhra University', 'PTU', 'CU (Chandigarh University)',
      'LPU (Lovely Professional University)', 'SRM University',
      'Manipal University', 'BITS Pilani', 'NIT Warangal',
      'Vellore Institute of Technology (VIT)', 'Delhi University',
      'Jawaharlal Nehru University (JNU)', 'Hyderabad University', 'Other'
    ];
    return Column(
      children: [
        TextField(
          style: const TextStyle(fontSize: 15),
          onChanged: (q) => setState(() => selectedUniversity = q.isEmpty ? null : selectedUniversity),
          decoration: InputDecoration(
            hintText: 'Search university (e.g. VTU, JNTU…)',
            hintStyle: const TextStyle(color: Colors.white24),
            prefixIcon: const Icon(LucideIcons.search, size: 20, color: Color(0xFF6366F1)),
            filled: true,
            fillColor: const Color(0xFF0F172A),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: universities.length,
            itemBuilder: (context, idx) {
              final u = universities[idx];
              final isSelected = selectedUniversity == u;
              return _buildSelectionItem(
                index: idx,
                title: u,
                subtitle: 'Affiliated University',
                icon: LucideIcons.building2,
                isSelected: isSelected,
                onTap: () => setState(() => selectedUniversity = u),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionItem({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FadeInRight(
      delay: Duration(milliseconds: 100 * index),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
              : const Color(0xFF0F172A).withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? Theme.of(context).colorScheme.primary 
                    : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: isSelected ? Colors.white : Colors.white70, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
              if (isSelected) const Icon(LucideIcons.checkCircle2, color: Color(0xFF2DD4BF)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionBar() {
    bool canGoNext = false;
    if (step == 0 && selectedCategory != null) canGoNext = true;
    if (step == 1 && selectedDept != null) canGoNext = true;
    if (step == 2 && selectedCategory == 'Engineering' && selectedUniversity != null) canGoNext = true;
    if (step == 3 && selectedSem != null) canGoNext = true;
    // non-Engineering step 2 (sem) handled via _buildSemList – repurposed check:
    if (step == 2 && selectedCategory != 'Engineering' && selectedSem != null) canGoNext = true;

    String btnLabel = 'Complete Setup';
    if (step == 0 && (selectedCategory == 'Engineering' || selectedCategory == 'Intermediate (Inter)')) btnLabel = 'Next Step';
    if (step == 1 && selectedCategory == 'Engineering') btnLabel = 'Next Step';
    if (step == 2 && selectedCategory == 'Engineering') btnLabel = 'Next Step';

    return Row(
      children: [
        if (step > 0) ...[
          IconButton(
            onPressed: () => setState(() {
              step--;
              if (step == 0) { selectedDept = null; selectedUniversity = null; selectedSem = null; }
              if (step == 1) { selectedUniversity = null; selectedSem = null; }
              if (step == 2) { selectedSem = null; }
            }),
            icon: const Icon(LucideIcons.arrowLeft, color: Colors.white70),
            padding: const EdgeInsets.all(16),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: FadeInUp(
            child: ElevatedButton(
              onPressed: !canGoNext ? null : () {
                if (step == 0 && (selectedCategory == 'Engineering' || selectedCategory == 'Intermediate (Inter)')) {
                  setState(() => step = 1);
                } else if (step == 1 && selectedCategory == 'Engineering') {
                  setState(() => step = 2); // go to university
                } else if (step == 2 && selectedCategory == 'Engineering') {
                  setState(() => step = 3); // go to semester
                } else {
                  _showSubjectsPreview();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.white10,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 8,
              ),
              child: Text(btnLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }

  void _showSubjectsPreview() {
    final Map<String, List<String>> subjectsData = {
      '1st Year (11th)': ['Mathematics', 'Physics', 'Chemistry', 'English', 'Telugu / Hindi'],
      '2nd Year (12th)': ['Mathematics', 'Physics', 'Chemistry', 'English', 'Telugu / Hindi', 'IPE Practicals'],
      'Class 1 to 5':  ['English', 'Mathematics', 'Environmental Science', 'Hindi / Telugu'],
      'Class 6 to 10': ['Mathematics', 'Physics', 'Chemistry', 'Biology', 'Social Studies', 'English', 'Hindi'],
      'default': ['Mathematics', 'Physics', 'Chemistry', 'English', 'Coding'],
    };

    List<String> suggested;
    if (selectedCategory == 'Engineering') {
      final uniKey = '${selectedUniversity}_${selectedDept}_$selectedSem';
      suggested = universitySubjects[uniKey] ?? universitySubjects['default']!;
    } else if (selectedCategory == 'Intermediate (Inter)') {
      suggested = subjectsData[selectedDept ?? ''] ?? subjectsData['default']!;
    } else {
      suggested = subjectsData[selectedCategory ?? ''] ?? subjectsData['default']!;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectPickerScreen(
          suggested: suggested,
          category: selectedCategory ?? '',
          dept: selectedDept,
          sem: selectedSem,
          university: selectedUniversity,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Subject Picker Screen
// ──────────────────────────────────────────────

class SubjectPickerScreen extends StatefulWidget {
  final List<String> suggested;
  final String category;
  final String? dept;
  final String? sem;
  final String? university;

  const SubjectPickerScreen({
    super.key,
    required this.suggested,
    required this.category,
    this.dept,
    this.sem,
    this.university,
  });

  @override
  State<SubjectPickerScreen> createState() => _SubjectPickerScreenState();
}

class _SubjectPickerScreenState extends State<SubjectPickerScreen> {
  late List<String> _added;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  // Comprehensive master subject list covering ALL engineering branches + school
  final List<String> _allSubjects = [
    // ─── School ───────────────────────────────────────────────────────
    'Mathematics', 'Physics', 'Chemistry', 'Biology', 'English',
    'Social Studies', 'History', 'Geography', 'Civics', 'Economics',
    'Hindi', 'Kannada', 'Telugu', 'Tamil', 'Sanskrit', 'Computer Science', 'Coding',
    'Environmental Science', 'Moral Science', 'Physical Education',

    // ─── Common Engineering (1st & 2nd Year) ─────────────────────────
    'Engineering Mathematics I', 'Engineering Mathematics II',
    'Engineering Mathematics III', 'Engineering Mathematics IV',
    'Engineering Physics', 'Engineering Chemistry',
    'Engineering Graphics', 'Engineering Mechanics',
    'Basic Electrical Engineering', 'Basic Electronics',
    'C Programming', 'Workshop Practice', 'Environmental Studies',
    'Constitution of India', 'Professional Ethics', 'Technical English',
    'Communication Skills', 'Universal Human Values',

    // ─── CSE / IT ─────────────────────────────────────────────────────
    'Data Structures', 'Data Structures & Algorithms', 'Algorithms',
    'Design & Analysis of Algorithms', 'Operating Systems',
    'Database Management Systems (DBMS)', 'Computer Networks',
    'Software Engineering', 'OOPs with Java', 'OOPs with C++',
    'Python Programming', 'Web Technologies', 'Internet of Things (IoT)',
    'Discrete Mathematics', 'Digital Logic Design', 'Computer Organisation',
    'Computer Architecture', 'Microprocessors', 'Automata Theory',
    'Compiler Design', 'Machine Learning', 'Artificial Intelligence',
    'Deep Learning', 'Natural Language Processing (NLP)',
    'Cloud Computing', 'Big Data Analytics', 'Data Mining',
    'Cyber Security', 'Cryptography & Network Security',
    'Mobile Computing', 'Mobile Application Development',
    'Distributed Systems', 'Parallel Computing',
    'Software Testing', 'Agile Development',
    'Computer Graphics', 'Image Processing',
    'Blockchain Technology', 'DevOps',
    'Full Stack Development', 'React JS', 'Node JS', 'Angular JS',

    // ─── ECE ──────────────────────────────────────────────────────────
    'Electronic Devices & Circuits', 'Electronic Devices',
    'Signals & Systems', 'Network Theory', 'Network Analysis',
    'Electromagnetic Theory', 'Electromagnetic Fields',
    'Digital Signal Processing (DSP)', 'VLSI Design',
    'Analog Circuits', 'Analog Communication',
    'Digital Communication', 'Communication Systems',
    'Wireless Communication', 'Optical Fiber Communication',
    'Antenna & Wave Propagation', 'Microwave Engineering',
    'Control Systems', 'Linear Integrated Circuits',
    'Embedded Systems', 'ARM Microcontrollers',
    'Digital Electronics', 'RF Circuit Design',
    'Radar & Navigation Systems', 'Satellite Communication',

    // ─── EEE (Electrical & Electronics) ──────────────────────────────
    'Electrical Circuit Analysis', 'Electrical Machines I', 'Electrical Machines II',
    'Power Systems I', 'Power Systems II', 'Power Electronics',
    'Switchgear & Protection', 'High Voltage Engineering',
    'Electric Drives', 'Industrial Drives',
    'Power System Analysis', 'Control Engineering',
    'Generation Transmission & Distribution',
    'Special Electrical Machines', 'Utilization of Electrical Energy',
    'Renewable Energy Systems', 'Smart Grid Technology',
    'Programmable Logic Controllers (PLC)',
    'Instrumentation & Measurements',

    // ─── Mechanical Engineering (ME) ──────────────────────────────────
    'Thermodynamics', 'Fluid Mechanics', 'Heat Transfer',
    'Strength of Materials', 'Manufacturing Processes',
    'Machine Design', 'Kinematics of Machinery', 'Dynamics of Machinery',
    'Theory of Machines', 'Industrial Engineering',
    'CAD/CAM', 'Finite Element Analysis (FEA)',
    'Automobile Engineering', 'Robotics', 'Mechatronics',
    'Refrigeration & Air Conditioning', 'Turbo Machinery',
    'Operations Research', 'Production Engineering',
    'Metrology & Quality Control', 'Casting & Welding',

    // ─── Civil Engineering (CE) ───────────────────────────────────────
    'Structural Analysis', 'Reinforced Cement Concrete (RCC)',
    'Soil Mechanics', 'Foundation Engineering',
    'Hydraulics & Fluid Mechanics', 'Water Resources Engineering',
    'Transportation Engineering', 'Highway Engineering',
    'Surveying', 'Remote Sensing & GIS',
    'Environmental Engineering', 'Water Supply Engineering',
    'Construction Management', 'Estimating & Costing',
    'Urban Planning', 'Bridge Engineering', 'Steel Structures',

    // ─── Chemical Engineering (ChE) ───────────────────────────────────
    'Chemical Reaction Engineering', 'Mass Transfer Operations',
    'Heat & Mass Transfer', 'Fluid Flow Operations',
    'Process Control & Instrumentation', 'Chemical Technology',
    'Petroleum Refining', 'Polymer Engineering',
    'Biochemical Engineering',

    // ─── Biotechnology / Biomedical ───────────────────────────────────
    'Biochemistry', 'Microbiology', 'Genetic Engineering',
    'Cell Biology', 'Molecular Biology',
    'Bioprocess Engineering', 'Immunology',
    'Medical Electronics', 'Bioinformatics',

    // ─── MBA / Management ─────────────────────────────────────────────
    'Principles of Management', 'Marketing Management',
    'Financial Management', 'Human Resource Management',
    'Operations Management', 'Business Law',
    'Entrepreneurship Development', 'Strategic Management',
    'Accounting & Finance', 'Organizational Behaviour',
  ];

  @override
  void initState() {
    super.initState();
    _added = []; // Start empty — user adds subjects manually via search
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text.trim()));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<String> get _filtered {
    if (_query.isEmpty) return [];
    return _allSubjects
        .where((s) => s.toLowerCase().contains(_query.toLowerCase()) && !_added.contains(s))
        .toList();
  }

  void _add(String subject) {
    if (!_added.contains(subject)) {
      setState(() {
        _added.add(subject);
        _searchCtrl.clear();
      });
    }
  }

  void _remove(String subject) => setState(() => _added.remove(subject));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Stack(
        children: [
          const AnimatedMeshBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Your Subjects',
                        style: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -1),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.university != null
                            ? '${widget.university} • ${widget.sem} • ${widget.dept}'
                            : widget.sem != null
                                ? 'Customise subjects for ${widget.sem} • ${widget.dept}'
                                : 'Search and add subjects for your class',
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _searchCtrl,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'Search subjects (e.g. Data Structures)…',
                      hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
                      prefixIcon: const Icon(LucideIcons.search, size: 20, color: Color(0xFF6366F1)),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(LucideIcons.x, size: 16, color: Colors.white38),
                              onPressed: () => _searchCtrl.clear(),
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Search Results Dropdown
                if (_filtered.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _filtered.length,
                        itemBuilder: (context, idx) {
                          final sub = _filtered[idx];
                          return ListTile(
                            title: Text(sub, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            trailing: const Icon(LucideIcons.plus, color: Color(0xFF6366F1), size: 18),
                            onTap: () => _add(sub),
                          );
                        },
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Added chips label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Subjects (${_added.length})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text('Tap ✕ to remove', style: TextStyle(color: Colors.white38, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Added subjects list
                Expanded(
                  child: _added.isEmpty
                      ? const Center(
                          child: Text('No subjects added yet.\nSearch above to add!',
                              textAlign: TextAlign.center, style: TextStyle(color: Colors.white38)),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _added.length,
                          itemBuilder: (context, idx) {
                            final sub = _added[idx];
                            return FadeInLeft(
                              delay: Duration(milliseconds: 60 * idx),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(LucideIcons.checkCircle, color: Color(0xFF2DD4BF), size: 20),
                                    const SizedBox(width: 16),
                                    Expanded(child: Text(sub, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
                                    GestureDetector(
                                      onTap: () => _remove(sub),
                                      child: const Icon(LucideIcons.x, color: Colors.white38, size: 18),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Continue Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  child: ElevatedButton(
                    onPressed: _added.isEmpty ? null : () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardScreen(
                            category: widget.category,
                            subjects: _added,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.white10,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 8,
                    ),
                    child: const Text('Continue to Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;

  const _InputField({required this.label, required this.hint, required this.icon, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70)),
        const SizedBox(height: 10),
        TextField(
          obscureText: obscure,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            prefixIcon: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary.withOpacity(0.7)),
            filled: true,
            fillColor: Colors.black.withOpacity(0.3),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// --- Dashboard (Premium Mobile View) ---

class DashboardScreen extends StatefulWidget {
  final String category;
  final List<String> subjects;

  const DashboardScreen({super.key, required this.category, required this.subjects});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.white38,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.layoutDashboard, size: 20), label: 'HOME'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.calendarDays, size: 20), label: 'PLANNER'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.graduationCap, size: 20), label: 'QUIZ'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.barChart2, size: 20), label: 'REPORTS'),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeTab(category: widget.category, subjects: widget.subjects),
          const StudyPlannerTab(),
          const Center(child: Text('AI Quiz Mode')),
          const Center(child: Text('Detailed Reports')),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final String category;
  final List<String> subjects;

  const HomeTab({super.key, required this.category, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          pinned: true,
          backgroundColor: const Color(0xFF020617),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
            title: Text('Dashboard', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.05),
                child: IconButton(onPressed: () {}, icon: const Icon(LucideIcons.bell, size: 18, color: Colors.white)),
              ),
            )
          ],
        ),
        
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Top Stats Grid
              Row(
                children: [
                  Expanded(child: _MiniStat(icon: LucideIcons.timer, value: '0h 0m', label: 'Today', color: Colors.blue)),
                  const SizedBox(width: 12),
                  Expanded(child: _MiniStat(icon: LucideIcons.flame, value: '0 days', label: 'Streak', color: Colors.orange)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _MiniStat(icon: LucideIcons.target, value: '0%', label: 'Goal', color: Colors.green)),
                  const SizedBox(width: 12),
                  Expanded(child: _MiniStat(icon: LucideIcons.book, value: '${subjects.length}', label: 'Subjects', color: Colors.purple)),
                ],
              ),

              const SizedBox(height: 24),

              // Daily Study Goal
              _SectionHeader(title: 'Daily Study Goal', subtitle: '0 of 120 minutes completed'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    LinearPercentIndicator(
                      lineHeight: 6.0,
                      percent: 0.05,
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      progressColor: Theme.of(context).colorScheme.primary,
                      barRadius: const Radius.circular(10),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0 min', style: TextStyle(color: Colors.white38, fontSize: 12)),
                        Text('120 min', style: TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Subject Strength (Dynamic based on onboarding)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subject Strength', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const Text('Take Quiz >', style: TextStyle(fontSize: 12))),
                ],
              ),
              const SizedBox(height: 4),
              const Text('Based on your quiz performance', style: TextStyle(color: Colors.white38, fontSize: 13)),
              const SizedBox(height: 16),
              ...subjects.map((sub) => _SubjectStrengthRow(title: sub)),

              const SizedBox(height: 32),

              // Advanced Study Toolkit
              const Text('Advanced Study Toolkit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _ToolCard(icon: LucideIcons.brainCircuit, label: 'DOUBT SOLVER', color: Colors.indigo),
                  _ToolCard(icon: LucideIcons.layers, label: 'FLASHCARDS', color: Colors.orange),
                  _ToolCard(icon: LucideIcons.map, label: 'GUIDANCE', color: Colors.green),
                  _ToolCard(icon: LucideIcons.database, label: 'RESOURCES', color: Colors.blue),
                ],
              ),
              
              const SizedBox(height: 40),
            ]),
          ),
        )
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 13)),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MiniStat({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubjectStrengthRow extends StatelessWidget {
  final String title;
  const _SubjectStrengthRow({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const Text('0% - Weak', style: TextStyle(color: Colors.redAccent, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            lineHeight: 4.0,
            percent: 0.05,
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white.withOpacity(0.05),
            progressColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            barRadius: const Radius.circular(10),
          ),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ToolCard({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        ],
      ),
    );
  }
}

class AICoachTab extends StatelessWidget {
  const AICoachTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        title: const Text('AI Study Coach', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: const [
                _ChatBubble(text: "Hi Hemanth! What are we studying today?", isMe: false),
                _ChatBubble(text: "I need help with React lifecycle methods.", isMe: true),
                _ChatBubble(text: "React lifecycle can be understood in three phases: Mounting, Updating, and Unmounting. Should we start with Mounting?", isMe: false),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your question...',
                      hintStyle: const TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(LucideIcons.send, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  const _ChatBubble({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF6366F1) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(24),
            topRight: const Radius.circular(24),
            bottomLeft: Radius.circular(isMe ? 24 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 24),
          ),
          boxShadow: [
            if (isMe) BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Text(text, style: const TextStyle(fontSize: 15, height: 1.4)),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Study Planner Tab  (mirrors web Study Planner exactly)
// ──────────────────────────────────────────────────────────────────────────────

class StudyPlannerTab extends StatefulWidget {
  const StudyPlannerTab({super.key});

  @override
  State<StudyPlannerTab> createState() => _StudyPlannerTabState();
}

class _StudyPlannerTabState extends State<StudyPlannerTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  // Setup form state
  final _subjectCtrl = TextEditingController();
  DateTime? _examDate;
  double _difficulty = 5;
  double _studyHours = 4;
  double _breakLength = 15;
  String _studyTime = 'Morning';

  // Added subjects
  final List<Map<String, dynamic>> _planSubjects = [];

  bool _generated = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _subjectCtrl.dispose();
    super.dispose();
  }

  void _addSubject() {
    if (_subjectCtrl.text.trim().isEmpty || _examDate == null) return;
    setState(() {
      _planSubjects.add({
        'name': _subjectCtrl.text.trim(),
        'date': _examDate!,
        'difficulty': _difficulty,
      });
      _subjectCtrl.clear();
      _examDate = null;
      _difficulty = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Study Planner',
                          style: GoogleFonts.outfit(
                              fontSize: 26, fontWeight: FontWeight.w800)),
                      const SizedBox(width: 10),
                      const Text('📅', style: TextStyle(fontSize: 22)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'AI-powered study timetable generator based on your exams and schedule.',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Tabs ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabCtrl,
                  padding: const EdgeInsets.all(4),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: const Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white38,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Setup'),
                    Tab(text: 'Timetable'),
                    Tab(text: 'Progress'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Tab Views ────────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _buildSetupTab(),
                  _buildTimetableTab(),
                  _buildProgressTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Setup Tab ─────────────────────────────────────────────────────────────
  Widget _buildSetupTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Add Subjects Card
          _PlannerCard(
            title: 'Add Subjects',
            subtitle: 'Enter the subjects you need to study for.',
            child: Column(
              children: [
                // Subject Name
                TextField(
                  controller: _subjectCtrl,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Subject Name',
                    hintText: 'e.g. Mathematics',
                    hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                    labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.04),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Exam Date
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 7)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (ctx, child) => Theme(
                        data: Theme.of(ctx).copyWith(
                          colorScheme: const ColorScheme.dark(primary: Color(0xFF6366F1)),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) setState(() => _examDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF6366F1)),
                        const SizedBox(width: 12),
                        Text(
                          _examDate == null
                              ? 'Exam Date (tap to pick)'
                              : 'Exam: ${_examDate!.day}/${_examDate!.month}/${_examDate!.year}',
                          style: TextStyle(
                            color: _examDate == null ? Colors.white24 : Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Difficulty slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Difficulty Level', style: TextStyle(fontSize: 13, color: Colors.white70)),
                    Text('${_difficulty.toInt()}/10',
                        style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                Slider(
                  value: _difficulty,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  activeColor: const Color(0xFF6366F1),
                  inactiveColor: Colors.white10,
                  onChanged: (v) => setState(() => _difficulty = v),
                ),
                const SizedBox(height: 12),

                // Added subjects list
                if (_planSubjects.isNotEmpty) ...[
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 8),
                  ..._planSubjects.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.checkCircle, color: Color(0xFF2DD4BF), size: 16),
                        const SizedBox(width: 10),
                        Expanded(child: Text(s['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
                        Text(
                          '${(s['date'] as DateTime).day}/${(s['date'] as DateTime).month}',
                          style: const TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => setState(() => _planSubjects.remove(s)),
                          child: const Icon(LucideIcons.x, size: 14, color: Colors.white38),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 8),
                ],

                // Add Subject button
                ElevatedButton.icon(
                  onPressed: _addSubject,
                  icon: const Icon(LucideIcons.plus, size: 16),
                  label: const Text('Add Subject'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Study Preferences Card
          _PlannerCard(
            title: 'Study Preferences',
            subtitle: 'Tell us how you prefer to study.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Study Hours
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Available Study Hours / Day', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text('How much time can you dedicate daily?', style: TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                    Text('${_studyHours.toInt()}h',
                        style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _studyHours,
                  min: 1,
                  max: 12,
                  divisions: 11,
                  activeColor: const Color(0xFF6366F1),
                  inactiveColor: Colors.white10,
                  onChanged: (v) => setState(() => _studyHours = v),
                ),

                const SizedBox(height: 12),
                const Text('Preferred Study Time', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),

                // Time selector
                Row(
                  children: ['Morning', 'Afternoon', 'Evening', 'Night'].map((t) {
                    final icons = {
                      'Morning': LucideIcons.sunrise,
                      'Afternoon': LucideIcons.sun,
                      'Evening': LucideIcons.sunset,
                      'Night': LucideIcons.moon,
                    };
                    final isSelected = _studyTime == t;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _studyTime = t),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF6366F1).withOpacity(0.2) : Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF6366F1) : Colors.white.withOpacity(0.06),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(icons[t]!, size: 16, color: isSelected ? const Color(0xFF6366F1) : Colors.white38),
                              const SizedBox(height: 4),
                              Text(t, style: TextStyle(fontSize: 9, color: isSelected ? Colors.white : Colors.white38, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Break Length
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Break Length', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text('After every 45 min focus session.', style: TextStyle(color: Colors.white38, fontSize: 11)),
                      ],
                    ),
                    Text('${_breakLength.toInt()}m',
                        style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider(
                  value: _breakLength,
                  min: 5,
                  max: 30,
                  divisions: 5,
                  activeColor: const Color(0xFF6366F1),
                  inactiveColor: Colors.white10,
                  onChanged: (v) => setState(() => _breakLength = v),
                ),

                const SizedBox(height: 12),

                // Generate button
                ElevatedButton.icon(
                  onPressed: _planSubjects.isEmpty ? null : () {
                    setState(() => _generated = true);
                    _tabCtrl.animateTo(1);
                  },
                  icon: const Icon(LucideIcons.sparkles, size: 16),
                  label: const Text('Generate AI Study Plan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.white10,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Color palette for subjects
  static const List<Color> _subjectColors = [
    Color(0xFF6366F1), // indigo
    Color(0xFF2DD4BF), // teal
    Color(0xFFF59E0B), // amber
    Color(0xFFEC4899), // pink
    Color(0xFF10B981), // emerald
    Color(0xFF8B5CF6), // violet
    Color(0xFFEF4444), // red
    Color(0xFF3B82F6), // blue
  ];

  // Tracks which timetable slots are marked done: 'dayIdx_slotIdx' -> bool
  final Map<String, bool> _doneSessions = {};

  // Completed session counts per subject name
  Map<String, int> get _completedPerSubject {
    final Map<String, int> counts = {};
    for (final key in _doneSessions.keys) {
      if (_doneSessions[key] == true) {
        final parts = key.split('_');
        final dayIdx = int.parse(parts[0]);
        final subIdx = _planSubjects.isNotEmpty ? dayIdx % _planSubjects.length : 0;
        if (subIdx < _planSubjects.length) {
          final name = _planSubjects[subIdx]['name'] as String;
          counts[name] = (counts[name] ?? 0) + 1;
        }
      }
    }
    return counts;
  }

  // Total sessions per subject across the week
  int _totalSessionsFor(String name) {
    int count = 0;
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (var i = 0; i < days.length; i++) {
      if (_planSubjects.isNotEmpty &&
          (_planSubjects[i % _planSubjects.length]['name'] as String) == name) {
        count++;
      }
    }
    return count == 0 ? 1 : count;
  }

  // ── PDF generation ─────────────────────────────────────────────────────────
  Future<void> _downloadPdf() async {
    final doc = pw.Document();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (ctx) => [
          pw.Header(
            level: 0,
            child: pw.Text('Study Timetable',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Generated by Study Tracker • ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo100),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.all(8),
            cellStyle: const pw.TextStyle(fontSize: 10),
            headers: ['Day', 'Subject', 'Study Hours', 'Break', 'Preferred Time', 'Status'],
            data: List.generate(days.length, (i) {
              final sub = _planSubjects[i % _planSubjects.length];
              final isDone = _doneSessions['${i}_0'] == true;
              return [
                days[i],
                sub['name'] as String,
                '${_studyHours.toInt()}h',
                '${_breakLength.toInt()}m',
                _studyTime,
                isDone ? '✓ Done' : 'Pending',
              ];
            }),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Subject Overview', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          ..._planSubjects.map((s) {
            final name = s['name'] as String;
            final done = _completedPerSubject[name] ?? 0;
            final total = _totalSessionsFor(name);
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 6),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(name, style: const pw.TextStyle(fontSize: 11)),
                  pw.Text('$done/$total sessions completed',
                      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                ],
              ),
            );
          }),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (_) async => doc.save());
  }

  // ── Timetable Tab ─────────────────────────────────────────────────────────
  Widget _buildTimetableTab() {
    if (!_generated || _planSubjects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.calendarDays, size: 48, color: Colors.white24),
            const SizedBox(height: 16),
            const Text('No plan generated yet.', style: TextStyle(color: Colors.white54, fontSize: 16)),
            const SizedBox(height: 8),
            const Text('Add subjects and tap\n"Generate AI Study Plan"',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.white24, fontSize: 13)),
          ],
        ),
      );
    }

    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final shortDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return Column(
      children: [
        // Download PDF button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: ElevatedButton.icon(
            onPressed: _downloadPdf,
            icon: const Icon(LucideIcons.download, size: 16),
            label: const Text('Download Timetable PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 6,
            ),
          ),
        ),

        // Timetable list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: days.length,
            itemBuilder: (context, dayIdx) {
              final subjectIdx = dayIdx % _planSubjects.length;
              final sub = _planSubjects[subjectIdx];
              final color = _subjectColors[subjectIdx % _subjectColors.length];
              final isDone = _doneSessions['${dayIdx}_0'] == true;

              return FadeInLeft(
                delay: Duration(milliseconds: 60 * dayIdx),
                child: GestureDetector(
                  onTap: () => setState(() {
                    _doneSessions['${dayIdx}_0'] = !isDone;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDone ? color.withOpacity(0.15) : const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDone ? color.withOpacity(0.6) : color.withOpacity(0.2),
                        width: isDone ? 2 : 1,
                      ),
                      boxShadow: isDone
                          ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))]
                          : [],
                    ),
                    child: Row(
                      children: [
                        // Colored day strip
                        Container(
                          width: 56,
                          height: 80,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(shortDays[dayIdx],
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                              const SizedBox(height: 4),
                              if (isDone) const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 20)
                              else const Icon(LucideIcons.clock, color: Colors.white70, size: 18),
                            ],
                          ),
                        ),
                        // Content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(sub['name'] as String,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: isDone ? color : Colors.white,
                                        decoration: isDone ? TextDecoration.lineThrough : null)),
                                const SizedBox(height: 4),
                                Text(
                                    '${_studyHours.toInt()}h study • ${_breakLength.toInt()}m break • $_studyTime',
                                    style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                const SizedBox(height: 6),
                                Row(children: [
                                  Text('Difficulty: ${(sub['difficulty'] as double).toInt()}/10',
                                      style: TextStyle(fontSize: 10, color: color.withOpacity(0.8))),
                                  const Spacer(),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: isDone
                                        ? Container(
                                            key: const ValueKey('done'),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: color.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text('✓ Done', style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                                          )
                                        : Container(
                                            key: const ValueKey('pending'),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.06),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text('Tap to complete', style: TextStyle(color: Colors.white38, fontSize: 10)),
                                          ),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Progress Tab ──────────────────────────────────────────────────────────
  Widget _buildProgressTab() {
    if (_planSubjects.isEmpty) {
      return const Center(
        child: Text('No subjects added yet.', style: TextStyle(color: Colors.white38)),
      );
    }

    final completed = _completedPerSubject;
    final totalDone = completed.values.fold(0, (a, b) => a + b);
    final totalSessions = 7; // one week
    final overallPct = totalSessions > 0 ? (totalDone / totalSessions).clamp(0.0, 1.0) : 0.0;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        // Overall progress ring
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              const Text('Overall Completion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 16),
              CircularPercentIndicator(
                radius: 60,
                lineWidth: 10,
                percent: overallPct,
                center: Text('${(overallPct * 100).toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF6366F1))),
                progressColor: const Color(0xFF6366F1),
                backgroundColor: Colors.white.withOpacity(0.06),
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
              ),
              const SizedBox(height: 12),
              Text('$totalDone of $totalSessions sessions completed',
                  style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
        ),

        // Per-subject progress
        _PlannerCard(
          title: 'Subject-wise Progress',
          subtitle: 'Based on sessions you marked complete.',
          child: Column(
            children: _planSubjects.asMap().entries.map((entry) {
              final idx = entry.key;
              final s = entry.value;
              final name = s['name'] as String;
              final done = completed[name] ?? 0;
              final total = _totalSessionsFor(name);
              final pct = (done / total).clamp(0.0, 1.0);
              final color = _subjectColors[idx % _subjectColors.length];

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
                        Text('$done/$total sessions',
                            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearPercentIndicator(
                      lineHeight: 8,
                      percent: pct,
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white.withOpacity(0.06),
                      progressColor: color,
                      barRadius: const Radius.circular(12),
                      animation: true,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pct >= 1.0
                          ? '🎉 Completed!'
                          : pct == 0
                              ? 'Not started'
                              : '${(pct * 100).toInt()}% complete',
                      style: TextStyle(
                        color: pct >= 1.0 ? Colors.green : Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// Helper card widget for Study Planner sections
class _PlannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _PlannerCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
