import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_final_project/login.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  final String postUrl;
  RecipeView({required this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String finalUrl ;

  @override
  void initState() {
    super.initState();
    finalUrl = widget.postUrl;
    if(widget.postUrl.contains('http://')){
      finalUrl = widget.postUrl.replaceAll("http://","https://");
      print(finalUrl + "this is final url");
    }
  }

  Future<void> _logout() async{
    await _auth.signOut();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => login()));
  }

  createAlertDialog(BuildContext context){
    TextEditingController customController = new TextEditingController();
    return showDialog(context:context, builder: (context) {
      return AlertDialog(
        title: Text("Are you sure you want to logout?"),
        actions:<Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Yes'),
            onPressed: _logout,
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text('No'),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Post Your Recipes"),
          // title: Text("Recipe App"),
          actions: <Widget>[
            Container(
              height: 50,
              child: Row(
                children: [
                  Wrap(
                    children: [
                      IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            createAlertDialog(context);
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: Platform.isIOS? 60: 30, right: 24,left: 24,bottom: 16),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color(0xff213A50),
                          Color(0xff071930)
                        ],
                        begin: FractionalOffset.topRight,
                        end: FractionalOffset.bottomLeft)),
                child:  Row(
                  mainAxisAlignment: kIsWeb
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: const <Widget>[
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - (Platform.isIOS ? 104 : 30),
                width: MediaQuery.of(context).size.width,
                child: WebView(
                  onPageFinished: (val){
                    print(val);
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: finalUrl,
                  onWebViewCreated: (WebViewController webViewController){
                    setState(() {
                      _controller.complete(webViewController);
                    });
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}