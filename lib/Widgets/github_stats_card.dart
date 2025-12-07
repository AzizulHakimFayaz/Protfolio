import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:contributions_chart/contributions_chart.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class GitHubStatsCard extends StatefulWidget {
  final String username;

  const GitHubStatsCard({super.key, this.username = 'AzizulHakimFayaz'});

  @override
  State<GitHubStatsCard> createState() => _GitHubStatsCardState();
}

class _GitHubStatsCardState extends State<GitHubStatsCard> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchGitHubData();
  }

  Future<void> _fetchGitHubData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/users/${widget.username}'),
      );

      if (response.statusCode == 200) {
        _userData = json.decode(response.body);
        _isLoading = false;
        if (mounted) setState(() {});
      } else {
        _hasError = true;
        _isLoading = false;
        if (mounted) setState(() {});
      }
    } catch (e) {
      _hasError = true;
      _isLoading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // HUD Background Decoration
        Positioned.fill(
          child: CustomPaint(painter: HUDPainter(color: AppColors.neonCyan)),
        ),

        GlassEffectContainer(
          width: double.infinity,
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.terminal,
                    color: AppColors.neonCyan,
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "GITHUB COMMAND CENTER",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonCyan,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: AppColors.neonCyan.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Contribution Chart Frame
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: AppColors.scaffoldBackground.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.neonCyan.withOpacity(0.2),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CONTRIBUTION MATRIX",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.neonCyan.withOpacity(0.7),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: GitHubContributionsWidget(
                        githubUrl: 'https://github.com/${widget.username}',
                        width: double.infinity,
                        height: 168,
                        backgroundColor: Colors.transparent,
                        contributionColors: [
                          AppColors.textPrimaryDark.withOpacity(0.05),
                          const Color(0xFF004D40),
                          const Color(0xFF00695C),
                          const Color(0xFF00897B),
                          AppColors.neonCyan,
                        ],
                        cellSpacing: 4.0,
                        squareBorderRadius: 2.0,
                        showCalendar: true,
                        monthLabelStyle: TextStyle(
                          color: AppColors.textPrimaryDark.withOpacity(0.6),
                          fontSize: 10,
                          fontFamily: "monospace",
                        ),
                        dayLabelStyle: TextStyle(
                          color: AppColors.textPrimaryDark.withOpacity(0.6),
                          fontSize: 10,
                          fontFamily: "monospace",
                        ),
                        emptyColor: AppColors.textPrimaryDark.withOpacity(0.05),
                        loadingWidget: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.neonCyan,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // User Stats Grid
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.neonCyan),
                )
              else if (_hasError)
                const Text(
                  "SYSTEM FAILURE: UNABLE TO LOAD DATA",
                  style: TextStyle(color: Colors.red, fontFamily: "monospace"),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatHexagon(
                      "REPOS",
                      "${_userData?['public_repos'] ?? 0}",
                      Icons.folder_open,
                    ),
                    _buildStatHexagon(
                      "FOLLOWERS",
                      "${_userData?['followers'] ?? 0}",
                      Icons.people_outline,
                    ),
                    _buildStatHexagon(
                      "FOLLOWING",
                      "${_userData?['following'] ?? 0}",
                      Icons.person_add_alt,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatHexagon(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape
                .circle, // Using circle for simplicity but styled like a node
            border: Border.all(
              color: AppColors.neonPurple.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonPurple.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
            color: AppColors.scaffoldBackground.withOpacity(0.3),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.neonPurple, size: 20),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.neonPurple.withOpacity(0.8),
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class HUDPainter extends CustomPainter {
  final Color color;

  HUDPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    const double cornerSize = 20;

    // Top Left
    path.moveTo(0, cornerSize);
    path.lineTo(0, 0);
    path.lineTo(cornerSize, 0);

    // Top Right
    path.moveTo(size.width - cornerSize, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, cornerSize);

    // Bottom Right
    path.moveTo(size.width, size.height - cornerSize);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - cornerSize, size.height);

    // Bottom Left
    path.moveTo(cornerSize, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - cornerSize);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
