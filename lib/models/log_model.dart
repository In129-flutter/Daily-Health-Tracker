class Log {
  final int userId;
  final int id;
  final String title;
  final String body;

  Log({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
