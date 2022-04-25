import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_final_project/home.dart';
import 'package:mobile_app_final_project/login.dart';
import 'package:mobile_app_final_project/post_reicpes.dart';
import 'package:url_launcher/url_launcher.dart';

class group_recipe extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final FirebaseAuth _auth = FirebaseAuth.instance;

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

    void _launchURL() async {
      final Uri _url = Uri.parse("https://at.chefannfoundation.org/healthy-recipes-popup/?gclid=CjwKCAjwjZmTBhB4EiwAynRmD2HWHcwmPS8pm5OSnAJqbdMkTPcSCp0T_L5dQqsMLHXfL2F-3TAG8hoCoKwQAvD_BwE");
      if (!await launchUrl(_url)) throw 'Could not launch $_url';
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Recipe Groups"),
          actions: <Widget>[
            Container(
              height: 50,
              child: Row(
                children: [
                  Wrap(
                    children: [
                      IconButton(
                          icon: const Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder:
                                (BuildContext context) => Home()));
                          }),
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
      body: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: <Widget> [
                GestureDetector(
                onTap: _launchURL,
                child: Image.network('https://www.africanbites.com/wp-content/uploads/2021/07/Healthy-Dinner-in-Under-30-Minutes.png'),
                // const Text('Request1')
                )
              ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: <Widget> [
                Image.network('https://www.julieseatsandtreats.com/wp-content/uploads/2020/03/strawberry-Recipes-square-1-1024x1024.jpg'),
                // const Text('Request2')
              ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: <Widget> [
                Image.network('https://babyfoode.com/wp-content/uploads/2021/03/15-STAGE-ONE-RECIPES-SQUARE-1.png'),
                // const Text('Request3')
              ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: <Widget> [
                Image.network('https://www.noracooks.com/wp-content/uploads/2019/11/thanksgiving.square.3.jpg'),
                // const Text('Request4')
              ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: <Widget> [
                Image.network('https://www.noracooks.com/wp-content/uploads/2020/04/sq.jpg'),
                // const Text('Request5')
              ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: <Widget> [
                Image.network('https://thethingswellmake.com/wp-content/uploads/2019/11/79-healthy-seafood-recipes-featuredsquare.jpg'),
                // const Text('Request6')
              ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: <Widget> [
                Image.network('https://www.recipetineats.com/wp-content/uploads/2020/12/Lobster-recipes-square-image.jpg'),
                // const Text('Request7')
              ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: <Widget> [
                Image.network('https://tidbits-marci.com/wp-content/uploads/2021/03/SQUARE_Easy_Instant_Pot_Beef_Recipes.jpg'),
                // const Text('Request8')
              ],
              ),
            ),
    ],
    )
    );
  }
}
