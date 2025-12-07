import 'package:flutter/material.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class GithubStatsRow extends StatelessWidget {
  final int totalContributions;
  final int followers;
  final int following;
  final int repositories;

  const GithubStatsRow({
    super.key,
    required this.totalContributions,
    required this.followers,
    required this.following,
    required this.repositories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: AppColors.navyLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentTeal.withOpacity(0.1)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        spacing: 20,
        runSpacing: 20,
        children: [
          _buildStatItem("Contributions", totalContributions, Icons.grid_view),
          _buildStatItem("Repositories", repositories, Icons.book),
          _buildStatItem("Followers", followers, Icons.people),
          _buildStatItem("Following", following, Icons.person_add),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accentTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.accentTeal, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$count",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
