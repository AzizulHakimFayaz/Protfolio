import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';
import 'package:protfolio_website/Widgets/scroll_animated_item.dart';
import 'package:protfolio_website/Widgets/skill_bar.dart';
import 'package:protfolio_website/Widgets/github_stats_card.dart';
import 'package:protfolio_website/Widgets/modern_project_card.dart';
import 'package:protfolio_website/Widgets/connected_cards_section.dart';
import 'package:protfolio_website/Widgets/ai_chat_section.dart';
import 'package:protfolio_website/Widgets/floating_nav_bar.dart';
import 'package:protfolio_website/Widgets/timeline_experience.dart';
import 'Particle_effect/color_inverting_particles.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PortfolioParticlePage(),
    ),
  );
}

class PortfolioParticlePage extends StatefulWidget {
  const PortfolioParticlePage({super.key});

  @override
  State<PortfolioParticlePage> createState() => _PortfolioParticlePageState();
}

class _PortfolioParticlePageState extends State<PortfolioParticlePage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;
  bool _isDarkMode = true; // Theme state

  // Keys for scrolling to specific sections
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _chatKey = GlobalKey();

  void _scrollToSection(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final key = [
      _homeKey,
      _aboutKey,
      _skillsKey,
      _projectsKey,
      _chatKey,
    ][index];

    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _isDarkMode
              ? const RadialGradient(
                  center: Alignment(0.0, -0.2),
                  radius: 1.5,
                  colors: [Color(0xFF1A0B2E), Color(0xFF050505)],
                  stops: [0.0, 0.6],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFF5E1), // Soft cream
                    Color(0xFFFFE4E1), // Misty rose
                    Color(0xFFF0E6FA), // Light lavender
                    Color(0xFFE8F4F8), // Pale cyan
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
        ),
        child: Stack(
          children: [
            // 1. Background Particles
            const Positioned.fill(child: ColorInvertingParticles()),

            // 2. Scrollable Content
            SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Centered layout
                  children: [
                    const SizedBox(height: 80),

                    // --- HERO SECTION ---
                    Container(
                      key: _homeKey,
                      margin: const EdgeInsets.only(bottom: 180),
                      child: ScrollAnimatedItem(
                        index: 0,
                        child: Column(
                          children: [
                            const Text(
                              "HELLO! I AM AZIZUL HAKIM",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFE040FB), // Purple accent
                                letterSpacing: 3.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "A Developer who\nJudges a book\nby its cover...",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w900,
                                color: _isDarkMode
                                    ? Colors.white
                                    : Colors.black87,
                                letterSpacing: -1.0,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Because if the cover does not impress you what else can?",
                              style: TextStyle(
                                fontSize: 16,
                                color: _isDarkMode
                                    ? Colors.white.withValues(alpha: 0.6)
                                    : Colors.black.withValues(alpha: 0.6),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 60),
                            const ConnectedCardsSection(),
                          ],
                        ),
                      ),
                    ),

                    // --- ABOUT SECTION ---
                    Container(
                      key: _aboutKey,
                      margin: const EdgeInsets.only(bottom: 180),
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: ScrollAnimatedItem(
                        index: 1,
                        child: Column(
                          children: [
                            _buildSectionTitle("I'm a Software Engineer."),
                            const SizedBox(height: 30),
                            GlassEffectContainer(
                              width: double.infinity,
                              padding: const EdgeInsets.all(40),
                              child: Text(
                                "Currently, I'm a Software Engineer at Tech Innovators Ltd.\n\nA self-taught Mobile App Developer, functioning in the industry for 3+ years now. I make meaningful and delightful digital products that create an equilibrium between user needs and business goals.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  height: 1.6,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- SKILLS SECTION ---
                    Container(
                      key: _skillsKey,
                      margin: const EdgeInsets.only(bottom: 180),
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: ScrollAnimatedItem(
                        index: 2,
                        child: Column(
                          children: [
                            _buildSectionTitle("Technical Arsenal"),
                            const SizedBox(height: 40),
                            GlassEffectContainer(
                              width: double.infinity,
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: const [
                                  SkillBar(
                                    skillName: "Flutter & Dart",
                                    percentage: 0.95,
                                  ),
                                  SkillBar(
                                    skillName: "Native Android (Kotlin) & iOS",
                                    percentage: 0.80,
                                    color: Color(0xFFE040FB),
                                  ),
                                  SkillBar(
                                    skillName: "Problem Solving (DSA)",
                                    percentage: 0.90,
                                    color: Color(0xFF00E5FF),
                                  ),
                                  SkillBar(
                                    skillName: "AI Integration (TF Lite)",
                                    percentage: 0.75,
                                    color: Color(0xFFE040FB),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- GITHUB STATS ---
                    Container(
                      margin: const EdgeInsets.only(bottom: 180),
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: ScrollAnimatedItem(
                        index: 3,
                        child: const GitHubStatsCard(),
                      ),
                    ),

                    // --- PROJECTS SECTION ---
                    Container(
                      key: _projectsKey,
                      margin: const EdgeInsets.only(bottom: 180),
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: ScrollAnimatedItem(
                        index: 4,
                        child: Column(
                          children: [
                            _buildSectionTitle("Featured Work"),
                            const SizedBox(height: 50),
                            // Vertical List of Modern Cards
                            Column(
                              children: const [
                                ModernProjectCard(
                                  title: "AI Vision Cam",
                                  description:
                                      "Real-time object detection mobile app using TensorFlow Lite. Identifies objects in milliseconds with high accuracy.",
                                  technologies: [
                                    Icons.camera,
                                    Icons.remove_red_eye,
                                    Icons.smart_toy,
                                  ],
                                  accentColor: Color(0xFF00E5FF),
                                ),
                                SizedBox(height: 30),
                                ModernProjectCard(
                                  title: "Super Memory",
                                  description:
                                      "Second Brain AI app for organizing knowledge. Features vector search, auto-tagging, and smart summarization.",
                                  technologies: [
                                    Icons.psychology,
                                    Icons.memory,
                                    Icons.storage,
                                  ],
                                  accentColor: Color(0xFFE040FB),
                                ),
                                SizedBox(height: 30),
                                ModernProjectCard(
                                  title: "Flutter E-Com",
                                  description:
                                      "Full-featured e-commerce app with payment gateway integration, real-time order tracking, and admin dashboard.",
                                  technologies: [
                                    Icons.shopping_bag,
                                    Icons.credit_card,
                                    Icons.phone_android,
                                  ],
                                  accentColor: Color(0xFF00E5FF),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- EXPERIENCE SECTION ---
                    Container(
                      margin: const EdgeInsets.only(bottom: 180),
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: ScrollAnimatedItem(
                        index: 5,
                        child: Column(
                          children: [
                            _buildSectionTitle("Journey"),
                            const SizedBox(height: 40),
                            const TimelineExperience(),
                          ],
                        ),
                      ),
                    ),

                    // --- AI CHAT SECTION ---
                    Container(
                      key: _chatKey,
                      margin: const EdgeInsets.only(bottom: 150),
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: ScrollAnimatedItem(
                        index: 6,
                        child: const AIChatSection(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Floating Navigation Bar (Bottom Center)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: FloatingNavBar(
                selectedIndex: _selectedIndex,
                onItemSelected: _scrollToSection,
              ),
            ),

            // 4. Theme Toggle Button (Top Right)
            Positioned(
              top: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isDarkMode = !_isDarkMode;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isDarkMode
                        ? const Color(0xFF1A1A1A).withValues(alpha: 0.8)
                        : Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isDarkMode
                          ? const Color(0xFF00E5FF).withValues(alpha: 0.5)
                          : const Color(0xFF6366F1).withValues(alpha: 0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isDarkMode
                            ? const Color(0xFF00E5FF).withValues(alpha: 0.3)
                            : const Color(0xFF6366F1).withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: _isDarkMode
                        ? const Color(0xFF00E5FF)
                        : const Color(0xFF6366F1),
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.5,
        shadows: [
          Shadow(
            color: const Color(0xFFE040FB).withValues(alpha: 0.5),
            blurRadius: 20,
          ),
        ],
      ),
    );
  }
}
