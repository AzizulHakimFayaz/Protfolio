import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/github/contribution_grid.dart';
import 'package:protfolio_website/Widgets/github/github_stats_row.dart';
import 'package:protfolio_website/Widgets/github/styles/github_theme.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';
import 'package:protfolio_website/constants/app_colors.dart';
import 'package:protfolio_website/models/contribution_model.dart';
import 'package:protfolio_website/services/github_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:advanced_particle_effects/advanced_particle_effects.dart';

class GitHubContributionSection extends StatefulWidget {
  const GitHubContributionSection({super.key});

  @override
  State<GitHubContributionSection> createState() =>
      _GitHubContributionSectionState();
}

class _GitHubContributionSectionState extends State<GitHubContributionSection> {
  final GithubService _githubService = GithubService();
  late Future<GithubData?> _futureGithubData;

  @override
  void initState() {
    super.initState();
    _futureGithubData = _githubService.fetchGithubData();
  }

  Future<void> _launchGitHub() async {
    final Uri url = Uri.parse('https://github.com/AzizulHakimFayaz');
    if (!await launchUrl(url)) {
      debugPrint('Could not launch \$url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Container(
            // Wrap everything in a Dark Card to ensure white text is visible
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color:
                  AppColors.navyDark, // Dark background restored for this card
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.navyDark.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              // Optional: Add a subtle gradient to the card itself
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.navyDark,
                  Color(0xFF1B263B), // Slightly lighter navy
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: NetworkedParticleSystem(
                      particleCount: 80,
                      particleColor: AppColors.accentTeal.withOpacity(0.2),
                      lineColor: AppColors.accentTeal.withOpacity(0.2),
                      speedMultiplier: 0.0008,
                      connectionDistance: 70,
                      lineWidth: 2,
                    ),
                  ),
                ),

                // 2. Main Content
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Area
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _launchGitHub,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // GitHub Icon
                                  Icon(
                                    Icons.code,
                                    color: AppColors.accentTeal,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "GitHub Activity",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textWhite,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Code. Commit. Create.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textGrey,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      FutureBuilder<GithubData?>(
                        future: _futureGithubData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 300,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.accentTeal,
                                ),
                              ),
                            );
                          } else if (snapshot.hasError ||
                              snapshot.data == null) {
                            return _buildErrorState();
                          }

                          final data = snapshot.data!;

                          return Column(
                            children: [
                              // Stats Row
                              GithubStatsRow(
                                totalContributions:
                                    data.calendar.totalContributions,
                                followers: data.followers,
                                following: data.following,
                                repositories: data.repositories,
                              ),

                              // Glassmorphic Card containing ONLY the Heatmap
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeOutQuart,
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: Opacity(
                                      opacity: value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: GlassEffectContainer(
                                  borderRadius: BorderRadius.circular(24),
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${data.calendar.totalContributions} Contributions in the last year",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Spacer(),
                                          _buildLegend(),
                                        ],
                                      ),
                                      const SizedBox(height: 24),

                                      // Heatmap Grid
                                      ContributionGrid(calendar: data.calendar),

                                      const SizedBox(height: 16),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: TextButton(
                                          onPressed: _launchGitHub,
                                          style: TextButton.styleFrom(
                                            foregroundColor:
                                                AppColors.accentTeal,
                                            padding: EdgeInsets.zero,
                                            minimumSize: Size.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text("@AzizulHakimFayaz"),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.arrow_forward,
                                                size: 14,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }, // builder
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

  Widget _buildErrorState() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, color: Colors.white38, size: 40),
            const SizedBox(height: 10),
            Text(
              "Unable to load GitHub data",
              style: TextStyle(color: AppColors.textGrey),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _futureGithubData = _githubService.fetchGithubData();
                });
              },
              child: const Text(
                "Retry",
                style: TextStyle(color: AppColors.accentTeal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        const Text(
          "Less",
          style: TextStyle(fontSize: 10, color: AppColors.textGrey),
        ),
        const SizedBox(width: 6),
        _buildLegendSquare(GitHubTheme.getContributionColor(0)),
        _buildLegendSquare(GitHubTheme.getContributionColor(2)),
        _buildLegendSquare(GitHubTheme.getContributionColor(5)),
        _buildLegendSquare(GitHubTheme.getContributionColor(8)),
        _buildLegendSquare(GitHubTheme.getContributionColor(12)),
        const SizedBox(width: 6),
        const Text(
          "More",
          style: TextStyle(fontSize: 10, color: AppColors.textGrey),
        ),
      ],
    );
  }

  Widget _buildLegendSquare(Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
