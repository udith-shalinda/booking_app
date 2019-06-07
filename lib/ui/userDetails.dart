import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';



import '../modle/user.dart';
import './home.dart';

class UserDetails extends StatefulWidget {
  String email;
  UserDetails({Key key,this.email}):super(key :key);

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference ;
  User user;
  File _image;

  var _name = new TextEditingController();
  var _mobile = new TextEditingController();


  @override
  void initState() {
    databaseReference = database.reference().child("UserDetails");
    user = new User('','','');
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: new Text("User Details"),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Image.asset(
            'images/cover_two.jpg',
            fit: BoxFit.fill,
            width: 500,
            height: 1000,
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title : new TextField(
                  controller: _name,
                  decoration: new InputDecoration(
                    labelText: "Enter your name "
                  ),
                ),
              ),
              new ListTile(
                title : new TextField(
                  controller: _mobile,
                  decoration: new InputDecoration(
                      labelText: "Enter your mobile number "
                  ),
                ),
              ),
              new RaisedButton(
                  child: new Text("Upload an image"),
                  onPressed: (){
                    _pickSaveImage();
                  }),
              new ListTile(
                title: new RaisedButton(
                    onPressed: uploadUserDetails,
                    child: new Text("Submit"),
                )
              )
            ],
          )
        ],
      ),
    );
  }
  void uploadUserDetails(){
    user.name = _name.text;
    user.mobile = _mobile.text;
    user.email = "${widget.email}";

    databaseReference.push().set(user.toJson());

    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new PickDate(userEmail: widget.email,);
        });
    Navigator.of(context).push(router);
  }
  Future<String> _pickSaveImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    StorageReference ref =
    FirebaseStorage.instance.ref().child('profileImages').child("sfwfwf.fhfh");
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

}
