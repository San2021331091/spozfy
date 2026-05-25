class CommentModel {
  final String id;
  String name;
  String text;
  final int createdAt;

  CommentModel({
    required this.id,
    required this.name,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'text': text,
        'createdAt': createdAt,
      };

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['id'] as String,
        name: json['name'] as String,
        text: json['text'] as String,
        createdAt: json['createdAt'] as int,
      );
}