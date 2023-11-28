import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passguard_pro/userpasspage/userpasshome.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({super.key});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _titleController = TextEditingController();
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
          .collection('topics')
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
            final String topicName = topic['title'];
            final String topicID = topic.id;
            final String createdAtTimestamp = topic['createdAt'];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0052D4), // Blue
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
                  topicName,
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: GoogleFonts.alike().fontFamily,
                      color: Colors.white,
                      letterSpacing: 5),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      createdAtTimestamp,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserPassHome(
                        topicName: topicName,
                        topicID: topicID,
                        uid: user!.uid,
                      ),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: Icon(Icons.edit, color: Colors.black),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              EditTopicPop(topicName, topicID),
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
                                ConfirmationDelete(topicName, topicID),
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
  } // End of TopicPage widget

  Widget EditTopicPop(String titlecontroller, String TopicId) {
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
            controller: _titleController..text = "$titlecontroller",
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
                if (_titleController.text.toString().isEmpty) {
                  _titleempty(context);
                } else {
                  edititle(TopicId);
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

  Widget ConfirmationDelete(String TopicName, String TopicId) {
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
            deletetitle(TopicName, TopicId);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  edititle(String topicid) async {
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .collection('topics')
        .doc(topicid)
        .update({
      'title': _titleController.text.trim().toString(),
    });
  }

  deletetitle(String topicname, String topicid) async {
    String topicId = topicid;
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .collection('topics')
        .doc(topicid)
        .delete();
    deleteSubcollection(user!.uid, topicId);
  }

  Future<void> deleteSubcollection(String userId, String topicId) async {
    final subcollectionRef = FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .collection(topicId);

    // Get all documents in the subcollection
    final QuerySnapshot snapshot = await subcollectionRef.get();

    // Delete each document in the subcollection
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }

    // Delete the subcollection itself
    await FirebaseFirestore.instance
        .collection("user")
        .doc(userId)
        .update({topicId: FieldValue.delete()});
  }

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
