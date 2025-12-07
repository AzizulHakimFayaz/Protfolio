import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/section_title.dart';
import 'package:protfolio_website/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure url_launcher is in pubspec, typically main.dart had it or similar. Uses external launch.

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  final List<Map<String, dynamic>> _projects = const [
    {
      "title": "Flutter Calculator App",
      "description":
          "A functional calculator built with Flutter UI components. Demonstrates layout design, widget structure, and responsive UI.",
      "tags": ["Flutter", "Dart", "UI/UX"],
      "link": "https://github.com/AzizulHakimFayaz/Flutter_Calculator_App",
      "icon": Icons.calculate_outlined,
    },
    {
      "title": "Automation Project",
      "description":
          "Python automation tool that handles repetitive tasks. Shows logic building, file operations, and backend scripting ability.",
      "tags": ["Python", "Scripting", "Automation"],
      "link": "https://github.com/AzizulHakimFayaz/Automation_project",
      "icon": Icons.auto_mode,
    },
    {
      "title": "Calculator Program",
      "description":
          "Calculator written in C language. Shows fundamentals of mathematical logic & programming basics.",
      "tags": ["C", "Algorithms", "Logic"],
      "link": "https://github.com/AzizulHakimFayaz/Calculator_program",
      "icon": Icons.terminal,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.contentBackground,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              const SectionTitle(title: "Featured Projects"),
              const SizedBox(height: 60),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive Grid
                  int gridCount = constraints.maxWidth > 900
                      ? 3
                      : (constraints.maxWidth > 600 ? 2 : 1);
                  double cardWidth =
                      (constraints.maxWidth - (gridCount - 1) * 30) / gridCount;

                  return Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    children: _projects
                        .map(
                          (project) =>
                              _ProjectCard(project: project, width: cardWidth),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  final double width;

  const _ProjectCard({required this.project, required this.width});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(widget.project["link"]);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        // height: 350, // Let height be dynamic based on content
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? AppColors.accentTeal.withOpacity(0.15)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon / Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.contentBackground,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                widget.project["icon"],
                size: 32,
                color: AppColors.navyLight,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              widget.project["title"],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.navyDark,
              ),
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              widget.project["description"],
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textGrey,
              ),
            ),
            const SizedBox(height: 20),

            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (widget.project["tags"] as List<String>)
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.navyLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 30),

            // Link Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _launchURL,
                icon: const Icon(Icons.code),
                label: const Text("View Code"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _isHovered
                      ? AppColors.accentTeal
                      : AppColors.textDark,
                  side: BorderSide(
                    color: _isHovered
                        ? AppColors.accentTeal
                        : Colors.grey.shade300,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
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
