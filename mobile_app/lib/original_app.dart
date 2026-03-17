import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'app_shared.dart';



// Global Theme Management
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
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return CustomPaint(
          painter: MeshPainter(_controller.value, isDark),
          child: Container(),
        );
      },
    );
  }
}

class MeshPainter extends CustomPainter {
  final double value;
  final bool isDark;
  MeshPainter(this.value, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    
    // Base Gradient - Cinematic Deep Purple/Indigo
    final paint1 = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          math.sin(value * 2 * math.pi) * 0.3,
          math.cos(value * 2 * math.pi) * 0.3 - 0.8,
        ),
        radius: 1.8,
        colors: isDark 
            ? [const Color(0xFF1E1B4B), const Color(0xFF020617)]
            : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC)],
      ).createShader(rect);
    canvas.drawRect(rect, paint1);

    // Dynamic Futuristic Neon Orbs
    final colors = isDark 
        ? [AppColors.primary, AppColors.neonCyan, AppColors.neonFuchsia] 
        : [AppColors.primary.withOpacity(0.2), AppColors.neonCyan.withOpacity(0.2), AppColors.neonFuchsia.withOpacity(0.2)];

    for (int i = 0; i < 4; i++) {
      double t = (value + i * 0.25) % 1.0;
      double radius = size.width * (1.0 + 0.4 * math.sin(t * 2 * math.pi + i));
      Offset center = Offset(
        size.width * 0.5 + size.width * 0.4 * math.cos(t * 2 * math.pi * 0.7 + i),
        size.height * 0.5 + size.height * 0.5 * math.sin(t * 2 * math.pi * 1.1 + i),
      );

      final p = Paint()
        ..color = colors[i % colors.length].withOpacity(isDark ? 0.12 : 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 120);
      canvas.drawCircle(center, radius, p);
    }

    // Add subtle scanlines for futuristic feel
    final scanlinePaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.01)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), scanlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant MeshPainter oldDelegate) => oldDelegate.value != value || oldDelegate.isDark != isDark;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          const AnimatedMeshBackground(),
          const _FloatingParticles(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Lottie Study Animation
                    FadeIn(
                      duration: const Duration(milliseconds: 1500),
                      child: SizedBox(
                        height: 220,
                        child: Lottie.asset(
                          'assets/study_animation.json',
                          onWarning: (w) => print('Lottie Warning: $w'),
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.bookOpen, size: 64, color: AppColors.primary.withOpacity(0.5)),
                                  const SizedBox(height: 12),
                                  Text('Learning in Progress...', 
                                    style: GoogleFonts.outfit(color: AppColors.primary.withOpacity(0.5), fontWeight: FontWeight.bold)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    // Cinematic Glowing Branding
                    FadeInDown(
                      duration: const Duration(milliseconds: 1000),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: AppColors.futuristicGradient,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: AppColors.glowShadow(AppColors.primary),
                            ),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(seconds: 3),
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: 1.0 + 0.08 * math.sin(value * 2 * math.pi),
                                  child: const Icon(LucideIcons.graduationCap, size: 48, color: Colors.white),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Study Tracker',
                            style: GoogleFonts.outfit(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.5,
                              height: 1,
                              foreground: Paint()..shader = AppColors.futuristicGradient.createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 48),

                    // Futuristic Auth Card
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2), 
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.1),
                              blurRadius: 30,
                              spreadRadius: -10,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                            child: Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.7),
                                    (isDark ? const Color(0xFF0F172A) : Colors.white).withOpacity(0.4),
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  FadeInLeft(
                                    delay: const Duration(milliseconds: 200),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isLogin ? 'Welcome back' : 'Create Account',
                                          style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.8),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          isLogin ? 'Sign in to continue your journey' : 'Start your futuristic study path',
                                          style: GoogleFonts.outfit(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  
                                  FadeIn(
                                    delay: const Duration(milliseconds: 400),
                                    child: Column(
                                      children: [
                                        if (!isLogin) ...[
                                          const _InputField(label: 'Full Name', hint: 'Alex Thompson', icon: LucideIcons.user),
                                          const SizedBox(height: 20),
                                        ],
                                        const _InputField(label: 'Email Address', hint: 'alex@example.com', icon: LucideIcons.mail),
                                        const SizedBox(height: 20),
                                        const _InputField(label: 'Password', hint: '••••••••', icon: LucideIcons.lock, obscure: true),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 40),
                                  
                                  // Striking Gradient Glow Button
                                  ZoomIn(
                                    delay: const Duration(milliseconds: 600),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (c) => const OnboardingScreen()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                                      ),
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          gradient: AppColors.futuristicGradient,
                                          borderRadius: BorderRadius.circular(22),
                                          boxShadow: AppColors.glowShadow(AppColors.primary),
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              isLogin ? 'Sign In' : 'Get Started',
                                              style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 17, color: Colors.white),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(LucideIcons.arrowRight, size: 18, color: Colors.white),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Or divider with gradient lines
                                  FadeIn(
                                    delay: const Duration(milliseconds: 800),
                                    child: Row(
                                      children: [
                                        Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, isDark ? Colors.white10 : Colors.black12])))),
                                        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('OR', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.white24 : Colors.black26))),
                                        Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [isDark ? Colors.white10 : Colors.black12, Colors.transparent])))),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 32),
                                  
                                  // Social Logins
                                  FadeInUp(
                                    delay: const Duration(milliseconds: 1000),
                                    child: const Row(
                                      children: [
                                        Expanded(child: _SocialButton(icon: LucideIcons.chrome, label: 'Google')),
                                        SizedBox(width: 16),
                                        Expanded(child: _SocialButton(icon: LucideIcons.apple, label: 'Apple')),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  Center(
                                    child: TextButton(
                                      onPressed: () => setState(() => isLogin = !isLogin),
                                      child: Text(
                                        isLogin ? "New here? Create an account" : "Have an account? Sign in",
                                        style: GoogleFonts.outfit(
                                          color: AppColors.primary, 
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
    );
  }
}

// Particle System for Futuristic Effects
class _FloatingParticles extends StatefulWidget {
  const _FloatingParticles();

  @override
  State<_FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<_FloatingParticles> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final List<_Particle> _particles = List.generate(15, (_) => _Particle());

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => CustomPaint(
        painter: _ParticlePainter(_particles, _ctrl.value),
        child: Container(),
      ),
    );
  }
}

class _Particle {
  double x = math.Random().nextDouble();
  double y = math.Random().nextDouble();
  double size = math.Random().nextDouble() * 3 + 1;
  double speed = math.Random().nextDouble() * 0.05 + 0.01;
  double opacity = math.Random().nextDouble() * 0.3 + 0.1;
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double value;
  _ParticlePainter(this.particles, this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.neonCyan.withOpacity(0.2);
    for (var p in particles) {
      double py = (p.y - value * p.speed) % 1.0;
      canvas.drawCircle(Offset(p.x * size.width, py * size.height), p.size, paint..color = paint.color.withOpacity(p.opacity));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
      sub = 'Select current semester   ${selectedUniversity ?? ''}   $selectedDept.';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInDown(
          child: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 40, fontWeight: FontWeight.w900,
              height: 1.1, letterSpacing: -1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        FadeInDown(
          delay: const Duration(milliseconds: 200),
          child: Text(sub, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black54, fontSize: 17, fontWeight: FontWeight.w500)),
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
        crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.3,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        final sem = 'Sem ${index + 1}';
        final isSelected = selectedSem == sem;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return GestureDetector(
          onTap: () => setState(() => selectedSem = sem),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.15)
                  : (isDark ? AppColors.darkSurface.withOpacity(0.8) : Colors.white),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.white.withOpacity(isDark ? 0.05 : 0.6),
                width: 2,
              ),
              boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 15)] : [],
            ),
            child: Text(sem,
                style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? AppColors.primary : (isDark ? Colors.white38 : Colors.black38))),
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
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500),
          onChanged: (q) => setState(() => selectedUniversity = q.isEmpty ? null : selectedUniversity),
          decoration: const InputDecoration(
            hintText: 'Search University...',
            prefixIcon: Icon(LucideIcons.search, size: 20),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FadeInLeft(
      delay: Duration(milliseconds: index * 100),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: (isSelected 
                ? (isDark ? AppColors.primary.withOpacity(0.15) : AppColors.primary.withOpacity(0.1))
                : (isDark ? const Color(0xFF0F172A) : Colors.white)).withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.white.withOpacity(isDark ? 0.05 : 0.8),
              width: 1.5,
            ),
            boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 15)] : [],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withOpacity(0.2) : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: isSelected ? AppColors.primary : (isDark ? Colors.white30 : Colors.black26), size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? AppColors.primary : null)),
                    Text(subtitle, style: TextStyle(color: isSelected ? AppColors.primary.withOpacity(0.6) : (isDark ? Colors.white38 : Colors.black38), fontSize: 13)),
                  ],
                ),
              ),
              if (isSelected) 
                const Icon(LucideIcons.checkCircle2, color: AppColors.primary, size: 22),
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
    // non-Engineering step 2 (sem) handled via _buildSemList - repurposed check:
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

