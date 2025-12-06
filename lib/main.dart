import 'dart:ui';
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
import 'package:protfolio_website/Widgets/footer_section.dart';
import 'Particle_effect/color_inverting_particles.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

void main() {
  runApp(
    MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: const PortfolioParticlePage(),
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
  final PageController _projectController = PageController(
    viewportFraction: 0.85,
    initialPage: 1,
  );

  final List<Map<String, dynamic>> _projects = [
    {
      "title": "AI Vision Cam",
      "description": "Real-time object detection app.",
      "accentColor": const Color(0xFF00E5FF),
      "technologies": [Icons.camera, Icons.remove_red_eye, Icons.smart_toy],
    },
    {
      "title": "Super Memory",
      "description": "Second brain AI knowledge system.",
      "accentColor": const Color(0xFFE040FB),
      "technologies": [Icons.memory, Icons.psychology, Icons.folder],
    },
    {
      "title": "Flutter E-Com",
      "description": "Full e-commerce app with admin panel.",
      "accentColor": const Color(0xFF00E5FF),
      "technologies": [
        Icons.shopping_bag,
        Icons.credit_card,
        Icons.phone_android,
      ],
    },
  ];

  int _selectedIndex = 0;
  bool _isDarkMode = true;

  double _navOpacity = 0.0;
  double _navOffset = -20;

  // Section keys
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _chatKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateNavbarOnScroll);
  }

  void _updateNavbarOnScroll() {
    final scrollPos = _scrollController.offset;

    // 🔥 Navbar animation logic
    if (scrollPos < 20) {
      setState(() {
        _navOpacity = 0.0;
        _navOffset = -20;
      });
    } else {
      setState(() {
        _navOpacity = 1.0;
        _navOffset = 0;
      });
    }

    // 🔥 Section auto-detection
    List<GlobalKey> keys = [
      _homeKey,
      _aboutKey,
      _skillsKey,
      _projectsKey,
      _chatKey,
    ];

    for (int i = 0; i < keys.length; i++) {
      final ctx = keys[i].currentContext;
      if (ctx == null) continue;

      final box = ctx.findRenderObject() as RenderBox;
      final pos = box.localToGlobal(Offset.zero).dy;

      if (pos >= 0 && pos <= 300) {
        if (_selectedIndex != i) {
          setState(() => _selectedIndex = i);
        }
      }
    }
  }

  void _scrollToSection(int index) {
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
    _projectController.dispose();
    super.dispose();
  }

  Offset? _mousePosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: MouseRegion(
        onHover: (event) {
          setState(() {
            _mousePosition = event.position;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: _isDarkMode
                ? const RadialGradient(
                    center: Alignment(0.0, -0.2),
                    radius: 1.5,
                    colors: [
                      Color(0xFF0F0518), // Deep purple/black
                      Color(0xFF000000),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFF5E1),
                      Color(0xFFFFE4E1),
                      Color(0xFFF0E6FA),
                      Color(0xFFE8F4F8),
                    ],
                  ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ColorInvertingParticles(mousePosition: _mousePosition),
              ),

              SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 80),

                          // HOME SECTION --------------------------------------------
                          Container(
                            key: _homeKey,
                            margin: const EdgeInsets.only(bottom: 180),
                            constraints: const BoxConstraints(maxWidth: 1200),
                            child: ScrollAnimatedItem(
                              index: 0,
                              child: Column(
                                children: [
                                  const Text(
                                    "HELLO! I AM AZIZUL HAKIM",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFE040FB),
                                      letterSpacing: 3.0,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Color(0xFFE040FB),
                                          blurRadius: 10,
                                        ),
                                      ],
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
                                      shadows: _isDarkMode
                                          ? [
                                              Shadow(
                                                color: Colors.white.withOpacity(
                                                  0.2,
                                                ),
                                                blurRadius: 20,
                                              ),
                                            ]
                                          : [],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Because if the cover does not impress you what else can?",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _isDarkMode
                                          ? Colors.white.withOpacity(0.6)
                                          : Colors.black.withOpacity(0.6),
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 60),
                                  const ConnectedCardsSection(),
                                ],
                              ),
                            ),
                          ),

                          // SKILLS SECTION --------------------------------------------
                          Container(
                            key: _skillsKey,
                            margin: const EdgeInsets.only(bottom: 180),
                            constraints: const BoxConstraints(maxWidth: 1100),
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
                                          color: Color(0xFF00E5FF),
                                        ),
                                        SkillBar(
                                          skillName:
                                              "Native Android (Kotlin) & iOS",
                                          percentage: 0.80,
                                          color: Color(0xFFE040FB),
                                        ),
                                        SkillBar(
                                          skillName: "DSA / Problem Solving",
                                          percentage: 0.90,
                                          color: Color(0xFF00E5FF),
                                        ),
                                        SkillBar(
                                          skillName: "AI Integration",
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

                          // GITHUB SECTION --------------------------------------------
                          Container(
                            margin: const EdgeInsets.only(bottom: 180),
                            constraints: const BoxConstraints(maxWidth: 1000),
                            child: ScrollAnimatedItem(
                              index: 3,
                              child: const GitHubStatsCard(),
                            ),
                          ),

                          // PROJECTS SECTION ------------------------------------------
                          Container(
                            key: _projectsKey,
                            margin: const EdgeInsets.only(bottom: 180),
                            constraints: const BoxConstraints(maxWidth: 1400),
                            child: ScrollAnimatedItem(
                              index: 4,
                              child: Column(
                                children: [
                                  _buildSectionTitle("Featured Work"),
                                  const SizedBox(height: 50),
                                  SizedBox(
                                    height: 600,
                                    child: PageView.builder(
                                      controller: _projectController,
                                      itemCount: _projects.length,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return AnimatedBuilder(
                                          animation: _projectController,
                                          builder: (context, child) {
                                            double value = 1.0;
                                            if (_projectController
                                                .position
                                                .haveDimensions) {
                                              value =
                                                  _projectController.page! -
                                                  index;
                                              value = (1 - (value.abs() * 0.3))
                                                  .clamp(0.0, 1.0);
                                            }
                                            return Center(
                                              child: Transform.scale(
                                                scale: Curves.easeOut.transform(
                                                  value,
                                                ),
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: ModernProjectCard(
                                              title: _projects[index]['title'],
                                              description:
                                                  _projects[index]['description'],
                                              accentColor:
                                                  _projects[index]['accentColor'],
                                              technologies:
                                                  _projects[index]['technologies'],
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

                          // EXPERIENCE SECTION ----------------------------------------
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

                          // CHAT SECTION ----------------------------------------------
                          Container(
                            key: _chatKey,
                            margin: const EdgeInsets.only(bottom: 150),
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: ScrollAnimatedItem(
                              index: 6,
                              child: const AIChatSection(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // FOOTER SECTION
                    const FooterSection(),
                  ],
                ),
              ),

              // 🟣 NAVBAR (SLIDE + FADE)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                top: 10 + _navOffset,
                left: 0,
                right: 0,
                child: FloatingNavBar(
                  selectedIndex: _selectedIndex,
                  onItemSelected: _scrollToSection,
                  backgroundOpacity: _navOpacity,
                ),
              ),

              // THEME TOGGLE BUTTON
              Positioned(
                top: 30,
                right: 30,
                child: GestureDetector(
                  onTap: () => setState(() => _isDarkMode = !_isDarkMode),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: Icon(
                      _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(color: Color(0xFFE040FB), blurRadius: 20),
          Shadow(
            color: Color(0xFF00E5FF),
            blurRadius: 20,
            offset: Offset(2, 2),
          ),
        ],
      ),
    );
  }
}
