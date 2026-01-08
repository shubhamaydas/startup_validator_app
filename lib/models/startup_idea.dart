class StartupIdea {
  final String id;
  final String userId;
  final String userName;
  final String title;
  final String problem;
  final String solution;
  final String targetAudience;
  final List<String> validationSteps;
  final int likes;
  final List<String> likedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  StartupIdea({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.problem,
    required this.solution,
    required this.targetAudience,
    required this.validationSteps,
    required this.likes,
    required this.likedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'title': title,
      'problem': problem,
      'solution': solution,
      'targetAudience': targetAudience,
      'validationSteps': validationSteps,
      'likes': likes,
      'likedBy': likedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory StartupIdea.fromMap(Map<String, dynamic> map) {
    return StartupIdea(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous',
      title: map['title'] ?? '',
      problem: map['problem'] ?? '',
      solution: map['solution'] ?? '',
      targetAudience: map['targetAudience'] ?? '',
      validationSteps: List<String>.from(map['validationSteps'] ?? []),
      likes: map['likes'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  StartupIdea copyWith({
    String? id,
    String? userId,
    String? userName,
    String? title,
    String? problem,
    String? solution,
    String? targetAudience,
    List<String>? validationSteps,
    int? likes,
    List<String>? likedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StartupIdea(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      title: title ?? this.title,
      problem: problem ?? this.problem,
      solution: solution ?? this.solution,
      targetAudience: targetAudience ?? this.targetAudience,
      validationSteps: validationSteps ?? this.validationSteps,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
