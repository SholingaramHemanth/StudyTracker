import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:percent_indicator/percent_indicator.dart';
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
  Offset _mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MouseRegion(
        onHover: (event) => setState(() => _mousePos = event.localPosition),
        child: Stack(
          children: [
            const AnimatedMeshBackground(),
            
            // Grid Overlay
            Opacity(
              opacity: 0.05,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const NetworkImage('https://www.transparenttextures.com/patterns/carbon-fibre.png'),
                    repeat: ImageRepeat.repeat,
                    colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.srcIn),
                  ),
                ),
              ),
            ),

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
                                                pageBuilder: (context, animation, second) => const DashboardScreen(),
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
  const DashboardScreen({super.key});

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
        padding: const EdgeInsets.symmetric(vertical: 12),
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
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(LucideIcons.layoutDashboard, size: 22), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.bookOpen, size: 22), label: 'Study'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.bot, size: 22), label: 'AI Coach'),
            BottomNavigationBarItem(icon: Icon(LucideIcons.user, size: 22), label: 'Profile'),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeTab(),
          Center(child: Text('Courses Screen')),
          AICoachTab(),
          Center(child: Text('Profile Screen')),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          stretch: true,
          backgroundColor: const Color(0xFF020617),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 24, bottom: 20),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome back,', style: TextStyle(fontSize: 12, color: Colors.white54)),
                Text('Hemanth B', style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 24)),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.05),
                child: IconButton(onPressed: () {}, icon: const Icon(LucideIcons.bell, size: 20, color: Colors.white)),
              ),
            )
          ],
        ),
        
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Progress Card
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF6366F1).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Daily Goal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                              Text('3 of 4 sessions done', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                          CircularPercentIndicator(
                            radius: 35,
                            lineWidth: 8,
                            percent: 0.75,
                            center: const Text('75%', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            progressColor: Colors.white,
                            backgroundColor: Colors.white24,
                            circularStrokeCap: CircularStrokeCap.round,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              const Text('Active Statistics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: _StatBox(label: 'Focus', value: '4.5h', icon: LucideIcons.timer, color: Colors.blueAccent)),
                  const SizedBox(width: 16),
                  Expanded(child: _StatBox(label: 'Streak', value: '12d', icon: LucideIcons.flame, color: Colors.orangeAccent)),
                ],
              ),

              const SizedBox(height: 32),
              _AICoachBanner(context),
              const SizedBox(height: 48),
            ]),
          ),
        )
      ],
    );
  }

  Widget _StatBox({required String label, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: Colors.white38, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _AICoachBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF2DD4BF).withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(LucideIcons.sparkles, color: Color(0xFF2DD4BF), size: 24),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Study Assistant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                Text('Instant doubt solving', style: TextStyle(color: Colors.white38, fontSize: 13)),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, color: Colors.white24),
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
