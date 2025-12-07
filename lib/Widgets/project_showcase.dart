import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:protfolio_website/Widgets/tech_graph_visualizer.dart';

class ProjectData {
  final String title;
  final String description;
  final List<String> tags;
  final String link;
  final IconData icon; // Placeholder for image/screenshot
  final Color accentColor;
  final List<IconData> techIcons;
  final List<String> techLabels;

  const ProjectData({
    required this.title,
    required this.description,
    required this.tags,
    required this.link,
    required this.icon,
    this.accentColor = AppColors.accentTeal,
    this.techIcons = const [],
    this.techLabels = const [],
  });
}

class ProjectShowcase extends StatefulWidget {
  final ScrollController scrollController;

  const ProjectShowcase({super.key, required this.scrollController});

  @override
  State<ProjectShowcase> createState() => _ProjectShowcaseState();
}

class _ProjectShowcaseState extends State<ProjectShowcase> {
  final GlobalKey _sectionKey = GlobalKey();

  // Projects Data
  final List<ProjectData> _projects = const [
    ProjectData(
      title: "Flutter Calculator App",
      description:
          "A clean, responsive calculator app built in Flutter. Demonstrates widget structure, custom UI, and functional logic.",
      tags: ["Flutter", "Dart"],
      link: "https://github.com/AzizulHakimFayaz/Flutter_Calculator_App",
      icon: Icons.calculate_outlined,
      accentColor: AppColors.accentTeal,
      techIcons: [Icons.widgets, Icons.code, Icons.phone_android],
      techLabels: ["State Mgmt", "Custom UI", "Layout"],
    ),
    ProjectData(
      title: "Automation Project",
      description:
          "A Python-based automation tool designed to speed up repetitive tasks. Includes file handling, pattern detection, and workflow automation scripts.",
      tags: ["Python"],
      link: "https://github.com/AzizulHakimFayaz/Automation_project",
      icon: Icons.auto_mode,
      accentColor: Color(0xFF3776AB), // Python Blue
      techIcons: [Icons.folder, Icons.data_array, Icons.schedule],
      techLabels: ["File I/O", "Pattern Detection", "Automation"],
    ),
    ProjectData(
      title: "Calculator Program",
      description:
          "A low-level calculator built in C, showcasing mastery of logic, loops, and arithmetic operations at a basic level.",
      tags: ["C"],
      link: "https://github.com/AzizulHakimFayaz/Calculator_program",
      icon: Icons.terminal,
      accentColor: Color(0xFFA8B9CC), // C Grey/Silver
      techIcons: [Icons.memory, Icons.code, Icons.loop],
      techLabels: ["Pointers", "Logic", "Looping"],
    ),
  ];

