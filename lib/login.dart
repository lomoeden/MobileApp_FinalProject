import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app_final_project/home.dart';
import 'package:mobile_app_final_project/signup.dart';

class login extends StatelessWidget {
  login({Key? key}) : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  var _email = TextEditingController();
  var _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.black,
        /*appBar: AppBar(
          title: Container(
            child: Text("Login"),
            height: 10,
          ),
          // backgroundColor: const Color(0xff9e9e9e),
        ),*/
        body: Center(
      child: Form(
          key: _formKey,
          child: Container(
            height: 600,
            width: 300,
            padding: EdgeInsets.only(top: 150),
            child: Column(
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    hintText: "Enter Email",
                  ),
                ),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  validator: (String? value) {
                    if (value == null) {
                      return "Password cannot be empty";
                    } else if (value.length < 2) {
                      return "Wrong password";
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter Password",
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login(context);
                      }
                    },
                    child: const Text("Login"),

                  ),
                ),
                SizedBox(
                  height: 150,
                ),
                Text('Don\'t have an account?'),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    child: const Text("Register")),
              ],
            ),
          )),
    ));
  }

  void _login(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
      ScaffoldMessenger.of(context).clearSnackBars();
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Email/Password combination is incorrect")));
      }
      return;
    }

    _email.clear();
    _password.clear();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Home()));
  }
}
