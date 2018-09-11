import 'package:annicter/api/models/episode.dart';
import 'package:annicter/api/models/work.dart';

class Program {

  final int id;
  final DateTime startedAt;
  final bool rebroadcast;
  final Work work;
  final Episode episode;

  Program({
    this.id,
    this.startedAt,
    this.rebroadcast,
    this.work,
    this.episode,
  });

  factory Program.fromJson(Map<String, dynamic> jsonStr) {
    if (jsonStr == null) {
      return null;
    }
    return Program(
      id: jsonStr['id'],
      startedAt: DateTime.parse(jsonStr['started_at']),
      rebroadcast: jsonStr['is_rebroadcast'],
      work: Work.fromJson(jsonStr['work']),
      episode: Episode.fromJson(jsonStr['episode']),
    );
  }
}

class Channel {

  final int id;
  final String name;

  Channel({
    this.id,
    this.name,
  });

  factory Channel.fromJson(Map<String, dynamic> jsonStr) {
    return Channel(
      id: jsonStr['id'],
      name: jsonStr['name'],
    );
  }
}