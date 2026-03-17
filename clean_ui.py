
import sys

def cleanup(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    # We want to keep the file until line 3269 (1-indexed)
    # But wait, we need to check if QuizTab, QuizScreen, QuizResultScreen are intact before 3269.
    # Yes, they are at 2610, 2845, 3047.
    
    # Let's keep up to line 3269.
    new_lines = lines[:3269]
    
    # Now check if we have the SettingsTab. It was at the very end usually.
    # Let's just find the last clean ending and append what we need.
    
    content = "".join(new_lines)
    
    # Append SettingsTab if not present
    if "class SettingsTab" not in content:
        settings_code = """
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              FadeInDown(
                child: Text('Settings', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              const Text('Personalize your study experience', style: TextStyle(color: Colors.white54)),
              const SizedBox(height: 32),
              
              _buildSectionTitle('App Theme'),
              const SizedBox(height: 12),
              _buildSettingCard(
                icon: isDark ? LucideIcons.moon : LucideIcons.sun,
                title: 'Dark Mode',
                subtitle: isDark ? 'Sleek & modern' : 'Bright & clear',
                trailing: Switch.adaptive(
                  value: isDark,
                  activeColor: const Color(0xFF6366F1),
                  onChanged: (val) {
                    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              _buildSectionTitle('Notifications'),
              const SizedBox(height: 12),
              _buildSettingCard(
                icon: LucideIcons.bell,
                title: 'Study Reminders',
                subtitle: 'Never miss a session',
                trailing: Switch.adaptive(value: true, onChanged: (v) {}),
              ),
              
              const SizedBox(height: 24),
              _buildSectionTitle('Account'),
              const SizedBox(height: 12),
              _buildSettingCard(
                icon: LucideIcons.user,
                title: 'Profile Settings',
                subtitle: 'Update your info',
                trailing: const Icon(LucideIcons.chevronRight, size: 18, color: Colors.white24),
              ),
              const SizedBox(height: 12),
              _buildSettingCard(
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
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
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
"""
        content += settings_code
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == "__main__":
    cleanup(sys.argv[1])
