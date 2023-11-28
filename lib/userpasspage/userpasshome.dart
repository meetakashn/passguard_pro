import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passguard_pro/userpasspage/userpass.dart';

import '../utils/routes.dart';

class UserPassHome extends StatefulWidget {
  late String topicName;
  late String topicID;
  late String uid;
  UserPassHome(
      {required this.topicName,
      required this.topicID,
      required this.uid,
      Key? key})
      : super(key: key);
  @override
  State<UserPassHome> createState() => _UserPassHomeState();
}

class _UserPassHomeState extends State<UserPassHome> {
  String userId = "";
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    User? user = auth.currentUser;
    userId = user!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 28,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, MyRoutes.homepage);
          },
        ),
        centerTitle: true,
        title: Text(
          "PassGuard Pro",
          style: TextStyle(
              color: Colors.white, fontFamily: GoogleFonts.lato().fontFamily),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: UserPassPage(
                      topicName: widget.topicName, topicID: widget.topicID)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => AddUserPass(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Adding title
  Widget AddUserPass() {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Your Details', textAlign: TextAlign.center),
      titleTextStyle: TextStyle(
        fontSize: 19,
        letterSpacing: 1,
        color: Colors.black,
        fontFamily: GoogleFonts.aldrich().fontFamily,
      ),
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(12)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _usernameController,
            maxLength: 25,
            decoration: InputDecoration(
                hintText: "Username (e.g @username)",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                )),
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            controller: _passwordController,
            maxLength: 25,
            decoration: InputDecoration(
                hintText: "Password (e.g 6767@pass)",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                )),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 90,
            child: ElevatedButton(
              onPressed: () {
                if (_usernameController.text.toString().isEmpty ||
                    _passwordController.text.toString().isEmpty) {
                  _titleempty(context);
                } else {
                  storetitle();
                  Navigator.of(context).pop();
                  _usernameController.clear();
                  _passwordController.clear();
                }
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(12))),
            ),
          ),
        ],
      ),
    );
  }

  storetitle() async {
    User? user = auth.currentUser;
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Create a DateTime object with the same date but time set to midnight
    DateTime todayAtMidnight =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    String formattedDate =
        "${todayAtMidnight.year}-${todayAtMidnight.month}-${todayAtMidnight.day}";
    DocumentReference documentReference = await FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .collection(widget.topicID)
        .add({
      'createdAt': formattedDate,
      'username': _usernameController.text.trim().toString(),
      'password': _passwordController.text.trim().toString(),
    });
  }

  void _titleempty(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text("Field should not be empty"),
      ),
    );
  }
}
