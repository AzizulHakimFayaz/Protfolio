import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:protfolio_website/models/contribution_model.dart';
import 'package:flutter/foundation.dart';

class GithubService {
  static const String _username = 'AzizulHakimFayaz'; // Default username
  // TODO: Replace with your actual GitHub Personal Access Token
  // WARNING: Do not commit this token to a public repository.
  static const String _token = String.fromEnvironment(
    'GITHUB_TOKEN',
    defaultValue: '',
  );

  static const String _graphQLEndpoint = 'https://api.github.com/graphql';

  Future<GithubData?> fetchGithubData() async {
    const String query = '''
      query(\$username: String!) {
        user(login: \$username) {
          avatarUrl
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
    ''';

    try {
      final response = await http.post(
        Uri.parse(_graphQLEndpoint),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'query': query,
          'variables': {'username': _username},
        }),
      );

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
