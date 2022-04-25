import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_final_project/user.dart' as u;
import 'package:webview_flutter/webview_flutter.dart';


class displayPost extends StatelessWidget {
  displayPost({
    required this.user_id,
  });

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CollectionReference _postRef = FirebaseFirestore.instance.collection(
      "posts");
  final _message = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String user_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Display Posts"),
        ),
        body: StreamBuilder(
            stream: _db
                .collection('user')
                .doc("user_id")
                .collection("posts")
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
                        u.User post = u.User.fromJson(doc.id, doc.data() as Map<String, dynamic>);
                        // String posts = post.post;
                        return ListTile(
                            title: Text(post.post),
                        subtitle: Text(post.username),
                        );
                      });
                }
              } else {
                return const Text("no record");
              }
            })
    );
  }

  List<u.User> post = [];
  void getStreams() async {
    _db.collection("users")
        .doc(user_id)
        .collection("posts")
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      snapshot.docs.map((QueryDocumentSnapshot doc) {
        post.add(
            u.User.fromJson(doc.id, doc.data() as Map<String, dynamic>));
      });
    });
  }
}