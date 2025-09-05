/// userId : 1
/// id : 1
/// title : "sunt aut facere repellat provident occaecati excepturi optio reprehenderit"
/// body : "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"

class PostsModel {
  PostsModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  /// Named constructor for JSON deserialization
  PostsModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] as int,
        id = json['id'] as int,
        title = json['title'] as String,
        body = json['body'] as String;

  final int userId;
  final int id;
  final String title;
  final String body;

  /// Copy method to create a new instance with updated values
  PostsModel copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) {
    return PostsModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  /// Converts the instance to a JSON-compatible Map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
