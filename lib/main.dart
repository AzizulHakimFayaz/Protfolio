import 'dart:async';
import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/about_section.dart';
import 'package:protfolio_website/Widgets/contact_footer.dart';
import 'package:protfolio_website/Widgets/experience_section.dart';
import 'package:protfolio_website/Widgets/hero_section.dart';
import 'package:protfolio_website/Widgets/project_showcase.dart';
import 'package:protfolio_website/Widgets/skills_section.dart';
import 'package:protfolio_website/constants/app_colors.dart';
import 'package:protfolio_website/Widgets/animated_navbar.dart';
import 'package:protfolio_website/Widgets/github/github_contribution_section.dart';

void main() {
  runZonedGuarded(
    () {
      ErrorWidget.builder = (FlutterErrorDetails details) {
        return Material(
          color: Colors.deepOrange,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Text(
                  details.exceptionAsString(),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        );
      };
      runApp(const MyApp());
    },
    (error, stackTrace) {
      debugPrint('Global Error: $error');
      debugPrint('Stack Trace: $stackTrace');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azizul Hakim Fayaz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto', // Or your preferred font
        scaffoldBackgroundColor: AppColors.contentBackground,
        primaryColor: AppColors.navyDark,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accentTeal),
        useMaterial3: true,
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();

  // Section Keys
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
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
      body: Stack(
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(
                  key: _heroKey,
                  onViewWork: () => _scrollToSection(_projectsKey),
                  onContact: () => _scrollToSection(_contactKey),
                ),
                AboutSection(key: _aboutKey),
                SkillsSection(key: _skillsKey),
                ProjectShowcase(
                  key: _projectsKey,
                  scrollController: _scrollController,
                ),
                ExperienceSection(key: _experienceKey),
                const GitHubContributionSection(),
                ContactFooterSection(key: _contactKey),
              ],
            ),
          ),

          // Animated Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedNavbar(
              scrollController: _scrollController,
              onNavTap: (index) {
                final keys = [
                  _heroKey,
                  _aboutKey,
                  _skillsKey,
                  _projectsKey,
                  _contactKey,
                ];
                if (index < keys.length) {
                  _scrollToSection(keys[index]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
