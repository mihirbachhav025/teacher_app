class Lecture {
  final String roomNo;
  final String division;
  final String academicYear;
  final String sem;
  final String day;
  final String startTime;
  final String endTime;
  final String subName;
  final String cName;
  final String profID;

  Lecture({
    required this.roomNo,
    required this.division,
    required this.academicYear,
    required this.sem,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.subName,
    required this.cName,
    required this.profID,
  });

  static Lecture fromJson(Map<String, dynamic> json) {
    return Lecture(
      roomNo: json['roomNo'],
      division: json['division'],
      academicYear: json['academicYear'],
      sem: json['sem'],
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      subName: json['subName'],
      cName: json['cName'],
      profID: json['profID'],
    );
  }

  @override
  String toString() {
    return '$roomNo,$division,$academicYear,$sem,$day,$startTime,$endTime,$subName,$cName,$profID';
  }
}
