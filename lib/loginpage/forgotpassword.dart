import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/routes.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailaddresstext = TextEditingController();
  final auth = FirebaseAuth.instance;
  String emailaddress = "";
  bool state = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              color: Colors.white,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Image.asset("assets/images/locki.png",
                        width: 300.w, height: 180.h),
                    RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        text: '"Where Passwords Rest in Fortified Vaults."\n',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19.0,
                          fontFamily: GoogleFonts.cabin().fontFamily,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' – PassGuard Pro',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                              fontFamily: GoogleFonts.cabin().fontFamily,
                              fontSize: 19.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "\" Reset Your Password\"",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.lato().fontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        // For E mail id
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            width: 320,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                controller: emailaddresstext,
                                onChanged: (value) {
                                  emailaddress = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email Id",
                                  suffixIcon: Icon(Icons.mail),
                                  suffixIconColor: Colors.blueAccent,
                                ),
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: 282.w,
                      height: 30.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (emailaddress.toString().isEmpty) {
                            _noempty(context);
                          } else {
                            if (RegExp(r'@gmail\.com$', caseSensitive: false)
                                .hasMatch(emailaddresstext.text.toString())) {
                              try {
                                // Check if the provided email matches any stored emails in Firestore
                                QuerySnapshot querySnapshot =
                                    await FirebaseFirestore.instance
                                        .collection(
                                            'user') // Change 'users' to your actual collection name
                                        .where('emailaddress',
                                            isEqualTo: emailaddresstext.text
                                                .toString())
                                        .get();
                                if (querySnapshot.docs.isNotEmpty) {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: emailaddresstext.text);
                                  setState(() {
                                    state = true;
                                  });
                                  Future.delayed(Duration(milliseconds: 1000),
                                      () {
                                    setState(() {
                                      state = false;
                                    });
                                  });
                                } else {
                                  wrongemail(context);
                                }
                              } catch (e) {
                                wrongemail(context);
                              }
                            } else {
                              _noempty(context);
                            }
                          }
                        },
                        child: Text(
                          "Verify Your Account",
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 1,
                          backgroundColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, MyRoutes.signingpage);
                            },
                            child: Text("Sign in"))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    state
                        ? Text("Password reset link sended successfully")
                        : Text(""),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _noempty(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        content: const Text('Invalid email'),
      ),
    );
  }

  wronguser(BuildContext context, String s) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text(s),
      ),
    );
  }

  wrongemail(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text("Email doesn't exists"),
      ),
    );
  }

  //for back button
  Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(context, MyRoutes.signingpage);
    return true;
  }
}
