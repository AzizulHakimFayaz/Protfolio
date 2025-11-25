import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:contributions_chart/contributions_chart.dart';
import 'package:protfolio_website/Widgets/glass_effect_container.dart';

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
        // Note: GitHub API works without authentication for basic requests
        // If you need higher rate limits, add a personal access token:
        // headers: {"Authorization": "token YOUR_GITHUB_TOKEN"},
      );

      if (response.statusCode == 200) {
        _userData = json.decode(response.body);
        _isLoading = false;
        setState(() {});
      } else {
        _hasError = true;
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      _hasError = true;
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassEffectContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "GitHub Statistics",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 20),

          // Contribution Chart
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: GitHubContributionsWidget(
              githubUrl: 'https://github.com/${widget.username}',
              width: double.infinity,
              height: 168,
              backgroundColor: Colors.transparent,
              // Using GitHub's traditional green colors
              contributionColors: [
                Colors.grey.shade800, // 0 contributions
                const Color(0xFF0E4429), // 1-2 contributions (dark green)
                const Color(0xFF006D32), // 3-5 contributions (medium green)
                const Color(0xFF26A641), // 6-9 contributions (light green)
                const Color(0xFF39D353), // 10+ contributions (bright green)
              ],
              cellSpacing: 3.0,
              squareBorderRadius: 3.0,
              showCalendar: true,
              monthLabelStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 10,
              ),
              dayLabelStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 10,
              ),
              emptyColor: Colors.white.withValues(alpha: 0.1),
              loadingWidget: Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFF39D353),
                ),
              ),
              onCellTap: (date, count) {
                // Optional: Show tooltip or info when cell is tapped
                debugPrint('$date: $count contributions');
              },
            ),
          ),

          const SizedBox(height: 30),

          // User Stats
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_hasError)
            const Text(
              "Failed to load stats",
              style: TextStyle(color: Colors.red),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  "Repositories",
                  "${_userData?['public_repos'] ?? 0}",
                ),
                _buildStatItem("Followers", "${_userData?['followers'] ?? 0}"),
                _buildStatItem("Following", "${_userData?['following'] ?? 0}"),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00E5FF),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
