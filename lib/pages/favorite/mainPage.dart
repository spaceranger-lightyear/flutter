import 'package:bak/models/components/cards.dart';
import 'package:bak/models/classes/product.dart';
import 'package:bak/models/components/navigation.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefaultDeep(context, 'Likes'),
      body: ListView(
        physics: ClampingScrollPhysics(),
        //shrinkWrap: true,
        children: [
          GridView.count(crossAxisCount: 2,
            childAspectRatio: 0.6,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: [
//              productItemCardLarge(context, new Product('title', 10000000, '/')),
//              productItemCardLarge(context, new Product('title', 10000000, '/')),
//              productItemCardLarge(context, new Product('title', 10000000, '/')),
//              productItemCardLarge(context, new Product('title', 10000000, '/')),

            ],)
        ],
      ),
    );
  }
}