import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:mobile_app_final_project/post_reicpes.dart';
import 'package:mobile_app_final_project/rate.dart';
import 'package:mobile_app_final_project/recipe_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipies = [];
  late String ingridients;
  bool _loading = false;
  String query = "";
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? current_user = FirebaseAuth.instance.currentUser;
  final CollectionReference _username = FirebaseFirestore.instance.collection(
      "users");
  //
  // void getUsername(){
  //   _db.collection("user")
  //       // .doc(current_user!.uid)
  //       .snapshots()
  //       .listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
  //     snapshot.docs.map((QueryDocumentSnapshot doc) {
  //       u.User.fromJson(doc.id, doc.data() as Map<String, dynamic>);
  //     });
  //   });
  // }


  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe App"),
        backgroundColor: const Color(0xff9e9e9e),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder:
                    (BuildContext context) => postRecipes()));
              })],
      ),
      body: Stack(
        children: <Widget>[
          Container(

            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xff9e9e9e),
                      Color(0xff9e9e9e)
                    ],
                    begin: FractionalOffset.topRight,
                    end: FractionalOffset.bottomLeft)),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: !kIsWeb ? Platform.isIOS? 60: 30 : 30, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Search your recipe here...",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,),
                            decoration: const InputDecoration(
                              hintText: "Enter Ingridients",
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.white54,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () async {
                              if (textEditingController.text.isNotEmpty) {
                                setState(() {
                                  _loading = true;
                                });
                                recipies = [];
                                String url =
                                    "https://api.edamam.com/search?q=${textEditingController.text}&app_id=75862168&app_key=eaa751eb66608b026e8916cd01aa2414";
                                var response = await http.get(Uri.parse(url));
                                Map<String, dynamic> jsonData =
                                jsonDecode(response.body);
                                jsonData["hits"].forEach((element) {
                                  RecipeModel recipeModel;
                                  recipeModel =
                                      RecipeModel.fromMap(element['recipe']);
                                  recipies.add(recipeModel);
                                });
                                setState(() {
                                  _loading = false;
                                });
                              } else {
                                print("None");
                              }
                            },
                            child: Container(
                              decoration: const BoxDecoration(

                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const <Widget>[
                                  Icon(
                                      Icons.search,
                                      size: 30,
                                      color: Colors.white
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: GridView(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisSpacing: 10.0, maxCrossAxisExtent: 200.0),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const ClampingScrollPhysics(),
                        children: List.generate(recipies.length, (index) {
                          return GridTile(
                            footer: GridTileBar(
                              backgroundColor: Colors.black54,
                              leading: LikeButton(
                                size: 30,
                                // likeCount: 0,
                                likeBuilder: (bool like) {
                                  return const Icon(
                                    Icons.thumb_up,
                                    color: Colors.red,
                                    // ),
                                  );
                                },
                              ),
                            ),
                            child: RecipieTile(
                              title: recipies[index].label,
                              imgUrl: recipies[index].image,
                              desc: recipies[index].source,
                              url: recipies[index].url,
                            ),
                          );
                        })),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  const RecipieTile({required this.title, required this.desc, required this.imgUrl, required this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  void _launchURL() async {
    final Uri _url = Uri.parse('https://flutter.dev');
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _launchURL();
          },
          child: Container(
            margin: EdgeInsets.all(5),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration:
                  const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black54, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child:
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          widget.desc,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                        IconButton(
                            icon: const Icon(
                              Icons.tag_faces,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder:
                                  (BuildContext context) => RatingDialog(recipe_name: widget.title, userId: userId,)));
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}