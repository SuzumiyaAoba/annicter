import 'package:annicter/api/models/work.dart';

class Works {
  final List<Work> works;
  final int totalCount;
  final int nextPage;
  final int prevPage;

  Works({this.works, this.totalCount, this.nextPage, this.prevPage});

  factory Works.fromJson(Map<String, dynamic> jsonStr) {
    var works =
        (jsonStr['works'] as List).map((work) => Work.fromJson(work)).toList();
    return Works(
        works: works,
        totalCount: jsonStr['total_count'],
        nextPage: jsonStr['next_page'],
        prevPage: jsonStr['prev_page']);
  }
}
