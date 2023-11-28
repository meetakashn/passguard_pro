import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/routes.dart';

class ProfileAccount extends StatefulWidget {
  const ProfileAccount({super.key});

  @override
  State<ProfileAccount> createState() => _ProfileAccountState();
}

class _ProfileAccountState extends State<ProfileAccount> {
  String emailaddress = "";
  String username = "";
  bool userbool = false, buttonbool = false;
  TextEditingController emailaddresstext = TextEditingController();
  TextEditingController usernametext = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 27,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, MyRoutes.homepage);
          },
        ),
        title: Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontFamily: GoogleFonts.lato().fontFamily),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logout'),
                      content: Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Logout'),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushNamedAndRemoveUntil(context,
                                MyRoutes.signingpage, (route) => false);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
                size: 22.sp,
              )),
        ],
      ),
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Image.asset("assets/images/registerimage.jpg",
                        width: 300.w, height: 200.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Hii', // First word
                            style: TextStyle(
                              color: Colors.black, // Color of the first word
                              fontSize: 20.sp, // Font size of the first word
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.lato().fontFamily,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    ' \' ${usernametext.text.toString()} \' ', // Second word
                                style: TextStyle(
                                  color: Colors.red, // Color of the second word
                                  fontSize:
                                      18.sp, // Font size of the second word
                                  fontFamily:
                                      GoogleFonts.albertSans().fontFamily,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        child: Text("  Username",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: GoogleFonts.lato().fontFamily)),
                        alignment: Alignment.topLeft),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 280,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                controller: usernametext,
                                enabled: userbool,
                                maxLength: 15,
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    userbool = false;
                                  });
                                },
                                onChanged: (value) {
                                  usernametext.text = value;
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  userbool = true;
                                });
                              },
                              icon: Icon(Icons.edit_rounded)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        child: Text("  Email",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: GoogleFonts.lato().fontFamily)),
                        alignment: Alignment.topLeft),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 280,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                controller: emailaddresstext,
                                enabled: false,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 325,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          final scaffold = ScaffoldMessenger.of(context);
                          if (usernametext.text.toString().isEmpty) {
                            scaffold.showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                content: Text("Field should not be empty"),
                              ),
                            );
                          }
                          // Check if the string has more than 5 characters
                          else if (usernametext.text.toString().length <= 5) {
                            scaffold.showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                content: Text(
                                    "Field should have more than 5 characters"),
                              ),
                            );
                          }

                          // Check if the string contains only alphabets and numbers
                          else if (!RegExp(r'^[a-zA-Z0-9]+$')
                              .hasMatch(usernametext.text.toString())) {
                            scaffold.showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                                content: Text(
                                    "Field should only contain alphabets and numbers"),
                              ),
                            );
                          } else {
                            storeUserinfo();
                          }
                        },
                        child: Text(
                          "Update",
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(width: 1))),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, MyRoutes.aboutuspage);
                        },
                        child: Text("About us")),
                  ],
                ),
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
      usernametext.text = userDoc.get('username');
      emailaddresstext.text = userDoc.get('emailaddress');
    });
  } //getdata

  storeUserinfo() async {
    User? user = auth.currentUser;
    // Store additional user information in Firestore
    await FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
      'username': usernametext.text.toString(),
    }).then((value) => {
          usernametext.clear(),
        });
    Navigator.pushReplacementNamed(context, MyRoutes.homepage);
  }

  //for back button
  Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(context, MyRoutes.homepage);
    return true;
  }
}
