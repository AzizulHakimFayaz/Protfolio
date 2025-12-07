import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:protfolio_website/models/contribution_model.dart';
          followers {
            totalCount
          }
          following {
            totalCount
          }
          repositories(ownerAffiliations: OWNER, isFork: false) {
            totalCount
          }
          contributionsCollection {
            contributionCalendar {
              totalContributions
              weeks {
                contributionDays {
                  contributionCount
                  date
                  color
                }
              }
            }
          }
        }
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['errors'] != null) {
          debugPrint('GraphQL Error: ${data['errors']}');
          return null;
        }

        final user = data['data']['user'];
        if (user == null) {
          debugPrint('User not found');
          return null;
        }

        final calendarJson =
            user['contributionsCollection']['contributionCalendar'];

        return GithubData(
          calendar: ContributionCalendar.fromJson(calendarJson),
          followers: user['followers']['totalCount'] ?? 0,
          following: user['following']['totalCount'] ?? 0,
          repositories: user['repositories']['totalCount'] ?? 0,
          avatarUrl: user['avatarUrl'] ?? '',
        );
      } else {
        debugPrint(
          'GitHub API Error: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      debugPrint('Exception fetching GitHub contributions: $e');
      return null;
    }
  }
}
