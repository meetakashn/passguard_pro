import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewShowing extends StatefulWidget {
  const ReviewShowing({super.key});

  @override
  State<ReviewShowing> createState() => _ReviewShowingState();
}

class _ReviewShowingState extends State<ReviewShowing> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    user = auth.currentUser;
    super.initState();
  }

  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('review').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No Review Found"));
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
            final String review = topic['review'];
            final String username = topic['username'];
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.greenAccent, // Blue
                        Colors.white // Black
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
                      "${review + " -" + username}",
                      style: TextStyle(
                          fontSize: 10,
                          fontFamily: GoogleFonts.alike().fontFamily,
                          color: Colors.black,
                          letterSpacing: 1),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            );
          },
        );
      },
    );
  } // End of ReviewShowing widget
}
