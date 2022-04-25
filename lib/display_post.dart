import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_final_project/post.dart';


class displayPost extends StatelessWidget {
  displayPost({
    required this.recipes, required this.user_id,
  });

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _postRef = FirebaseFirestore.instance.collection(
      "posts");
  final _message = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String recipes;
  final String user_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Display Posts"),
        ),
        body: StreamBuilder(
            stream: _db
                .collection('posts')
                .doc(recipes)
                .collection(user_id)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                print(snapshot.data!.docs.length);
                if (snapshot.data!.docs.isEmpty){
                  return const Text("No record");
                } else {
                  return ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index){
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        Post post = Post.fromJson(doc.data() as Map<String, dynamic>);
                        String currPost = post.post;
                        return Text(currPost);
                      });
                }
              } else {
                return const Text("no record");
              }
            })
    );
  }

  List<Post> post = [];
  void getStreams() async {
    _db.collection("posts")
        .doc(recipes)
        .collection(user_id)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      snapshot.docs.map((QueryDocumentSnapshot doc) {
        post.add(
            Post.fromJson(doc.data() as Map<String, dynamic>));
      });
    });
  }
}