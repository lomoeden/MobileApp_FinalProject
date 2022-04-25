class User {
  final String id;
  final String username;
  final String email;
  final String post;
  final int rating;
  final String recipe;
  final String title;
  final String image;

  User(
      {required this.id,
        required this.username,
        required this.email,
        required this.post,
        required this.title,
        required this.image,
        required this.rating,
        required this.recipe,});

  User.fromJson(String id, Map<String, dynamic> json)
      : this(
      id: id,
      username: json["username"],
      email: json["email"],
      post: json["post"],
      title: json["title"],
      image: json["image"],
      rating: json["rating"],
      recipe: json["recipe"]);

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "post": post,
      "title": title,
      "image": image,
      "rating": rating,
      "recipe": recipe,
    };
  }
}