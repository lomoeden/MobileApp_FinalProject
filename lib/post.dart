import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  // final String id;
  final String username;
  final String post;
  final String image;
  final Timestamp time_created;

  Post({
    // required this.id,
    required this.username,
    required this.post,
    required this.image,
    required this.time_created,
  });

  // Post.fromJson(String id, Map<String, dynamic> json)
  //     : this(
  //         id: id,
  //         username: json["username"],
  //         post: json["post"],
  //         image: json["image"],
  //         time_created: json["time_created"],
  //       );

  Post.fromJson(Map<String, dynamic> json)
      : this(
    // id: id,
    username: json["username"],
    post: json["post"],
    image: json["image"],
    time_created: json["time_created"],
  );

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "post": post,
      "image": image,
      "time_created": time_created,
    };
  }
}