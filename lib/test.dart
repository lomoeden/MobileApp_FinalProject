// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class test extends StatelessWidget {
//   const test({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Stream<DocumentSnapshot> courseDocStream = FirebaseFirestore.instance
//         .collection('test')
//         .doc('xOTydDoxxOnfeNar0eM5')
//         .snapshots();
//
//     return StreamBuilder<DocumentSnapshot>(
//         stream: courseDocStream,
//         builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.active) {
//
//             // get course document
//             var courseDocument = snapshot.data?.data;
//
//             // get sections from the document
//             var sections = courseDocument!();
//
//             // build list using names from sections
//             return ListView.builder(
//               itemCount: sections != null ? sections.length : 0,
//               itemBuilder: (_, int index) {
//                 print(sections[index]['username']);
//                 return ListTile(title: Text(sections[index]['username']));
//               },
//             );
//           } else {
//             return Container();
//           }
//         });
//   }
// }
