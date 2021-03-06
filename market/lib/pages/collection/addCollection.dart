import 'package:bak/models/classes/collection.dart';
import 'package:bak/models/classes/product.dart';
import 'package:bak/models/classes/user.dart';
import 'package:bak/models/components/navigation.dart';
import 'package:bak/models/designs/colors.dart';
import 'package:bak/models/designs/typos.dart';
import 'package:bak/pages/home/bootPage.dart';
import 'package:bak/pages/product/addProductPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddCollectionPage extends StatefulWidget {
  User user;
  Product product;

  AddCollectionPage({this.user, this.product});

  @override
  _AddCollectionPage createState() => _AddCollectionPage();
}

class _AddCollectionPage extends State<AddCollectionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  List<Asset> _images = List<Asset>();

  String userID;

  String title;
  String imageURI;
  String description = '컬렉션 설명이 없습니다.';

  List<String> products = List<String>();
  List<String> followers = List<String>();
  List<String> tags = List<String>();

  bool canJoin = false;
  bool private = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDefaultDeep(context, '컬렉션 추가'),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            imagePicker(context),
            textFieldTitle(context),
            longTextField(context),
            makeCollectionPrivate(context),
            acceptParticipate(context),
            uploadButton(context),
          ],
        ),
      ),
    );
  }

  Widget imagePicker(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          loadAssets();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * (280 / 375),
          color: Colors.grey,
          child: (_images.isEmpty)
              ? null
              : AssetThumb(
                  asset: _images[0],
                  quality: 100,
                  width: _images[0].originalWidth,
                  height: _images[0].originalHeight,
                ),
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    setState(() {
      _formKey.currentState.save();
      if (_images == null) _images = List<Asset>();
    });

    List<Asset> resultList;
    String _error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: _images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          useDetailsView: false,
          selectCircleStrokeColor: "#FFFFFF",
        ),
      );
    } on Exception catch (e) {
      _error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      _images = resultList;
      _error = _error;
    });
  }

  Widget textFieldTitle(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * (335 / 375),
      height: 44,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) return '컬렉션 제목을 입력하세요.';
          return null;
        },
        onSaved: (value) => title = value,
        style: TextStyle(
          fontSize: 12,
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 10),
            border: InputBorder.none,
            hintText: '컬렉션 이름'),
      ),
    );
  }

  Widget longTextField(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * (335 / 375),
      height: 176,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: TextFormField(
        onSaved: (value) => description = value,
        maxLines: 5,
        style: TextStyle(
          fontSize: 12,
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: 10, left: 10),
            border: InputBorder.none,
            hintText: '컬렉션 설명 (선택)'),
      ),
    );
  }

  Widget makeCollectionPrivate(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 36, bottom: 10, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('이 컬렉션을 비공개로 하기'),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              activeColor: primary,
              value: private,
              onChanged: (value) {
                setState(() {
                  private = !private;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget acceptParticipate(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 35, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('다른 유저들의 참여를 허용하기'),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              activeColor: primary,
              value: canJoin,
              onChanged: (value) {
                setState(() {
                  canJoin = !canJoin;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadButton(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          if (_images?.isEmpty ?? true)
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text('선택된 이미지가 없습니다!'),
                  );
                });
          else
            add();
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: MediaQuery.of(context).size.width * (335 / 375),
          height: 44,
          color: primary,
          child: Center(
            child: Text(
              '컬렉션 추가',
              style: label(offWhite),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> add() async {
    _autoValidate = true;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      uploadImages(_images[0]);
      imageURI = ('gs://newnew-beta.appspot.com/collection/' +
          widget.user.username +
          '+' +
          'collection' +
          widget.user.myCollections.length.toString() +
          '.jpg');

      products.add(widget.product.userID + '+' + widget.product.title);
    }

    addCollection();
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return AlertDialog(
              content: Text('\'' + title + '\'' + '컬렉션에 추가되었습니다!'),
            );
          });

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => BootPage(
                    user: widget.user,
                  )),
          (route) => false);
    } catch (e) {
      print(e.message);
    }
  }

  void uploadImages(Asset asset) async {
    if (_images?.isEmpty ?? true) return;

    String path = 'collection/' +
        widget.user.username +
        '+' +
        'collection' +
        widget.user.myCollections.length.toString() +
        '.jpg';
    ByteData byteData = await asset.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance.ref().child(path);
    StorageUploadTask uploadTask = ref.putData(imageData);

    print(await (await uploadTask.onComplete).ref.getDownloadURL().toString());
  }

  void addCollection() {
    Firestore.instance
        .collection('collections')
        .document(widget.user.username + '+' + title)
        .setData({
      "userID": widget.user.username ?? "",
      "title": title ?? "",
      "imageURI": imageURI ??
          FieldValue.arrayUnion(['gs://newnew-beta.appspot.com/IMG_0909.JPG']),
      "description": description ?? "",
      "followers": followers,
      "tags": tags,
      "products": products,
      "canJoin": canJoin,
      "private": private,
    }).then((value) {
      Firestore.instance
          .collection('products')
          .document(widget.product.userID + '+' + widget.product.title)
          .updateData({
        "collections": FieldValue.arrayUnion(
            [widget.user.username + '+' + title]),}).then((value) {
        Firestore.instance
            .collection('users')
            .document(widget.user.username)
            .updateData({
          "myCollections":
          FieldValue.arrayUnion([widget.user.username + '+' + title])
        });
      });
    });
  }
}
