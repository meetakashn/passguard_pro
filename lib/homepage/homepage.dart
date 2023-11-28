import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passguard_pro/homepage/topicpage.dart';

import '../utils/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String emailaddress = "";
  String password = "";
  String username = "";
  String userId = "";
  TextEditingController _titleController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    User? user = auth.currentUser;
    userId = user!.uid;
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(
            Icons.person_pin,
            size: 28,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, MyRoutes.profilepage);
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
              Expanded(child: TopicPage()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => AddTopicPop(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Adding title
  Widget AddTopicPop() {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Title', textAlign: TextAlign.center),
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
            controller: _titleController,
            maxLength: 18,
            decoration: InputDecoration(
                hintText: "Your Title (e.g Instagram)",
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
                if (_titleController.text.toString().isEmpty) {
                  _titleempty(context);
                } else {
                  storetitle();
                  Navigator.of(context).pop();
                  _titleController.clear();
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
        .collection('topics')
        .add({
      'createdAt': formattedDate,
      'title': _titleController.text.trim().toString(),
      'userId': user.uid,
    });
    String topicId = documentReference.id;
    FirebaseFirestore.instance
        .collection("user")
        .doc(user.uid)
        .collection(topicId)
        .doc()
        .set({
      'createdAt': formattedDate,
      'username': "demo@username",
      'password': "demo@password",
    });
  }

  getdata() async {
    User? user = auth.currentUser;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    setState(() {
      username = userDoc.get('username');
      emailaddress = userDoc.get('emailaddress');
      password = userDoc.get('password');
    });
  } //getdata

  void _titleempty(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text("title should not be empty"),
      ),
    );
  }
}
