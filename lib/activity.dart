class Activity {
  int? id;
  String activity;
  int duration;
  String date;

  Activity({
    this.id,
    required this.activity,
    required this.duration,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity': activity,
      'duration': duration,
      'date': date,
    };
  }
}
