import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';



import '../modle/user.dart';
import './home.dart';
import 'loginpage.dart';

class UserDetails extends StatefulWidget {
  String email;


  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference ;
  User user;
  String key;
  List<User> userList = List();
  File _image;

  var _name = new TextEditingController();
  var _mobile = new TextEditingController();


  @override
  void initState() {
    getSharedPreference();
    databaseReference = database.reference().child("UserDetails");
    databaseReference.onChildAdded.listen(_getUserDetails);
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

  void getSharedPreference() async{
    final prefs = await SharedPreferences.getInstance();   //save username
    if(prefs.getString('userEmail') == null){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
      );
    }else{
      widget.email = prefs.getString('userEmail');
    }
  }


  _getUserDetails(Event event){
    userList.add(User.fromSnapshot(event.snapshot));
    if(event.snapshot.value['email'] == widget.email){
      _name.text = event.snapshot.value['name'];
      _mobile.text = event.snapshot.value['mobile'];
      key = event.snapshot.key;
    }
  }
  void uploadUserDetails(){

    databaseReference.child(key).child('name').set(_name.text);
    databaseReference.child(key).child('mobile').set(_mobile.text);

    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new PickDate();
        });
    Navigator.of(context).push(router);
  }


  Future<String> _pickSaveImage() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    StorageReference ref =
    FirebaseStorage.instance.ref().child('profileImages').child("sfwfwfsfsfs");
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

}
