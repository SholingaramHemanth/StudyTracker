import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:math' as math;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'app_shared.dart';
import 'original_app.dart';

// --- PREMIUM DESIGN SYSTEM ---
class PremiumTheme {
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color secondary = Color(0xFF8B5CF6); // Violet
  static const Color accent = Color(0xFFD946EF); // Fuchsia
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color textMain = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF64748B);

  static LinearGradient premiumGradient = const LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 20,
      offset: const Offset(0, 10),
    )
  ];

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
    ),
    textTheme: GoogleFonts.outfitTextTheme().apply(bodyColor: textMain, displayColor: textMain),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF020617),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.outfitTextTheme().apply(bodyColor: Colors.white, displayColor: Colors.white),
  );
}

// --- 1. SPLASH SCREEN ---
class PremiumSplashScreen extends StatefulWidget {
  const PremiumSplashScreen({super.key});

  @override
  State<PremiumSplashScreen> createState() => _PremiumSplashScreenState();
}

class _PremiumSplashScreenState extends State<PremiumSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => const PremiumOnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: PremiumTheme.premiumGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElasticIn(
              duration: const Duration(seconds: 2),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 40, spreadRadius: 10)
                  ],
                ),
                child: const Icon(LucideIcons.graduationCap, size: 80, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            FadeInUp(
              duration: const Duration(milliseconds: 1500),
              child: Column(
                children: [
                  Text(
                    'Study Tracker',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Master your learning path with AI',
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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

// --- 2. ONBOARDING SCREEN ---
class PremiumOnboardingScreen extends StatefulWidget {
  const PremiumOnboardingScreen({super.key});

  @override
  State<PremiumOnboardingScreen> createState() => _PremiumOnboardingScreenState();
}

class _PremiumOnboardingScreenState extends State<PremiumOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _data = [
    {
      'title': 'Smart Learning',
      'desc': 'Leverage AI to create personalized study plans that adapt to your progress.',
      'img': 'assets/onboarding_1.png',
    },
    {
      'title': 'Focus Better',
      'desc': 'Manage your time effectively with our integrated Pomodoro timers and task lists.',
      'img': 'assets/onboarding_2.png',
    },
    {
      'title': 'Track Growth',
      'desc': 'Visualize your learning journey with detailed analytics and daily insights.',
      'img': 'assets/onboarding_3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (v) => setState(() => _currentPage = v),
            itemCount: _data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      child: Container(
                        height: 350,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(_data[index]['img']!),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    FadeInUp(
                      child: Column(
                        children: [
                          Text(
                            _data[index]['title']!,
                            style: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.w800, height: 1.1),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _data[index]['desc']!,
                            style: GoogleFonts.outfit(fontSize: 17, color: PremiumTheme.textLight, height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(_data.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 8,
                      width: _currentPage == index ? 32 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? PremiumTheme.primary : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                GestureDetector(
                  onTap: () {
                    if (_currentPage < _data.length - 1) {
                      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                    } else {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const PremiumLoginScreen()));
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: PremiumTheme.premiumGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: PremiumTheme.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          _currentPage == _data.length - 1 ? 'Start' : 'Next',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(LucideIcons.arrowRight, color: Colors.white, size: 18),
                      ],
                    ),
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

// --- 3. LOGIN SCREEN ---
class PremiumLoginScreen extends StatelessWidget {
  const PremiumLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/premium_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const _AnimatedParticles(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    FadeInDown(
                      duration: const Duration(seconds: 1),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.graduationCap, size: 50, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ZoomIn(
                      duration: const Duration(milliseconds: 600),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Welcome Back',
                                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Sign in to your study space',
                                  style: GoogleFonts.outfit(color: Colors.white70, fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                _inputField(LucideIcons.mail, 'Email Address'),
                                const SizedBox(height: 20),
                                _inputField(LucideIcons.lock, 'Password', obscure: true),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text('Forgot Password?', style: TextStyle(color: Colors.white70)),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton(
                                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const PremiumMainScreen())),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: PremiumTheme.premiumGradient,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(color: PremiumTheme.primary.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                                    Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('OR', style: TextStyle(color: Colors.white.withOpacity(0.3)))),
                                    Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(LucideIcons.chrome, size: 20, color: Colors.white),
                                  label: const Text('Continue with Google', style: TextStyle(color: Colors.white)),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    side: BorderSide(color: Colors.white.withOpacity(0.2)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    FadeIn(
                      delay: const Duration(seconds: 1),
                      child: TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const PremiumSignUpScreen())),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.outfit(color: Colors.white),
                            children: const [
                              TextSpan(text: "Don't have an account? "),
                              TextSpan(text: "Create One", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(IconData icon, String hint, {bool obscure = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.white60, size: 20),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white30),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// --- 4. SIGN UP SCREEN ---
class PremiumSignUpScreen extends StatelessWidget {
  const PremiumSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeInLeft(
              child: Text(
                'Create Your\nPremium Account',
                style: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.w800, height: 1.1),
              ),
            ),
            const SizedBox(height: 12),
            FadeInLeft(
              delay: const Duration(milliseconds: 200),
              child: const Text('Join the future of productivity', style: TextStyle(color: PremiumTheme.textLight, fontSize: 17)),
            ),
            const SizedBox(height: 40),
            Center(
              child: Stack(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: PremiumTheme.primary.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: Border.all(color: PremiumTheme.primary.withOpacity(0.1), width: 2),
                    ),
                    child: const Icon(LucideIcons.user, size: 40, color: PremiumTheme.primary),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: PremiumTheme.primary, shape: BoxShape.circle),
                      child: const Icon(LucideIcons.camera, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _inputField('Full Name', LucideIcons.user),
            const SizedBox(height: 20),
            _inputField('Email Address', LucideIcons.mail),
            const SizedBox(height: 20),
            _inputField('Password', LucideIcons.lock, obscure: true),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const PremiumMainScreen())),
              style: ElevatedButton.styleFrom(
                backgroundColor: PremiumTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, IconData icon, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            obscureText: obscure,
            decoration: InputDecoration(
              icon: Icon(icon, color: Colors.grey[400], size: 20),
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

// --- MAIN WRAPPER (NAV BAR) ---
class PremiumMainScreen extends StatefulWidget {
  const PremiumMainScreen({super.key});

  @override
  State<PremiumMainScreen> createState() => _PremiumMainScreenState();
}

class _PremiumMainScreenState extends State<PremiumMainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const PremiumHomeScreen(),
    const PremiumSubjectsScreen(),
    const PremiumTimerScreen(),
    const PremiumAITutorScreen(),
    const PremiumProgressScreen(),
    const PremiumProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (i) => setState(() => _selectedIndex = i),
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF1E293B),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.4),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(icon: Icon(LucideIcons.layoutGrid), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(LucideIcons.bookOpen), label: 'Subjects'),
              BottomNavigationBarItem(icon: Icon(LucideIcons.clock), label: 'Timer'),
              BottomNavigationBarItem(icon: Icon(LucideIcons.sparkles), label: 'AI Tutor'),
              BottomNavigationBarItem(icon: Icon(LucideIcons.barChart2), label: 'Stats'),
              BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 5. HOME DASHBOARD ---
class PremiumHomeScreen extends StatelessWidget {
  const PremiumHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hello, Alex!', style: GoogleFonts.outfit(fontSize: 16, color: PremiumTheme.textLight)),
                            Text('Ready to excel?', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: PremiumTheme.softShadow),
                          child: const Icon(LucideIcons.bell, size: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProgressCard(),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Today\'s Plan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: const Text('View All')),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPlanCard('Advanced Mathematics', '09:00 AM - 10:30 AM', 0.6),
                const SizedBox(height: 16),
                _buildPlanCard('Data Structures', '11:00 AM - 12:30 PM', 0.2),
                const SizedBox(height: 32),
                const Text('Recent Subjects', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildSubjectGrid(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: PremiumTheme.premiumGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: PremiumTheme.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Daily Goal', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Text('75% Completed', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: const Row(
                  children: [
                    Icon(LucideIcons.flame, color: Colors.orange, size: 16),
                    SizedBox(width: 4),
                    Text('12 Days', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation(Colors.white),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem(LucideIcons.clock, '4.5 hrs', 'Focus Time'),
              _statItem(LucideIcons.checkCircle, '8/10', 'Tasks Done'),
              _statItem(LucideIcons.zap, 'High', 'Efficiency'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String val, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }

  Widget _buildPlanCard(String title, String time, double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: PremiumTheme.softShadow),
      child: Row(
        children: [
          Container(
            height: 48, width: 48,
            decoration: BoxDecoration(color: PremiumTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(LucideIcons.book, color: PremiumTheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(time, style: const TextStyle(color: PremiumTheme.textLight, fontSize: 12)),
              ],
            ),
          ),
          CircularProgressIndicator(value: progress, strokeWidth: 4, backgroundColor: Colors.grey[100]),
        ],
      ),
    );
  }

  Widget _buildSubjectGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _subjectTile('History', LucideIcons.landmark, Colors.orange),
        _subjectTile('Biology', LucideIcons.beaker, Colors.green),
        _subjectTile('Physics', LucideIcons.atom, Colors.blue),
        _subjectTile('Coding', LucideIcons.code, const Color(0xFFD946EF)),
      ],
    );
  }

  Widget _subjectTile(String name, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: PremiumTheme.softShadow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// --- 6. SUBJECTS SCREEN ---
class PremiumSubjectsScreen extends StatelessWidget {
  const PremiumSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [IconButton(icon: const Icon(LucideIcons.plusCircle, color: PremiumTheme.primary), onPressed: () {})],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(LucideIcons.search, size: 20, color: Colors.grey),
                  hintText: 'Search subjects...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: 5,
              itemBuilder: (context, index) {
                return FadeInUp(
                  delay: Duration(milliseconds: index * 100),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF0F172A) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: PremiumTheme.softShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 56, width: 56,
                          decoration: BoxDecoration(gradient: PremiumTheme.premiumGradient, borderRadius: BorderRadius.circular(16)),
                          child: const Icon(LucideIcons.bookOpen, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Computer Science', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const Text('12 sessions • 24 hrs total', style: TextStyle(color: PremiumTheme.textLight, fontSize: 13)),
                              const SizedBox(height: 12),
                              ClipRRect(borderRadius: BorderRadius.circular(4), child: const LinearProgressIndicator(value: 0.6, minHeight: 6)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(LucideIcons.chevronRight, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- 7. STUDY SESSION (POMODORO) ---
class PremiumTimerScreen extends StatefulWidget {
  const PremiumTimerScreen({super.key});

  @override
  State<PremiumTimerScreen> createState() => _PremiumTimerScreenState();
}

class _PremiumTimerScreenState extends State<PremiumTimerScreen> {
  int _secondsRemaining = 25 * 60;
  bool _isActive = false;
  Timer? _timer;

  void _toggleTimer() {
    if (_isActive) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _timer?.cancel();
            _isActive = false;
          }
        });
      });
    }
    setState(() => _isActive = !_isActive);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _secondsRemaining = 25 * 60;
    });
  }

  String _formatTime(int seconds) {
    final mins = (seconds / 60).floor().toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    const totalSeconds = 25 * 60;
    final progress = 1 - (_secondsRemaining / totalSeconds);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: PremiumTheme.premiumGradient),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text('Focus Mode', style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Quantum Computing', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16)),
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 300, width: 300,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    children: [
                      Text(_formatTime(_secondsRemaining), style: GoogleFonts.outfit(color: Colors.white, fontSize: 72, fontWeight: FontWeight.w900, letterSpacing: -2)),
                      Text('MINUTES LEFT', style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _timerAction(LucideIcons.rotateCcw, _resetTimer),
                    GestureDetector(
                      onTap: _toggleTimer,
                      child: Container(
                        height: 80, width: 80,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: Icon(_isActive ? LucideIcons.pause : LucideIcons.play, size: 32, color: PremiumTheme.primary),
                      ),
                    ),
                    _timerAction(LucideIcons.skipForward, () {}),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timerAction(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 28),
    );
  }
}

// --- 8.5. AI TUTOR (GEMINI) ---
class PremiumAITutorScreen extends StatefulWidget {
  const PremiumAITutorScreen({super.key});

  @override
  State<PremiumAITutorScreen> createState() => _PremiumAITutorScreenState();
}

class _PremiumAITutorScreenState extends State<PremiumAITutorScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Hello! I am your AI Tutor. How can I help you master your studies today?',
    }
  ];
  bool _isLoading = false;
  late final GenerativeModel _model;
  late ChatSession _chat;
  
  String _selectedModel = 'Gemini 1.5';
  final List<String> _availableModels = ['Gemini 1.5', 'ChatGPT (OpenAI)', 'LLaMA 3 (Meta)'];

  @override
  void initState() {
    super.initState();
    // Using the API key provided in the project's .env.local
    const apiKey = 'AIzaSyDfd2RsChCBDsUupgnWfsWJ8vrBOw0hvWQ';
    _model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    _chat = _model.startChat();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'isUser': true, 'text': text});
      _isLoading = true;
      _controller.clear();
    });

    try {
      String promptText = text;
      if (_selectedModel.contains('LLaMA')) {
        promptText = "Pretend you are LLaMA 3 by Meta. $text";
      } else if (_selectedModel.contains('ChatGPT')) {
        promptText = "Pretend you are ChatGPT, a large language model trained by OpenAI. Respond thoughtfully and accurately like ChatGPT. $text";
      }

      final response = await _chat.sendMessage(Content.text(promptText));
      setState(() {
        _messages.add({'isUser': false, 'text': response.text ?? 'Sorry, I couldn\'t process that.'});
      });
    } catch (e) {
      setState(() {
        _messages.add({'isUser': false, 'text': 'Error: ${e.toString()}'});
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: PremiumTheme.premiumGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.sparkles, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Study Tutor', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedModel,
                    icon: const Icon(LucideIcons.chevronDown, size: 14, color: PremiumTheme.primary),
                    isDense: true,
                    style: const TextStyle(color: PremiumTheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
                    items: _availableModels.map((String model) {
                      return DropdownMenuItem<String>(
                        value: model,
                        child: Text(model),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedModel = newValue;
                          // Optional: Clear chat on model switch or just notify
                          _messages.add({'isUser': false, 'text': 'Switched to $newValue model.'});
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(LucideIcons.trash2, color: Colors.grey), onPressed: () {
            setState(() {
              _messages.clear();
              _messages.add({'isUser': false, 'text': 'Chat cleared. How can I help?'});
              _chat = _model.startChat();
            });
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg['text'], msg['isUser']);
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: FadeIn(child: const Text('AI is thinking...', style: TextStyle(color: PremiumTheme.textLight, fontSize: 12, fontStyle: FontStyle.italic))),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUser ? PremiumTheme.primary : Colors.white,
            gradient: isUser ? PremiumTheme.premiumGradient : null,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
              bottomRight: isUser ? Radius.zero : const Radius.circular(20),
            ),
            boxShadow: PremiumTheme.softShadow,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isUser ? Colors.white : PremiumTheme.textMain,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Ask your AI Tutor...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                height: 48, width: 48,
                decoration: BoxDecoration(
                  gradient: PremiumTheme.premiumGradient,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: PremiumTheme.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: const Icon(LucideIcons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 9. PROGRESS / ANALYTICS ---
class PremiumProgressScreen extends StatelessWidget {
  const PremiumProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildChartMockup(),
            const SizedBox(height: 32),
            _buildDetailStats(),
            const SizedBox(height: 32),
            _buildHeatmapMockup(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartMockup() {
    return Container(
      height: 250, width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), boxShadow: PremiumTheme.softShadow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Study Hours', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Text('Last 7 days', style: TextStyle(color: PremiumTheme.textLight, fontSize: 12)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _bar(0.4), _bar(0.7), _bar(0.9), _bar(0.6), _bar(0.8), _bar(1.0), _bar(0.5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bar(double h) {
    return Container(
      width: 24,
      height: 120 * h,
      decoration: BoxDecoration(gradient: PremiumTheme.premiumGradient, borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildDetailStats() {
    return Row(
      children: [
        Expanded(child: _statBox('128', 'Total Hours', LucideIcons.clock, Colors.blue)),
        const SizedBox(width: 16),
        Expanded(child: _statBox('42', 'Completed', LucideIcons.checkCircle, Colors.green)),
      ],
    );
  }

  Widget _statBox(String val, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: PremiumTheme.softShadow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 16),
          Text(val, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: PremiumTheme.textLight, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildHeatmapMockup() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Consistency Map', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: List.generate(21, (index) {
              return Container(
                height: 16, width: 16,
                decoration: BoxDecoration(
                  color: index % 3 == 0 ? PremiumTheme.primary.withOpacity(0.8) : Colors.white10,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// --- 9. PROFILE SCREEN ---
class PremiumProfileScreen extends StatelessWidget {
  const PremiumProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 130, width: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: PremiumTheme.primary.withOpacity(0.1), width: 8),
                    ),
                  ),
                  const CircleAvatar(radius: 50, backgroundColor: PremiumTheme.primary, child: Icon(LucideIcons.user, size: 40, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Alex Thompson', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text('Computer Science Student', style: TextStyle(color: PremiumTheme.textLight)),
            const SizedBox(height: 40),
            _profileOption(context, LucideIcons.settings, 'Account Settings'),
            _profileOption(context, LucideIcons.moon, 'Night Mode', isSwitch: true),
            _profileOption(context, LucideIcons.bellRing, 'Notifications'),
            _profileOption(context, LucideIcons.shieldCheck, 'Privacy Policy'),
            _profileOption(context, LucideIcons.helpCircle, 'Help & Support'),
            const Divider(height: 60),
            _profileOption(context, LucideIcons.logOut, 'Log Out', color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _profileOption(BuildContext context, IconData icon, String title, {bool isSwitch = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: (color ?? PremiumTheme.primary).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color ?? PremiumTheme.primary, size: 20),
          ),
          const SizedBox(width: 20),
          Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: color)),
          const Spacer(),
          isSwitch 
              ? ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (_, mode, __) {
                    return Switch(
                      value: mode == ThemeMode.dark,
                      onChanged: (v) {
                        themeNotifier.value = v ? ThemeMode.dark : ThemeMode.light;
                      },
                      activeThumbColor: PremiumTheme.primary,
                    );
                  },
                )
              : Icon(LucideIcons.chevronRight, color: Colors.grey[400], size: 18),
        ],
      ),
    );
  }
}

// --- HELPERS ---
class _AnimatedParticles extends StatefulWidget {
  const _AnimatedParticles();
  @override
  State<_AnimatedParticles> createState() => _AnimatedParticlesState();
}

class _AnimatedParticlesState extends State<_AnimatedParticles> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
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
      builder: (context, _) => CustomPaint(painter: _ParticlePainter(_ctrl.value)),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  _ParticlePainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.1);
    for (int i = 0; i < 20; i++) {
      final x = (math.sin(i * 200 + progress * 2 * math.pi) * 0.5 + 0.5) * size.width;
      final y = (math.cos(i * 500 + progress * 2 * math.pi) * 0.5 + 0.5) * size.height;
      canvas.drawCircle(Offset(x, y), 2 + (i % 5).toDouble(), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
