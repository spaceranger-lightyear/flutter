import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:artpia/assets/module.dart';
import 'package:artpia/pages/profile/profile.dart';

Widget searchAppBar(BuildContext context) {
  return AppBar(
    toolbarHeight: MediaQuery.of(context).size.height * 0.07,
    elevation: 0,
    centerTitle: true,
    backgroundColor: Colors.white,
    title: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.black),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Icon(CupertinoIcons.search),
          ),
          SizedBox(width: 10,),
          Text('Search here!'),
        ],
      ),
    ),
  );
}

Widget hotArtists(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: EdgeInsets.only(top: 30, left: 20),
        child: Text('Hot Artists'),
      ),
      // getArtists(context),
    ],
  );
}

// Widget getArtists(BuildContext context) {
//   return StreamBuilder<QuerySnapshot>(
//     stream: FirebaseFirestore.instance.collection('user').snapshots(),
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) return CircularProgressIndicator();
//       return portraits(context, snapshot.data.docs);
//     },
//   );
// }
//
// Widget portraits(BuildContext context, List<DocumentSnapshot> snapshot) {
//   List<UserClass> userItems = snapshot.map((e) => UserClass.fromSnapshot(e)).toList();
//
//   return Container(
//     height: 130,
//     child: ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: userItems.length,
//       itemBuilder: (context, index) {
//         return Container(
//           margin: EdgeInsets.only(top: 30, left: 20),
//           child: artistDetail(context, userItems[index]),
//         );
//       },
//     ),
//   );
// }

Widget artistDetail(BuildContext context, UserClass user) {
  return Container(
    margin: EdgeInsets.only(right: 8),
    child: Column(
      children: <Widget>[
        profileImage(context, user),
        Text('@' + user.username),
      ],
    ),
  );
}