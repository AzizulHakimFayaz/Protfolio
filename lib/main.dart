import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';
import 'package:protfolio_website/Widgets/scroll_animated_item.dart';
import 'package:protfolio_website/Widgets/skill_bar.dart';
import 'package:protfolio_website/Widgets/github_stats_card.dart';
import 'package:protfolio_website/Widgets/project_card.dart';
import 'Particle_effect/color_inverting_particles.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PortfolioParticlePage(),
    ),
  );
}

class PortfolioParticlePage extends StatelessWidget {
  const PortfolioParticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A0B2E), // Deep Purple
              Color(0xFF0B1026), // Deep Blue
              Color(0xFF020205), // Almost black, but with a hint of blue
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Fixed Background
            const Positioned.fill(child: ColorInvertingParticles()),

            // Scrollable Content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),

                    // Hero Section
                    ScrollAnimatedItem(
                      index: 0,
                      child: Center(
                        child: Column(
                          children: [
                            const Text(
                              "Hi, I am",
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.white70,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Azizul Hakim",
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GlassEffectContainer(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              child: const Text(
                                "Web Developer / Flutter Enthusiast",
                                style: TextStyle(
                                  color: Color(0xFF00E5FF), // Cyan accent
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFE040FB,
                                ), // Purple accent
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                shadowColor: const Color(
                                  0xFFE040FB,
                                ).withValues(alpha: 0.5),
                                elevation: 10,
                              ),
                              child: const Text("Download CV"),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 150),

                    // About Section
                    ScrollAnimatedItem(
                      index: 1,
                      child: GlassEffectContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("About Me"),
                            const SizedBox(height: 20),
                            Text(
                              "I build beautiful and performant applications using Flutter and modern web technologies. My focus is on creating seamless user experiences with stunning visuals. I love solving complex problems and turning ideas into reality.",
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.6,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 100),

                    // Skills Section
                    ScrollAnimatedItem(
                      index: 2,
                      child: GlassEffectContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("My Skills"),
                            const SizedBox(height: 30),
                            const SkillBar(
                              skillName: "Flutter & Dart",
                              percentage: 0.95,
                            ),
                            const SkillBar(
                              skillName: "Web Development (HTML/CSS/JS)",
                              percentage: 0.85,
                              color: Color(0xFFE040FB),
                            ),
                            const SkillBar(
                              skillName: "UI/UX Design",
                              percentage: 0.75,
                            ),
                            const SkillBar(
                              skillName: "Backend Integration",
                              percentage: 0.80,
                              color: Color(0xFFE040FB),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 100),

                    // GitHub Stats Section
                    ScrollAnimatedItem(
                      index: 3,
                      child: const GitHubStatsCard(),
                    ),

                    const SizedBox(height: 100),

                    // Experience Section
                    ScrollAnimatedItem(
                      index: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("Experience"),
                          const SizedBox(height: 30),
                          _buildExperienceCard(
                            "Senior Flutter Developer",
                            "Tech Solutions Inc.",
                            "2023 - Present",
                            "Leading the mobile development team and architecting scalable apps.",
                          ),
                          const SizedBox(height: 20),
                          _buildExperienceCard(
                            "Web Developer",
                            "Creative Agency",
                            "2021 - 2023",
                            "Developed responsive websites and interactive web applications.",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),

                    // Projects Section
                    ScrollAnimatedItem(
                      index: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle("Featured Projects"),
                          const SizedBox(height: 30),
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: const [
                              ProjectCard(
                                title: "Super Memory",
                                description:
                                    "AI-powered memory assistant that helps you recall everything.",
                                technologies: [
                                  Icons.memory,
                                  Icons.psychology,
                                  Icons.storage,
                                ],
                              ),
                              ProjectCard(
                                title: "Portfolio",
                                description:
                                    "Interactive portfolio with particle effects and glassmorphism.",
                                technologies: [
                                  Icons.web,
                                  Icons.code,
                                  Icons.animation,
                                ],
                              ),
                              ProjectCard(
                                title: "E-Commerce",
                                description:
                                    "Modern shopping experience with seamless payments.",
                                technologies: [
                                  Icons.shopping_cart,
                                  Icons.payment,
                                  Icons.cloud,
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
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
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white.withValues(alpha: 0.95),
        shadows: [
          Shadow(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(
    String role,
    String company,
    String period,
    String description,
  ) {
    return GlassEffectContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                role,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00E5FF),
                ),
              ),
              Text(
                period,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            company,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
