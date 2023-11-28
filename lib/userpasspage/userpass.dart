import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPassPage extends StatefulWidget {
  late String topicName;
  late String topicID;
  UserPassPage({required this.topicName, required this.topicID, Key? key})
      : super(key: key);
  @override
  State<UserPassPage> createState() => _UserPassPageState();
}

class _UserPassPageState extends State<UserPassPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    user = auth.currentUser;
    super.initState();
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(user!.uid)
          .collection(widget.topicID)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No Data Found"));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.black,
            value: 0.8,
          ));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot topic = snapshot.data!.docs[index];
            final String username = topic['username'];
            final String userpassID = topic.id;
            final String userpass = topic['password'];
            final String CreatedAt = topic['createdAt'];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFDD2A2A), // Blue
                    Color(0xFFFFFFFF), // Black
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  "${username + "\n" + userpass}",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: GoogleFonts.alike().fontFamily,
                      color: Colors.white,
                      letterSpacing: 5),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      CreatedAt,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: Icon(Icons.edit, color: Colors.black),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => EditTopicPop(
                              widget.topicID, username, userpass, userpassID),
                        );
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                ConfirmationDelete(userpassID),
                          );
                        },
                        child: Icon(Icons.delete, color: Colors.black)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  } // End of UserPassPage widget

  Widget EditTopicPop(String CollectionName, String UserName, String UserPass,
      String UserPassId) {
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
            controller: _usernameController..text = "$UserName",
            maxLength: 18,
            decoration: InputDecoration(
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
            controller: _passwordController..text = "$UserPass",
            maxLength: 18,
            decoration: InputDecoration(
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
                  edititle(CollectionName, UserName, UserPass, UserPassId);
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

  Widget ConfirmationDelete(String UserPassID) {
    return AlertDialog(
      title: Text('Delete'),
      content: Text('Are you sure you want to Delete?'),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Delete'),
          onPressed: () async {
            deletetitle(UserPassID);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  edititle(String CollectionName, String UserName, String UserPass,
      String UserPassId) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .collection(CollectionName)
        .doc(UserPassId)
        .update({
      'username': _usernameController.text.trim().toString(),
      'password': _passwordController.text.trim().toString(),
    });
  }

  deletetitle(String UserPassId) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .collection(widget.topicID)
        .doc(UserPassId)
        .delete();
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
