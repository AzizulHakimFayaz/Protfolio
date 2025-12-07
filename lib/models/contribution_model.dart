class GithubData {
  final ContributionCalendar calendar;
  final int followers;
  final int following;
  final int repositories;
  final String avatarUrl;

  GithubData({
    required this.calendar,
    required this.followers,
    required this.following,
    required this.repositories,
    required this.avatarUrl,
  });
}

class ContributionCalendar {
  final int totalContributions;
  final List<ContributionWeek> weeks;

  ContributionCalendar({required this.totalContributions, required this.weeks});

  factory ContributionCalendar.fromJson(Map<String, dynamic> json) {
    var weeksJson = json['weeks'] as List;
    List<ContributionWeek> weeksList = weeksJson
        .map((week) => ContributionWeek.fromJson(week))
        .toList();

    return ContributionCalendar(
      totalContributions: json['totalContributions'],
      weeks: weeksList,
    );
  }
}

class ContributionWeek {
  final List<ContributionDay> days;

  ContributionWeek({required this.days});

  factory ContributionWeek.fromJson(Map<String, dynamic> json) {
    var daysJson = json['contributionDays'] as List;
    List<ContributionDay> daysList = daysJson
        .map((day) => ContributionDay.fromJson(day))
        .toList();

    return ContributionWeek(days: daysList);
  }
}

class ContributionDay {
  final int contributionCount;
  final String date;
  final String color;

  ContributionDay({
    required this.contributionCount,
    required this.date,
    required this.color,
  });

  factory ContributionDay.fromJson(Map<String, dynamic> json) {
    return ContributionDay(
      contributionCount: json['contributionCount'],
      date: json['date'],
      color: json['color'],
    );
  }
}
