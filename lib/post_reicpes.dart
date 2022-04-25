
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'display_post.dart';
import 'login.dart';

class postRecipes extends StatelessWidget {
  // postRecipes({
  //   required this.recipes,
  // });

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? current_user = FirebaseAuth.instance.currentUser;
  final _post = TextEditingController();
  final _title = TextEditingController();
  final _image = TextEditingController();
  late final String recipes;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Your Recipes"),
        backgroundColor: const Color(0xff9e9e9e),
      ),
      body: Center(
        child:
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              // const Text("Post your Recipes"),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:
                  TextField(
                    autofocus: true,
                    controller: _title,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.grey,width:2.0),
                      ),
                      hintText: 'Enter title here...',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  )
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:
                  TextField(
                    autofocus: true,
                    controller: _post,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.grey,width:2.0),
                      ),
                      hintText: 'Enter your post here...',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  )
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:
                  TextField(
                    autofocus: true,
                    controller: _image,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.grey,width:2.0),
                      ),
                      hintText: 'Enter image url here...',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  )
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => login()));
                    },
                    child: const Text("Upload Image")
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                    onPressed: () {
                      _sendMessage(_post.text);
                    },
                    child: const Text("Send")
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => displayPost(recipes:recipes, user_id: current_user!.uid)));
                    },
                    child: const Text("View Posts")
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _sendMessage(context) async {
    try {
      await _db
          .collection("users")
          .doc(current_user!.uid)
          .collection("posts")
          .doc(Timestamp.now().millisecondsSinceEpoch.toString())
          .set({
        "title": _title.text,
        "post": _post.text,
        "image": _image.text,
        "time_created": Timestamp.now(),
      });
      _post.clear();
      _title.clear();
      _image.clear();
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? "Unknown Error")));
    }
  }
}