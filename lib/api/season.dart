enum FourSeasons {
  spring, summer, autumn, winter
}

class Season {
  final int year;
  final FourSeasons season;

  Season(this.year, this.season);

  @override
  String toString() {
    return '$year-${_toString(season)}';
  }

  String _toString(FourSeasons season) {
    return season.toString().substring(season.toString().indexOf('.') + 1);
  }
}