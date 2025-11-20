import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      );

      if (response.statusCode == 200) {
        setState(() {
          _userData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
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
            "GitHub Contributions",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 20),

          // Contribution Graph
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              'https://ghchart.rshah.org/${widget.username}',
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    "Failed to load chart",
                    style: TextStyle(color: Colors.black),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 30),

          // Stats Row
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
            color: Color(0xFF00E5FF), // Cyan accent
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
