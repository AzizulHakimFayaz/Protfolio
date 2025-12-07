import 'package:flutter/material.dart';
import 'package:protfolio_website/Widgets/github/contribution_square.dart';
import 'package:protfolio_website/models/contribution_model.dart';
import 'package:protfolio_website/constants/app_colors.dart';

class ContributionGrid extends StatelessWidget {
  final ContributionCalendar calendar;

  const ContributionGrid({super.key, required this.calendar});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate max weeks we can fit
        // Each week column is approx 16px wide (12px square + 4px margin)
        const double weekWidth = 16.0;
        final int maxWeeks = (constraints.maxWidth / weekWidth).floor();

        // Take the last N weeks to fit the screen
        final visibleWeeks = calendar.weeks.length > maxWeeks
            ? calendar.weeks.sublist(calendar.weeks.length - maxWeeks)
            : calendar.weeks;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Labels (Optional simplification: just show grid, maybe adds complexity to align months perfectly)
            // For now, let's stick to a clean grid to ensure alignment is perfect.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day Labels (Mon, Wed, Fri)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    top: 20,
                  ), // Top padding to align with rows
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      // 0
                      SizedBox(height: 14), // Tue
                      Text(
                        'Mon',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textGrey,
                        ),
                      ),
                      // Wed
                      SizedBox(height: 15), // Thu
                      Text(
                        'Wed',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textGrey,
                        ),
                      ),
                      // Fri
                      SizedBox(height: 15), // Sat
                      Text(
                        'Fri',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                // The Grid
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true, // Start from latest date (right)
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: visibleWeeks.map((week) {
                        return Column(
                          children: week.days.map((day) {
                            return ContributionSquare(
                              contributionCount: day.contributionCount,
                              date: day.date,
                              colorCode: day.color,
                            );
                          }).toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
