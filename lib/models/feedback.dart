class Feedback {
  final String id;
  final String ideaId;
  final String userId;
  final String userName;
  final String comment;
  final DateTime createdAt;

  Feedback({
    required this.id,
    required this.ideaId,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ideaId': ideaId,
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Feedback.fromMap(Map<String, dynamic> map) {
    return Feedback(
      id: map['id'] ?? '',
      ideaId: map['ideaId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      comment: map['comment'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