//  
// Subject Picker Screen
//  

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
    //   School  
    'Mathematics', 'Physics', 'Chemistry', 'Biology', 'English',
    'Social Studies', 'History', 'Geography', 'Civics', 'Economics',
    'Hindi', 'Kannada', 'Telugu', 'Tamil', 'Sanskrit', 'Computer Science', 'Coding',
    'Environmental Science', 'Moral Science', 'Physical Education',

    //   Common Engineering (1st & 2nd Year)  
    'Engineering Mathematics I', 'Engineering Mathematics II',
    'Engineering Mathematics III', 'Engineering Mathematics IV',
    'Engineering Physics', 'Engineering Chemistry',
    'Engineering Graphics', 'Engineering Mechanics',
    'Basic Electrical Engineering', 'Basic Electronics',
    'C Programming', 'Workshop Practice', 'Environmental Studies',
    'Constitution of India', 'Professional Ethics', 'Technical English',
    'Communication Skills', 'Universal Human Values',

    //   CSE / IT  
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

    //   ECE  
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

    //   EEE (Electrical & Electronics)  
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

    //   Mechanical Engineering (ME)  
    'Thermodynamics', 'Fluid Mechanics', 'Heat Transfer',
    'Strength of Materials', 'Manufacturing Processes',
    'Machine Design', 'Kinematics of Machinery', 'Dynamics of Machinery',
    'Theory of Machines', 'Industrial Engineering',
    'CAD/CAM', 'Finite Element Analysis (FEA)',
    'Automobile Engineering', 'Robotics', 'Mechatronics',
    'Refrigeration & Air Conditioning', 'Turbo Machinery',
    'Operations Research', 'Production Engineering',
    'Metrology & Quality Control', 'Casting & Welding',

    //   Civil Engineering (CE)  
    'Structural Analysis', 'Reinforced Cement Concrete (RCC)',
    'Soil Mechanics', 'Foundation Engineering',
    'Hydraulics & Fluid Mechanics', 'Water Resources Engineering',
    'Transportation Engineering', 'Highway Engineering',
    'Surveying', 'Remote Sensing & GIS',
    'Environmental Engineering', 'Water Supply Engineering',
    'Construction Management', 'Estimating & Costing',
    'Urban Planning', 'Bridge Engineering', 'Steel Structures',

    //   Chemical Engineering (ChE)  
    'Chemical Reaction Engineering', 'Mass Transfer Operations',
    'Heat & Mass Transfer', 'Fluid Flow Operations',
    'Process Control & Instrumentation', 'Chemical Technology',
    'Petroleum Refining', 'Polymer Engineering',
    'Biochemical Engineering',

    //   Biotechnology / Biomedical  
    'Biochemistry', 'Microbiology', 'Genetic Engineering',
    'Cell Biology', 'Molecular Biology',
    'Bioprocess Engineering', 'Immunology',
    'Medical Electronics', 'Bioinformatics',

    //   MBA / Management  
    'Principles of Management', 'Marketing Management',
    'Financial Management', 'Human Resource Management',
    'Operations Management', 'Business Law',
    'Entrepreneurship Development', 'Strategic Management',
    'Accounting & Finance', 'Organizational Behaviour',
  ];

  @override
  void initState() {
    super.initState();
    _added = []; // Start empty   user adds subjects manually via search
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
                            ? '${widget.university}   ${widget.sem}   ${widget.dept}'
                            : widget.sem != null
                                ? 'Customise subjects for ${widget.sem}   ${widget.dept}'
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
                      hintText: 'Search subjects (e.g. Data Structures) ',
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
                      const Text('Tap   to remove', style: TextStyle(color: Colors.white38, fontSize: 12)),
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

class _InputField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;

  const _InputField({required this.label, required this.hint, required this.icon, this.obscure = false});

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(widget.label, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: isDark ? Colors.white38 : Colors.black38, letterSpacing: 0.5)),
        ),
        const SizedBox(height: 10),
        Focus(
          onFocusChange: (focus) => setState(() => _isFocused = focus),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: (isDark ? AppColors.darkBg : Colors.white).withOpacity(_isFocused ? 0.9 : 0.4),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _isFocused ? AppColors.primary : Colors.white.withOpacity(isDark ? 0.05 : 0.3), width: 1.5),
              boxShadow: [
                if (_isFocused) BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 15, spreadRadius: 2)
              ],
            ),
            child: TextField(
              obscureText: widget.obscure,
              style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.outfit(color: isDark ? Colors.white12 : Colors.black12, fontWeight: FontWeight.w500),
                prefixIcon: Icon(widget.icon, size: 20, color: _isFocused ? AppColors.primary : (isDark ? Colors.white24 : Colors.black.withOpacity(0.24))),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SocialButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: (isDark ? Colors.white : Colors.black).withOpacity(isDark ? 0.05 : 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(isDark ? 0.05 : 0.3)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isDark ? Colors.white70 : Colors.black.withOpacity(0.7)),
            const SizedBox(width: 10),
            Text(label, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 14, color: isDark ? Colors.white70 : Colors.black.withOpacity(0.7))),
          ],
        ),
      ),
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
  final List<Map<String, dynamic>> _quizHistory = [];

  void _onQuizComplete(Map<String, dynamic> result) {
    setState(() {
      _quizHistory.add({
        ...result,
        'date': DateTime.now().toIso8601String(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeTab(category: widget.category, subjects: widget.subjects),
          const StudyPlannerTab(),
          QuizTab(
            subjects: widget.subjects,
            onQuizComplete: _onQuizComplete,
          ),
          QuizReportTab(quizHistory: _quizHistory),
          const SettingsTab(),
        ],
      ),
      bottomNavigationBar: _buildFloatingNavBar(isDark),
    );
  }

  Widget _buildFloatingNavBar(bool isDark) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Container(
        height: 76,
        margin: const EdgeInsets.fromLTRB(28, 0, 28, 40),
        decoration: BoxDecoration(
          color: (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.8),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withOpacity(isDark ? 0.05 : 0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 40,
              offset: const Offset(0, 12),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navItem(LucideIcons.home, 0),
                _navItem(LucideIcons.calendar, 1),
                _navItem(LucideIcons.zap, 2, isSpecial: true),
                _navItem(LucideIcons.barChart, 3),
                _navItem(LucideIcons.settings, 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, {bool isSpecial = false}) {
    final isSelected = _currentIndex == index;
    final color = isSelected 
        ? AppColors.primary 
        : (Theme.of(context).brightness == Brightness.dark ? Colors.white38 : Colors.black26);

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          setState(() => _currentIndex = index);
          HapticFeedback.lightImpact();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        transform: Matrix4.identity()..scale(isSelected ? 1.15 : 1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) {
                      return Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2 + 0.1 * math.sin(value * 2 * math.pi)),
                              blurRadius: 15 + 5 * math.sin(value * 2 * math.pi),
                              spreadRadius: 2,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                Icon(icon, color: isSelected ? AppColors.neonCyan : color, size: isSpecial ? 28 : 24),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(top: 4),
              width: isSelected ? 4 : 0,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  if (isSelected) BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 4)
                ],
              ),
            ),
          ],
        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Stack(children: [
      const AnimatedMeshBackground(),
      CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cinematic Floating Glass Island Greeting
                    FadeInDown(
                      duration: const Duration(milliseconds: 1000),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 4),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 8 * math.sin(value * 2 * math.pi)),
                            child: Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(color: Colors.white.withOpacity(isDark ? 0.05 : 0.4)),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.7),
                                    (isDark ? const Color(0xFF0F172A) : Colors.white).withOpacity(0.4),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Welcome back,',
                                              style: GoogleFonts.outfit(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: isDark ? Colors.white54 : Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Hemanth',
                                              style: GoogleFonts.outfit(
                                                fontSize: 34,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: -1.2,
                                                color: isDark ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: AppColors.futuristicGradient,
                                          boxShadow: AppColors.glowShadow(AppColors.primary),
                                          border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                                        ),
                                        child: const Icon(LucideIcons.user, color: Colors.white, size: 32),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(children: [
                const SizedBox(height: 10),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: _buildMainStats(context),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: const _SectionHeader(title: 'Overview', subtitle: 'Your current study progress'),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: _buildProgressCard(context),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 1000),
                  child: const _SectionHeader(title: 'Active Subjects', subtitle: 'Focus items for this week'),
                ),
                const SizedBox(height: 16),
              ]),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return FadeInLeft(
                    delay: Duration(milliseconds: 1100 + (index * 100)),
                    child: _SubjectCard(name: subjects[index]),
                  );
                },
                childCount: subjects.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    ]);
  }

  Widget _buildMainStats(BuildContext context) {
    return const Row(children: [
      Expanded(child: _GlassStat(icon: LucideIcons.flame, value: '3', label: 'Streak', color: Colors.orange)),
      SizedBox(width: 16),
      Expanded(child: _GlassStat(icon: LucideIcons.target, value: '85%', label: 'Score', color: Colors.greenAccent)),
    ]);
  }

  Widget _buildProgressCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(isDark ? 0.6 : 0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
      ),
      child: Column(children: [
        Row(children: [
          const Icon(LucideIcons.timer, size: 20, color: Color(0xFF6366F1)),
          const SizedBox(width: 12),
          Text('Study Goal', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text('45/120 min', style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 12)),
        ]),
        const SizedBox(height: 20),
        LinearPercentIndicator(
          percent: 0.37,
          lineHeight: 8,
          progressColor: const Color(0xFF6366F1),
          backgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
          barRadius: const Radius.circular(10),
          padding: EdgeInsets.zero,
          animation: true,
          animationDuration: 1500,
        ),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5, color: isDark ? Colors.white : Colors.black)),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary.withOpacity(0.2), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: GoogleFonts.outfit(color: isDark ? Colors.white30 : Colors.black38, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _GlassStat extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final Color color;
  const _GlassStat({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF0F172A) : Colors.white).withOpacity(0.8),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(isDark ? 0.05 : 0.6)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 25,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10)],
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 20),
        Text(value, style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1.0, color: isDark ? Colors.white : Colors.black)),
        Text(label.toUpperCase(), style: GoogleFonts.outfit(color: isDark ? Colors.white30 : Colors.black38, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
      ]),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String name;
  const _SubjectCard({required this.name});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF0F172A) : Colors.white).withOpacity(0.6),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(isDark ? 0.05 : 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned(
              left: 0, top: 0, bottom: 0,
              width: 6,
              child: Container(decoration: BoxDecoration(gradient: AppColors.futuristicGradient)),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name, style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 17, letterSpacing: -0.5, color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withOpacity(0.3 + 0.3 * math.sin(value * 2 * math.pi)),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Text('IN PROGRESS', style: GoogleFonts.outfit(color: const Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- AI Coach Section ---

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

//  
// Study Planner Tab  (mirrors web Study Planner exactly)
//  

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
  late DateTime _weekStart; // Monday of the displayed week

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    // Set week start to Monday of the current week
    final now = DateTime.now();
    _weekStart = now.subtract(Duration(days: now.weekday - 1));
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(children: [
      const AnimatedMeshBackground(),
      SafeArea(
        child: Column(
          children: [
            // Glass Island Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 4),
                builder: (context, value, child) {
                  final offset = math.sin(value * math.pi * 2) * 8;
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: child,
                  );
                },
                child: FadeInDown(
                  duration: const Duration(milliseconds: 1000),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(isDark ? 0.08 : 0.4)),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.8),
                          (isDark ? const Color(0xFF0F172A) : Colors.white).withOpacity(0.5),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonCyan.withOpacity(isDark ? 0.15 : 0.05),
                          blurRadius: 40,
                          offset: const Offset(0, 15),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Study Planner',
                              style: GoogleFonts.outfit(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.2,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'AI-powered optimal timetable generator.',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white54 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            //   Tabs  
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (isDark ? const Color(0xFF0F172A) : Colors.white).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(isDark ? 0.05 : 0.5)),
                ),
                child: TabBar(
                  controller: _tabCtrl,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: AppColors.futuristicGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonCyan.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: isDark ? Colors.white38 : Colors.black38,
                  labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
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

            //   Tab Views  
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
    ]);
  }

  //   Setup Tab  
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

  //   PDF generation  
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
          pw.Text('Generated by Study Tracker | ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
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
                isDone ? 'DONE' : 'Pending',
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

  //   Timetable Tab - full weekly calendar grid  
  Widget _buildTimetableTab() {
    if (!_generated || _planSubjects.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.calendarDays, size: 48, color: Colors.white24),
            SizedBox(height: 16),
            Text('No plan generated yet.',
                style: TextStyle(color: Colors.white54, fontSize: 16)),
            SizedBox(height: 8),
            Text('Add subjects and tap "Generate AI Study Plan"',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white24, fontSize: 13)),
          ],
        ),
      );
    }

    final now = DateTime.now();
    final shortMonths = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final weekEnd = _weekStart.add(const Duration(days: 6));
    final weekLabel =
        '${shortMonths[_weekStart.month]} ${_weekStart.day} - ${shortMonths[weekEnd.month]} ${weekEnd.day}';
    final shortDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Determine study start hour/min based on preference
    int startH;
    switch (_studyTime) {
      case 'Afternoon': startH = 13; break;
      case 'Evening':   startH = 16; break;
      case 'Night':     startH = 19; break;
      default:          startH = 8;  // Morning
    }

    // Build sessions for a given day (0=Mon..6=Sun):
    // Each block = 45 min study + breakLength min break
    List<Map<String, dynamic>> sessionsForDay(int d) {
      final sessions = <Map<String, dynamic>>[];
      int curMinutes = startH * 60;
      int remaining = (_studyHours * 60).toInt();
      int slot = 0;
      while (remaining > 30) {
        const blockLen = 45;
        final breakLen = _breakLength.toInt();
        final subjectIdx = (d + slot) % _planSubjects.length;
        final sessionKey = '${d}_$slot';
        sessions.add({
          'subjectIdx': subjectIdx,
          'startMin': curMinutes,
          'endMin': curMinutes + blockLen,
          'breakEndMin': curMinutes + blockLen + breakLen,
          'key': sessionKey,
        });
        curMinutes += blockLen + breakLen;
        remaining -= (blockLen + breakLen);
        slot++;
      }
      return sessions;
    }

    // Compute earliest and latest minute across all days
    final allSessions = List.generate(7, (d) => sessionsForDay(d));
    int minMinute = allSessions
        .expand((s) => s)
        .map((s) => s['startMin'] as int)
        .fold(startH * 60, math.min);
    int maxMinute = allSessions
        .expand((s) => s)
        .map((s) => s['breakEndMin'] as int)
        .fold(startH * 60, math.max);

    // Snap to hour boundaries
    minMinute = (minMinute ~/ 60) * 60;
    maxMinute = ((maxMinute + 59) ~/ 60) * 60;

    final totalHours = ((maxMinute - minMinute) / 60).ceil().clamp(2, 12);
    const double rowHeight = 60.0;
    const double timeColW = 50.0;
    const double dayColW = 130.0;
    const double headerH = 56.0;

    String fmt(int totalMin) {
      final h = totalMin ~/ 60;
      final m = totalMin % 60;
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    }

    return Column(
      children: [
        //   Week Nav + PDF  
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() =>
                    _weekStart = _weekStart.subtract(const Duration(days: 7))),
                icon: const Icon(LucideIcons.chevronLeft, size: 18, color: Colors.white70),
                padding: EdgeInsets.zero,
              ),
              Expanded(
                child: Center(
                  child: Text(weekLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
              IconButton(
                onPressed: () => setState(() =>
                    _weekStart = _weekStart.add(const Duration(days: 7))),
                icon: const Icon(LucideIcons.chevronRight, size: 18, color: Colors.white70),
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 4),
              ElevatedButton.icon(
                onPressed: _downloadPdf,
                icon: const Icon(LucideIcons.download, size: 13),
                label: const Text('PDF', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),

        //   Calendar Grid  
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: timeColW + dayColW * 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //   Day headers  
                    Row(
                      children: [
                        // Time column header (empty)
                        Container(
                          width: timeColW,
                          height: headerH,
                          alignment: Alignment.center,
                          child: const Text('Time',
                              style: TextStyle(color: Colors.white38, fontSize: 11)),
                        ),
                        // Day headers
                        ...List.generate(7, (d) {
                          final day = _weekStart.add(Duration(days: d));
                          final isToday = day.year == now.year &&
                              day.month == now.month &&
                              day.day == now.day;
                          return Container(
                            width: dayColW,
                            height: headerH,
                            decoration: BoxDecoration(
                              color: isToday
                                  ? const Color(0xFF6366F1).withOpacity(0.15)
                                  : Colors.transparent,
                              border: Border(
                                left: BorderSide(color: Colors.white.withOpacity(0.06)),
                                bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(shortDays[d],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: isToday
                                            ? const Color(0xFF6366F1)
                                            : Colors.white70)),
                                Text(
                                    '${shortMonths[day.month]} ${day.day}',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: isToday
                                            ? const Color(0xFF6366F1)
                                            : Colors.white38)),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),

                    //   Time rows  
                    Stack(
                      children: [
                        // Background grid lines + time labels
                        Column(
                          children: List.generate(totalHours, (hIdx) {
                            final minute = minMinute + hIdx * 60;
                            return SizedBox(
                              height: rowHeight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Time label
                                  Container(
                                    width: timeColW,
                                    padding: const EdgeInsets.only(top: 6, right: 6),
                                    child: Text(
                                      fmt(minute),
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          color: Colors.white24, fontSize: 10),
                                    ),
                                  ),
                                  // Grid cells
                                  ...List.generate(7, (d) => Container(
                                    width: dayColW,
                                    height: rowHeight,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(color: Colors.white.withOpacity(0.04)),
                                        top: BorderSide(color: Colors.white.withOpacity(0.04)),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            );
                          }),
                        ),

                        // Session blocks positioned absolutely
                        Positioned(
                          left: timeColW,
                          top: 0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(7, (d) {
                              final daySessions = allSessions[d];
                              final dayDate =
                                  _weekStart.add(Duration(days: d));
                              final isToday = dayDate.year == now.year &&
                                  dayDate.month == now.month &&
                                  dayDate.day == now.day;

                              return SizedBox(
                                width: dayColW,
                                height: totalHours * rowHeight,
                                 child: Stack(
                                   clipBehavior: Clip.hardEdge,
                                  children: [
                                    // Today highlight backdrop
                                    if (isToday)
                                      Container(
                                        width: dayColW,
                                        height: totalHours * rowHeight,
                                        color: const Color(0xFF6366F1).withOpacity(0.04),
                                      ),

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
                                                            if (studyPx > 40)
                                                              Text(
                                                                '${fmt(startMin)}-${fmt(endMin)}',
                                                                style: const TextStyle(color: Colors.white70, fontSize: 8),
                                                              ),
                                                            if (studyPx > 55)
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
                                                          'Break ${fmt(endMin)}',
                                                          style: const TextStyle(color: Colors.white24, fontSize: 8)),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                       );
                                     }),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //   Progress Tab  
  Widget _buildProgressTab() {
    if (_planSubjects.isEmpty) {
      return const Center(
        child: Text('No subjects added yet.', style: TextStyle(color: Colors.white38)),
      );
    }

    final completed = _completedPerSubject;
    final totalDone = completed.values.fold(0, (a, b) => a + b);
    const totalSessions = 7; // one week
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
                          ? '  Completed!'
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkSurface : Colors.white).withOpacity(0.6),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(isDark ? 0.08 : 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonCyan.withOpacity(isDark ? 0.1 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.outfit(color: isDark ? Colors.white38 : Colors.black38, fontSize: 12)),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

// Small pill button used inside timetable session blocks
class _TinyBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _TinyBtn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

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
      {'q': 'What is the derivative of x^2?', 'opts': ['2x', 'x^2', '2', 'x'], 'ans': 0, 'exp': 'By power rule: d/dx(x^n) = nx^(n-1), so d/dx(x^2) = 2x.', 'emoji': 'Q'},
      {'q': 'What is integral 2x dx?', 'opts': ['x^2+C', '2x^2+C', 'x+C', '2+C'], 'ans': 0, 'exp': 'Integral of 2x: integral 2x dx = x^2 + C by reverse power rule.', 'emoji': 'Q'},
      {'q': 'Solve: x^2 - 5x + 6 = 0', 'opts': ['x=2,3', 'x=1,6', 'x=-2,-3', 'x=3,4'], 'ans': 0, 'exp': 'Factor: (x-2)(x-3)=0, so x=2 or x=3.', 'emoji': 'Q'},
      {'q': 'What is sin(90 deg)?', 'opts': ['1', '0', '-1', '0.5'], 'ans': 0, 'exp': 'sin(90) = 1 from the unit circle.', 'emoji': 'Q'},
      {'q': 'log2(8) = ?', 'opts': ['3', '4', '2', '8'], 'ans': 0, 'exp': '2^3 = 8, so log2(8) = 3.', 'emoji': 'Q'},
      {'q': 'Area of circle with r=7?', 'opts': ['154', '44', '49', '22'], 'ans': 0, 'exp': 'A = pi*r^2 = (22/7)*49 = 154.', 'emoji': 'Q'},
      {'q': 'Value of cos(0 deg)?', 'opts': ['1', '0', '-1', 'inf'], 'ans': 0, 'exp': 'cos(0) = 1 from unit circle definition.', 'emoji': 'Q'},
      {'q': 'What is 7! (7 factorial)?', 'opts': ['5040', '720', '40320', '210'], 'ans': 0, 'exp': '7! = 7*6*5*4*3*2*1 = 5040.', 'emoji': 'Q'},
      {'q': 'If A={1,2} and B={2,3}, then A intersection B?', 'opts': ['{2}', '{1,3}', '{1,2,3}', '{}'], 'ans': 0, 'exp': 'Intersection = elements in both sets = {2}.', 'emoji': 'Q'},
      {'q': 'tan(45 deg) = ?', 'opts': ['1', '0', 'sqrt(2)', 'sqrt(3)'], 'ans': 0, 'exp': 'tan(45) = sin/cos = 1/1 = 1.', 'emoji': 'Q'},
      {'q': 'Sum of angles in a triangle?', 'opts': ['180 deg', '360 deg', '90 deg', '270 deg'], 'ans': 0, 'exp': 'Sum of interior angles of any triangle = 180.', 'emoji': 'Q'},
      {'q': 'What is the slope of y=3x+2?', 'opts': ['3', '2', '1/3', '-3'], 'ans': 0, 'exp': 'In y=mx+b, m is the slope. Here m=3.', 'emoji': 'Q'},
      {'q': 'Probability of tossing heads?', 'opts': ['1/2', '1/4', '1', '0'], 'ans': 0, 'exp': 'Fair coin: P(H) = 1/2 = 0.5.', 'emoji': 'Q'},
      {'q': 'HCF of 12 and 18?', 'opts': ['6', '3', '9', '36'], 'ans': 0, 'exp': 'Factors: 12={1,2,3,4,6,12}, 18={1,2,3,6,9,18}. HCF=6.', 'emoji': 'Q'},
      {'q': 'What is 2^8?', 'opts': ['256', '128', '512', '64'], 'ans': 0, 'exp': '2^8 = 256.', 'emoji': 'Q'},
      {'q': 'Pythagoras: a=3, b=4, c=?', 'opts': ['5', '6', '7', '4'], 'ans': 0, 'exp': 'c=sqrt(a^2+b^2)=sqrt(9+16)=sqrt(25)=5.', 'emoji': 'Q'},
      {'q': 'Arithmetic mean of 2,4,6,8,10?', 'opts': ['6', '5', '8', '4'], 'ans': 0, 'exp': 'Mean = (2+4+6+8+10)/5 = 30/5 = 6.', 'emoji': 'Q'},
      {'q': 'How many sides does a hexagon have?', 'opts': ['6', '5', '7', '8'], 'ans': 0, 'exp': 'Hexa means 6. A hexagon has 6 sides.', 'emoji': 'Q'},
      {'q': 'What is sqrt(144)?', 'opts': ['12', '14', '11', '13'], 'ans': 0, 'exp': '12 * 12 = 144, so sqrt(144) = 12.', 'emoji': 'Q'},
      {'q': 'LCM of 4 and 6?', 'opts': ['12', '6', '24', '8'], 'ans': 0, 'exp': 'LCM = smallest common multiple of 4 and 6 = 12.', 'emoji': 'Q'},
    ],
    'Physics': [
      {'q': "Newton's 2nd Law: F = ?", 'opts': ['ma', 'mv', 'm/a', 'a/m'], 'ans': 0, 'exp': 'Force = mass * acceleration (F = ma).', 'emoji': 'Q'},
      {'q': 'Speed of light in vacuum?', 'opts': ['3x10^8 m/s', '3x10^6 m/s', '3x10^10 m/s', '3x10^5 m/s'], 'ans': 0, 'exp': 'c approx 3x10^8 m/s in vacuum.', 'emoji': 'Q'},
      {'q': 'Unit of electric current?', 'opts': ['Ampere', 'Volt', 'Ohm', 'Watt'], 'ans': 0, 'exp': 'Current is measured in Amperes (A).', 'emoji': 'Q'},
      {'q': 'v = u + at. What is a?', 'opts': ['Acceleration', 'Area', 'Amplitude', 'Angle'], 'ans': 0, 'exp': 'In kinematic eq v=u+at, a is acceleration.', 'emoji': 'Q'},
      {'q': "Ohm's Law: V = ?", 'opts': ['IR', 'I/R', 'R/I', 'I^2R'], 'ans': 0, 'exp': 'Voltage = Current * Resistance (V = IR).', 'emoji': 'Q'},
      {'q': 'Unit of power?', 'opts': ['Watt', 'Joule', 'Newton', 'Pascal'], 'ans': 0, 'exp': 'Power is measured in Watts (W = J/s).', 'emoji': 'Q'},
      {'q': 'What is g on Earth?', 'opts': ['9.8 m/s^2', '8.9 m/s^2', '10.8 m/s^2', '9.0 m/s^2'], 'ans': 0, 'exp': 'Standard gravitational acceleration g approx 9.8.', 'emoji': 'Q'},
      {'q': 'Kinetic Energy = ?', 'opts': ['1/2mv^2', 'mgh', 'mv', 'F*d'], 'ans': 0, 'exp': 'KE = 1/2mv^2 where m=mass, v=velocity.', 'emoji': 'Q'},
      {'q': 'Which is not a vector?', 'opts': ['Speed', 'Velocity', 'Force', 'Displacement'], 'ans': 0, 'exp': 'Speed is scalar (magnitude only). Others have direction.', 'emoji': 'Q'},
      {'q': 'Wavelength * frequency = ?', 'opts': ['Wave speed', 'Amplitude', 'Period', 'Energy'], 'ans': 0, 'exp': 'lambda * f = v (wave speed). Fundamental wave equation.', 'emoji': 'Q'},
      {'q': 'Unit of pressure?', 'opts': ['Pascal', 'Newton', 'Watt', 'Joule'], 'ans': 0, 'exp': 'Pressure is measured in Pascals (Pa = N/m^2).', 'emoji': 'Q'},
      {'q': 'Transformer changes?', 'opts': ['Voltage', 'Current type', 'Power', 'Resistance'], 'ans': 0, 'exp': 'Transformer steps voltage up or down in AC circuits.', 'emoji': 'Q'},
      {'q': 'What does a resistor do?', 'opts': ['Opposes current', 'Stores energy', 'Amplifies signal', 'Emits light'], 'ans': 0, 'exp': 'A resistor opposes the flow of electric current.', 'emoji': 'Q'},
      {'q': 'Frequency of AC in India?', 'opts': ['50 Hz', '60 Hz', '40 Hz', '100 Hz'], 'ans': 0, 'exp': 'India uses 50 Hz AC frequency.', 'emoji': 'Q'},
      {'q': 'Which mirror forms virtual image always?', 'opts': ['Convex', 'Concave', 'Plane', 'Both A & C'], 'ans': 0, 'exp': 'Convex mirror always forms virtual, erect, diminished images.', 'emoji': 'Q'},
      {'q': 'P = V^2/R. This is?', 'opts': ['Power formula', 'Ohm law', 'Watt law', 'KVL'], 'ans': 0, 'exp': 'P=V^2/R is derived from P=VI and V=IR.', 'emoji': 'Q'},
      {'q': "Action-reaction is Newton's?", 'opts': ['3rd Law', '1st Law', '2nd Law', '4th Law'], 'ans': 0, 'exp': '3rd Law: Every action has equal & opposite reaction.', 'emoji': 'Q'},
      {'q': 'Magnetic field SI unit?', 'opts': ['Tesla', 'Weber', 'Gauss', 'Henry'], 'ans': 0, 'exp': 'B field is measured in Tesla (T) in SI.', 'emoji': 'Q'},
      {'q': 'Sound cannot travel through?', 'opts': ['Vacuum', 'Water', 'Steel', 'Air'], 'ans': 0, 'exp': 'Sound needs a medium - it cannot travel through vacuum.', 'emoji': 'Q'},
      {'q': "Boyle's Law: P is inversely propl to?", 'opts': ['V', 'T', 'm', 'n'], 'ans': 0, 'exp': 'PV = constant (at const T). P varies 1/V.', 'emoji': 'Q'},
    ],
    'Chemistry': [
      {'q': 'Atomic number of Carbon?', 'opts': ['6', '12', '8', '4'], 'ans': 0, 'exp': 'Carbon has 6 protons, so atomic number = 6.', 'emoji': 'Q'},
      {'q': 'H2O is the formula for?', 'opts': ['Water', 'Oxygen', 'Acid', 'Salt'], 'ans': 0, 'exp': 'H2O is Water.', 'emoji': 'Q'},
      {'q': 'pH of neutral water?', 'opts': ['7', '0', '14', '5'], 'ans': 0, 'exp': 'Neutral water has pH 7.', 'emoji': 'Q'},
      {'q': 'Symbol for Gold?', 'opts': ['Au', 'Go', 'Ag', 'Gd'], 'ans': 0, 'exp': 'Au from Latin Aurum.', 'emoji': 'Q'},
      {'q': 'Lightest element?', 'opts': ['Hydrogen', 'Helium', 'Lithium', 'Carbon'], 'ans': 0, 'exp': 'Hydrogen is the lightest.', 'emoji': 'Q'},
    ],
    'Data Structures': [
      {'q': 'Which data structure follows LIFO?', 'opts': ['Stack', 'Queue', 'Linked List', 'Array'], 'ans': 0, 'exp': 'Stack is Last-In First-Out (LIFO).', 'emoji': 'Q'},
      {'q': 'Time complexity of searching in a Binary Search Tree (average)?', 'opts': ['O(log n)', 'O(n)', 'O(1)', 'O(n log n)'], 'ans': 0, 'exp': 'BST search is O(log n) on average.', 'emoji': 'Q'},
      {'q': 'Which structure is used for BFS of a graph?', 'opts': ['Queue', 'Stack', 'Heap', 'Tree'], 'ans': 0, 'exp': 'Breadth-First Search uses a Queue.', 'emoji': 'Q'},
      {'q': 'Array index starts from?', 'opts': ['0', '1', '-1', 'Any'], 'ans': 0, 'exp': 'In most languages, arrays are 0-indexed.', 'emoji': 'Q'},
      {'q': 'Complexity of inserting at the end of a dynamic array (amortized)?', 'opts': ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'], 'ans': 0, 'exp': 'Insertion at the end is O(1) amortized.', 'emoji': 'Q'},
      {'q': 'Which DS uses a Hash Function?', 'opts': ['Hash Map', 'Linked List', 'Stack', 'AVL Tree'], 'ans': 0, 'exp': 'Hash Map (or Hash Table) uses hash functions.', 'emoji': 'Q'},
      {'q': 'What is the full form of STL in C++?', 'opts': ['Standard Template Library', 'Simple Tool Library', 'System Test Logic', 'None'], 'ans': 0, 'exp': 'STL stands for Standard Template Library.', 'emoji': 'Q'},
      {'q': 'Which DS is used in recursion?', 'opts': ['Stack', 'Queue', 'Deque', 'Priority Queue'], 'ans': 0, 'exp': 'Recursion uses the system Stack.', 'emoji': 'Q'},
      {'q': 'In a Linked List, what do we call the first node?', 'opts': ['Head', 'Tail', 'Root', 'Start'], 'ans': 0, 'exp': 'The first node is the Head.', 'emoji': 'Q'},
      {'q': 'Priority Queue is usually implemented using?', 'opts': ['Heap', 'Stack', 'Queue', 'Array'], 'ans': 0, 'exp': 'Heaps are used to implement Priority Queues.', 'emoji': 'Q'},
    ],
    'Java': [
      {'q': 'How many primitive data types are in Java?', 'opts': ['8', '6', '10', '4'], 'ans': 0, 'exp': 'Java has 8: byte, short, int, long, float, double, char, boolean.', 'emoji': 'Q'},
      {'q': 'Which keyword is used to inherit a class?', 'opts': ['extends', 'implements', 'inherits', 'using'], 'ans': 0, 'exp': 'extends is used for class inheritance.', 'emoji': 'Q'},
      {'q': 'Final variables are?', 'opts': ['Constant', 'Mutable', 'Global', 'Static'], 'ans': 0, 'exp': 'The final keyword makes a variable constant.', 'emoji': 'Q'},
    ],
    'Python': [
      {'q': 'Which is used to define a function?', 'opts': ['def', 'func', 'function', 'lambda'], 'ans': 0, 'exp': 'def is used for function definitions.', 'emoji': 'Q'},
      {'q': 'Is Python case-sensitive?', 'opts': ['Yes', 'No', 'Sometimes', 'Platform dependent'], 'ans': 0, 'exp': 'Python is a case-sensitive language.', 'emoji': 'Q'},
    ],
  };

  List<Map<String, dynamic>> _getQuestions(String subject) {
    // Try exact match
    List<Map<String, dynamic>>? bank = _questionBank[subject];
    
    // Try case-insensitive substring or similarity match
    if (bank == null) {
      final subLower = subject.toLowerCase().trim();
      try {
        final key = _questionBank.keys.firstWhere(
          (k) {
            final kLower = k.toLowerCase();
            return kLower.contains(subLower) || subLower.contains(kLower);
          },
        );
        bank = _questionBank[key];
      } catch (e) {
        // More fuzzy check for typos like 'Data Stucutes'
        final key = _questionBank.keys.firstWhere(
          (k) => k.toLowerCase().substring(0, 3) == subLower.substring(0,3),
          orElse: () => _questionBank.keys.first
        );
        bank = _questionBank[key];
      }
    }

    final allQ = List<Map<String, dynamic>>.from(bank!);
    allQ.shuffle();
    return allQ.take(_questionCount).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: sel ? 1.0 : 0.0),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, value, child) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(
                              gradient: sel ? AppColors.futuristicGradient : null,
                              color: sel ? null : (isDark ? const Color(0xFF0F172A) : Colors.white).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(isDark ? 0.05 : 0.4),
                                width: 1.5,
                              ),
                              boxShadow: sel ? [
                                BoxShadow(
                                  color: AppColors.neonCyan.withOpacity(0.4 * value),
                                  blurRadius: 15 * value,
                                  spreadRadius: 1 * value,
                                )
                              ] : [],
                            ),
                            child: Text(
                              s,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: sel ? Colors.white : (isDark ? Colors.white60 : Colors.black54),
                              ),
                            ),
                          );
                        },
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
                    Expanded(child: Text( '${_selectedSubject!} : $_questionCount questions\nExplanations shown for wrong answers', style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5))),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: (isDark ? const Color(0xFF0F172A) : Colors.white).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withOpacity(isDark ? 0.05 : 0.8)),
                        boxShadow: [
                           BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 30)
                        ],
                      ),
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Text(q['emoji'] as String, style: const TextStyle(fontSize: 48)),
                        ),
                        const SizedBox(height: 24),
                        Text(q['q'] as String,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, height: 1.35, letterSpacing: -0.5)),
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
                            color: bg ?? (isDark ? const Color(0xFF0F172A) : Colors.white).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: border.withOpacity(ans != null ? 1.0 : 0.2), 
                              width: 2,
                            ),
                            boxShadow: bg != null ? [
                              BoxShadow(
                                color: border.withOpacity(0.3),
                                blurRadius: 15,
                              )
                            ] : [],
                          ),
                          child: Row(children: [
                            Container(
                              width: 36, height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ans == null ? _optColors[i].withOpacity(0.15) : (i == correct ? const Color(0xFF10B981).withOpacity(0.2) : (i == ans ? const Color(0xFFEF4444).withOpacity(0.2) : Colors.white10)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                String.fromCharCode(65 + i), 
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w900, 
                                  color: ans == null ? _optColors[i] : (i == correct ? const Color(0xFF10B981) : (i == ans ? const Color(0xFFEF4444) : Colors.white38)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Text(label, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w600))),
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
    final String subject = result['subject'];
    final double pct = score / total;
    
    String badge = 'Keep Practicing!';
    Color badgeColor = Colors.orangeAccent;
    if (pct >= 0.9) { badge = 'Mastermind!'; badgeColor = const Color(0xFF2DD4BF); }
    else if (pct >= 0.7) { badge = 'Excellent!'; badgeColor = const Color(0xFF6366F1); }
    else if (pct >= 0.5) { badge = 'Good Job!'; badgeColor = const Color(0xFFC084FC); }

    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Stack(children: [
        const AnimatedMeshBackground(),
        SafeArea(
          child: Column(children: [
            const SizedBox(height: 20),
            FadeInDown(
              child: Text('Quiz Results', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  FadeIn(
                    delay: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: (Theme.of(context).brightness == Brightness.dark ? AppColors.darkSurface : Colors.white).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                        boxShadow: [
                           BoxShadow(
                             color: badgeColor.withOpacity(0.25), 
                             blurRadius: 50, 
                             spreadRadius: -15,
                           )
                        ],
                      ),
                      child: Column(children: [
                        CircularPercentIndicator(
                          radius: 70.0,
                          lineWidth: 12.0,
                          percent: pct,
                          center: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                             Text('${(pct * 100).toInt()}%', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w900)),
                             Text('$score/$total', style: const TextStyle(fontSize: 14, color: Colors.white38)),
                          ]),
                          circularStrokeCap: CircularStrokeCap.round,
                          backgroundColor: Colors.white10,
                          linearGradient: LinearGradient(colors: [badgeColor, badgeColor.withOpacity(0.5)]),
                          animation: true,
                          animationDuration: 1500,
                        ),
                        const SizedBox(height: 24),
                        Text(badge, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w700, color: badgeColor)),
                        const SizedBox(height: 8),
                        Text('Subject: $subject', style: const TextStyle(color: Colors.white38, fontSize: 13)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInLeft(
                    delay: const Duration(milliseconds: 400),
                    child: _buildStatRow(score, total - score, total),
                  ),
                  const SizedBox(height: 40),
                  Row(children: [
                    Text('Detailed Review', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    const Icon(LucideIcons.chevronDown, size: 18, color: Colors.white38),
                  ]),
                  const SizedBox(height: 16),
                  ... (result['questions'] as List).asMap().entries.map((e) {
                    final i = e.key;
                    final q = e.value as Map<String, dynamic>;
                    final userAns = result['answers'][i];
                    final correct = q['ans'] as int;
                    final isCorrect = userAns == correct;
                    
                    return FadeInUp(
                      delay: Duration(milliseconds: 500 + (i * 100)),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isCorrect ? const Color(0xFF10B981).withOpacity(0.2) : const Color(0xFFEF4444).withOpacity(0.2)),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Text('Q${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white38, fontSize: 12)),
                            const Spacer(),
                            Icon(isCorrect ? LucideIcons.checkCircle2 : LucideIcons.xCircle, size: 16, color: isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                          ]),
                          const SizedBox(height: 8),
                          Text(q['q'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          if (!isCorrect)
                             Text('Your: ${(q['opts'] as List)[userAns ?? 0]}', style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13)),
                          Text('Correct: ${(q['opts'] as List)[correct]}', style: const TextStyle(color: Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(q['exp'] as String, style: const TextStyle(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic)),
                        ]),
                      ),
                    );
                  }),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: Text('Done', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildStatRow(int correct, int wrong, int total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(24)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        _statItem('Correct', correct.toString(), const Color(0xFF10B981)),
        _statItem('Wrong', wrong.toString(), const Color(0xFFEF4444)),
        _statItem('Total', total.toString(), const Color(0xFF6366F1)),
      ]),
    );
  }

  Widget _statItem(String label, String val, Color c) {
    return Column(children: [
      Text(val, style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800, color: c)),
      Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
    ]);
  }
}

class QuizReportTab extends StatelessWidget {
  final List<Map<String, dynamic>> quizHistory;
  const QuizReportTab({super.key, required this.quizHistory});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (quizHistory.isEmpty) {
      return Stack(children: [
        const AnimatedMeshBackground(),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.zap, size: 64, color: (isDark ? Colors.white10 : Colors.black.withOpacity(0.1))),
              const SizedBox(height: 16),
              Text('No quiz history yet.', style: GoogleFonts.outfit(color: isDark ? Colors.white24 : Colors.black26, fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ]);
    }

    final subjects = quizHistory.map((e) => e['subject'] as String).toSet().toList();
    
    return Stack(children: [
      const AnimatedMeshBackground(),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Glass Island Performance Header
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 4),
                  builder: (context, value, child) {
                    final offset = math.sin(value * math.pi * 2) * 8;
                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: child,
                    );
                  },
                  child: FadeInDown(
                    duration: const Duration(milliseconds: 1000),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withOpacity(isDark ? 0.08 : 0.4)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.8),
                            (isDark ? const Color(0xFF0F172A) : Colors.white).withOpacity(0.5),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonFuchsia.withOpacity(isDark ? 0.15 : 0.05),
                            blurRadius: 40,
                            offset: const Offset(0, 15),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Performance',
                                style: GoogleFonts.outfit(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.2,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Your learning progress at a glance',
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white54 : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const _SectionHeader(title: 'Subject Mastery', subtitle: 'Average score across sessions'),
                    const SizedBox(height: 16),
                    ...subjects.map((sub) {
                      final subHistory = quizHistory.where((e) => e['subject'] == sub).toList();
                      final avgScore = subHistory.fold(0.0, (p, e) => p + (e['score'] / e['total'])) / subHistory.length;
                      return FadeInRight(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: (isDark ? AppColors.darkSurface : Colors.white).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: Colors.white.withOpacity(isDark ? 0.08 : 0.4)),
                            boxShadow: [
                              BoxShadow(
                                color: (avgScore > 0.7 ? AppColors.emerald : AppColors.primary).withOpacity(0.15),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(sub, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 18)),
                                  const Spacer(),
                                  Text(
                                    '${(avgScore * 100).toInt()}%',
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      color: avgScore > 0.7 ? AppColors.emerald : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: avgScore,
                                  minHeight: 10,
                                  backgroundColor: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
                                  valueColor: AlwaysStoppedAnimation(avgScore > 0.7 ? AppColors.emerald : AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 32),
                    const _SectionHeader(title: 'Recent Sessions', subtitle: 'Detailed quiz breakdown'),
                    const SizedBox(height: 12),
                    ...quizHistory.reversed.take(5).map((h) => FadeInLeft(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.darkSurface.withOpacity(0.4) : Colors.white.withOpacity(0.6)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(LucideIcons.zap, size: 20, color: AppColors.primary),
                          ),
                          title: Text(h['subject'], style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
                          subtitle: Text(h['date'].toString().split('T')[0], style: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 12)),
                          trailing: Text(
                            '${h['score']}/${h['total']}',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.primary),
                          ),
                        ),
                      ),
                    )),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

// --- Settings Section ---


class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Stack(children: [
      const AnimatedMeshBackground(),
      SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              // Glass Island Settings Header
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withOpacity(isDark ? 0.05 : 0.4)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        (isDark ? const Color(0xFF1E293B) : Colors.white).withOpacity(0.7),
                        (isDark ? const Color(0xFF0F172A) : Colors.white).withOpacity(0.4),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings',
                            style: GoogleFonts.outfit(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.2,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Personalize your study experience',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              _buildSectionTitle('App Theme'),
              const SizedBox(height: 12),
              _buildSettingCard(
                context: context,
                icon: isDark ? LucideIcons.moon : LucideIcons.sun,
                title: 'Dark Mode',
                subtitle: isDark ? 'Sleek & modern' : 'Bright & clear',
                trailing: Switch.adaptive(
                  value: isDark,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              _buildSectionTitle('Notifications'),
              const SizedBox(height: 12),
              _buildSettingCard(
                context: context,
                icon: LucideIcons.bell,
                title: 'Study Reminders',
                subtitle: 'Never miss a session',
                trailing: Switch.adaptive(
                  value: true, 
                  activeColor: AppColors.primary,
                  onChanged: (v) {},
                ),
              ),
              
              const SizedBox(height: 24),
              _buildSectionTitle('Account'),
              const SizedBox(height: 12),
              _buildSettingCard(
                context: context,
                icon: LucideIcons.user,
                title: 'Profile Settings',
                subtitle: 'Update your info',
                trailing: Icon(LucideIcons.chevronRight, size: 18, color: (isDark ? Colors.white24 : Colors.black26)),
              ),
              const SizedBox(height: 12),
              _buildSettingCard(
                context: context,
                icon: LucideIcons.logOut,
                title: 'Sign Out',
                subtitle: 'Securely leave session',
                titleColor: Colors.redAccent,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (c) => const AuthScreen())
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: const Color(0xFF6366F1).withOpacity(0.8),
      ),
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.darkSurface : Colors.white).withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(isDark ? 0.05 : 0.4)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: titleColor ?? const Color(0xFF6366F1), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: titleColor)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
