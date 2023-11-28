import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passguard_pro/AboutUs/reviewshowing.dart';
import 'package:passguard_pro/utils/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  var usernametext;
  TextEditingController _reviewcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    user = auth.currentUser;
    getdata();
    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.yellow.shade400,
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
          child: SingleChildScrollView(
            child: Container(
              color: Colors.yellow.shade400,
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(
                    "About Us",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/loginpass.png",
                                width: 60, height: 100),
                            Text(
                              "Passguard Pro is a cutting-edge password management\n"
                              "application designed to keep your digital life secure.\n"
                              "My mission is to provide a user-friendly and highly secure\n"
                              "platform for managing passwords effortlessly. Developed by\n"
                              "a passionate person of tech enthusiasts,I dedicated\n"
                              "to simplifying digital security and safeguarding your\n"
                              "online identity. Welcome to Passguard Pro – your trusted\n"
                              "partner in password protection.",
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Text("Social Media",
                              style: TextStyle(
                                color: Colors.black,
                              )),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    launchUrl(
                                      Uri.parse(
                                          "https://www.facebook.com/meetakashn24"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  icon: Image.asset(
                                      "assets/images/facebook.png")),
                              IconButton(
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(
                                          "https://www.instagram.com/meet_akash_n/"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  icon: Image.asset(
                                      "assets/images/instagram.png")),
                              IconButton(
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(
                                          "https://twitter.com/meetakashn"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  icon:
                                      Image.asset("assets/images/twitter.png")),
                              IconButton(
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(
                                          "https://www.linkedin.com/in/meetakashn/"),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                                  icon: Image.asset(
                                      "assets/images/linkedin.png")),
                            ],
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 380,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Expanded(child: ReviewShowing()),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                            child: Image.asset(
                              "assets/images/review.png",
                              width: 30,
                              height: 60,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 280,
                          height: 55,
                          child: TextFormField(
                            controller: _reviewcontroller,
                            decoration: InputDecoration(
                                hintText: "write your review",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                )),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              storereview();
                              _reviewcontroller.clear();
                            },
                            icon: Icon(Icons.send)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            onPressed: () {
                              launchUrl(
                                Uri(
                                    scheme: 'mailto',
                                    path: "akashnoffical03@gmail.com"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text(
                              "Contact us",
                              style: TextStyle(color: Colors.black),
                            )),
                        SizedBox(),
                        TextButton(
                            onPressed: () {
                              launchUrl(
                                Uri.parse(
                                    "https://www.instagram.com/meet_akash_n/"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text("Creator",
                                style: TextStyle(color: Colors.black))),
                        TextButton(
                            onPressed: () {
                              launchUrl(
                                Uri.parse(
                                    "https://docs.google.com/document/d/1_f3sM2i9eu1tEEmNngynMAcwvpnTuZZ8VWbdCUb83TM/edit?usp=sharing"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text("Terms & Conditions",
                                style: TextStyle(color: Colors.black))),
                        SizedBox(),
                        TextButton(
                            onPressed: () {
                              launchUrl(
                                Uri.parse(
                                    "https://docs.google.com/document/d/1QwGl2vaOZpgtbyxYyOxLyvMHKiuPrAOaFlEpXjy47Cw/edit?usp=sharing"),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Text("Privacy",
                                style: TextStyle(color: Colors.black)))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getdata() async {
    User? user = auth.currentUser;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    setState(() {
      usernametext = userDoc.get('username');
    });
  }

  storereview() async {
    FirebaseFirestore.instance.collection("review").add({
      'username': usernametext,
      'review': _reviewcontroller.text.trim().toString(),
    });
  }

  //for back button
  Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(context, MyRoutes.homepage);
    return true;
  }
}
