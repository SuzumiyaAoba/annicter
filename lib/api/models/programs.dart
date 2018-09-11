import 'package:annicter/api/models/program.dart';

class Programs {
  final List<Program> programs;
  final int totalCount;
  final int nextPage;
  final int prevPage;

  Programs({this.programs, this.totalCount, this.nextPage, this.prevPage});

  factory Programs.fromJson(Map<String, dynamic> jsonStr) {
    var programs = (jsonStr['programs'] as List).map((program) => Program.fromJson(program)).toList();
    return Programs(
      programs: programs,
      totalCount: jsonStr['total_count'],
      nextPage: jsonStr['next_page'],
      prevPage: jsonStr['prev_page'],
    );
  }
}