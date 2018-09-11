import 'package:annicter/api/models/work.dart';

class Episode {

  final int id;
  final int number;
  final String numberText;
  final int sortNumber;
  final String title;
  final int recordsCount;
  final int recordCommentsCount;
  final Work work;
  final Episode prevEpisode;
  final Episode nextEpisode;

  Episode({
    this.id,
    this.number,
    this.numberText,
    this.sortNumber,
    this.title,
    this.recordsCount,
    this.recordCommentsCount,
    this.work,
    this.prevEpisode,
    this.nextEpisode,
  });

  factory Episode.fromJson(Map<String, dynamic> jsonStr) {
    if (jsonStr == null) {
      return null;
    }
    return Episode(
      id: jsonStr['id'],
      number: int.tryParse(jsonStr['number'] ?? "0"),
      numberText: jsonStr['number_text'],
      sortNumber: jsonStr['sort_number'],
      title: jsonStr['title'],
      recordsCount: jsonStr['records_count'],
      recordCommentsCount: jsonStr['record_comments_count'],
      work: Work.fromJson(jsonStr['work']),
      prevEpisode: Episode.fromJson(jsonStr['prev_episode']),
      nextEpisode: Episode.fromJson(jsonStr['next_episode'] ?? null),
    );
  }
}