  // State
  int _activeIndex = 0;
  double _stickyOffset = 0.0;
  final double _cardHeight = 400.0;
  final double _cardSpacing = 40.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_sectionKey.currentContext == null) return;

    final RenderBox renderBox =
        _sectionKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final double topY =
        position.dy; // Distance from top of screen to top of section
    final double sectionHeight = renderBox.size.height;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Sticky Logic
    // We want the left panel to stick when topY <= 100 (some margin)
    // And stop sticking when we reach the bottom.

    // Calculate how far we've scrolled INTO the section
    // If topY is 100, scrollIn is -100 (approx).
    // Let's use simple logic: Sticky Top = max(0, -topY + 100)
    // 100 is "Magnet Top" position

    double newStickyOffset = 0;

    if (topY < 100) {
      newStickyOffset = (100 - topY);
    }

    // Clamp to prevent overscroll at bottom
    // Max offset = sectionHeight - leftPanelHeight - padding
    // Assuming Left Panel Height ~ 400
    final double maxOffset = sectionHeight - 500;
    if (newStickyOffset > maxOffset) {
      newStickyOffset = maxOffset;
    }

    if (newStickyOffset < 0) newStickyOffset = 0;

    // Active Index Logic
    // Based on scroll center.
    // Which card is closest to center of screen?
    // Card Center Y relative to section = (index * (cardHeight + space)) + (cardHeight/2) + topPadding
    // Screen Center relative to section = -topY + (screenHeight/2)

    double relativeScreenCenter =
        -topY + (screenHeight / 2.5); // slightly above center looks better

    // Initial top padding for right column = 0
    // But we need to account for the fact that we scroll the section.

    int newIndex = 0;
    for (int i = 0; i < _projects.length; i++) {
      double cardStart = i * (_cardHeight + _cardSpacing);
      double cardEnd = cardStart + _cardHeight;

      if (relativeScreenCenter >= cardStart &&
          relativeScreenCenter <= cardEnd + _cardSpacing) {
        newIndex = i;
        break;
      }
    }
    // Clamp
    if (relativeScreenCenter >
        (_projects.length * (_cardHeight + _cardSpacing))) {
      newIndex = _projects.length - 1;
    }

    if (_stickyOffset != newStickyOffset || _activeIndex != newIndex) {
      setState(() {
        _stickyOffset = newStickyOffset;
        _activeIndex = newIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      key: _sectionKey,
      width: double.infinity,
      color: AppColors.navyDark, // Gradient base
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isDesktop ? 60 : 20,
      ),
      child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    // Total Height calculation for the section
    // We need enough height to scroll through all cards.
    // Height = (Cards * (Height + Space)) + Extra Buffer

    return SizedBox(
      height: (_projects.length * (_cardHeight + _cardSpacing)) + 200,
      child: Stack(
        children: [
          // Left Panel (Sticky)
          Positioned(
            top: _stickyOffset,
            left: 0,
            width: MediaQuery.of(context).size.width * 0.35,
            child: _LeftPanel(project: _projects[_activeIndex]),
          ),

          // Right Panel (Scrollable Cards)
          Positioned(
            right: 0,
            width: MediaQuery.of(context).size.width * 0.55,
            child: Column(
              children: List.generate(_projects.length, (index) {
                return Container(
                  height: _cardHeight,
                  margin: EdgeInsets.only(bottom: _cardSpacing),
                  child: _ProjectCard(
                    project: _projects[index],
                    isActive: index == _activeIndex,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: _projects.map((project) {
        return Container(
          margin: const EdgeInsets.only(bottom: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                project.description,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 350,
                width: double.infinity,
                child: _ProjectCard(project: project, isActive: true),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _LeftPanel extends StatelessWidget {
  final ProjectData project;

  const _LeftPanel({required this.project});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey(project.title), // Important for animation
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accentTeal.withOpacity(0.5)),
            ),
            child: const Text(
              "FEATURED PROJECT",
              style: TextStyle(
                color: AppColors.accentTeal,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            project.title,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            project.description,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
          // CTA Button
          _ProjectCTAButton(project: project),
        ],
      ),
    );
  }
}

class _ProjectCTAButton extends StatefulWidget {
  final ProjectData project;
  const _ProjectCTAButton({required this.project});

  @override
  State<_ProjectCTAButton> createState() => _ProjectCTAButtonState();
}

class _ProjectCTAButtonState extends State<_ProjectCTAButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () async {
          final Uri url = Uri.parse(widget.project.link);
          if (!await launchUrl(url)) {
            debugPrint("Could not launch $url");
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            color: _isHovered ? widget.project.accentColor : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: widget.project.accentColor, width: 2),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.project.accentColor.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code,
                color: _isHovered ? Colors.white : widget.project.accentColor,
              ),
              const SizedBox(width: 10),
              Text(
                "View on GitHub",
                style: TextStyle(
                  color: _isHovered ? Colors.white : widget.project.accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectData project;
  final bool isActive;

  const _ProjectCard({required this.project, required this.isActive});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: active ? 1.02 : 0.98,
        duration: const Duration(milliseconds: 300),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B), // Charcoal
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: active
                  ? widget.project.accentColor.withOpacity(0.5)
                  : Colors.white.withOpacity(0.05),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: active
                    ? widget.project.accentColor.withOpacity(0.2)
                    : Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [
                // Tech Graph Background
                Positioned.fill(
                  child: TechGraphVisualizer(
                    accentColor: widget.project.accentColor,
                    isActive: active,
                    techIcons: widget.project.techIcons,
                    techLabels: widget.project.techLabels,
                  ),
                ),
                // Foreground Content
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black12,
                              boxShadow: active
                                  ? [
                                      BoxShadow(
                                        color: widget.project.accentColor
                                            .withOpacity(0.2),
                                        blurRadius: 20,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Icon(
                              widget.project.icon,
                              size: 60,
                              color: active
                                  ? widget.project.accentColor
                                  : Colors.white24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Tags
                      Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: widget.project.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
