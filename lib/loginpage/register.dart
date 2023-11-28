import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/routes.dart';

class Register extends StatefulWidget {
  const Register({super.key});
  static String uid = "";
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();

  TextEditingController usernametext = TextEditingController();
  TextEditingController emailaddresstext = TextEditingController();
  TextEditingController passwordtext = TextEditingController();
  bool _isPasswordVisible = false;
  String emailaddress = "";
  String password = "";
  String username = "";
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
                    const SizedBox(
                      height: 40,
                    ),
                    Image.asset("assets/images/registerimage.jpg",
                        width: 300.w, height: 200.h),
                    Text(
                      "Create an account",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: GoogleFonts.lato().fontFamily),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          // for username
                          SizedBox(
                            width: 320,
                            height: 70,
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLength: 15,
                              decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                hintText: "Username",
                                suffixIcon: Icon(Icons.person_2_rounded),
                                suffixIconColor: Colors.blueAccent,
                              ),
                              controller: usernametext,
                              onChanged: (value) {
                                username = value;
                              },
                              validator: (value) {
                                // Check if the string is not empty
                                if (value!.isEmpty) {
                                  return "Field should not be empty";
                                }

                                // Check if the string has more than 5 characters
                                if (value.length <= 5) {
                                  return 'Field should have more than 5 characters';
                                }

                                // Check if the string contains only alphabets and numbers
                                if (!RegExp(r'^[a-zA-Z0-9]+$')
                                    .hasMatch(value)) {
                                  return 'Field should only contain alphabets and numbers';
                                }

                                // Return null if the input is valid
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // For E mail id
                          Container(
                            height: 70,
                            width: 320,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                emailaddress = value;
                              },
                              controller: emailaddresstext,
                              validator: (value) {
                                if (!RegExp(
                                        r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                    .hasMatch(value!)) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                hintText: "Email Id",
                                suffixIcon: Icon(Icons.mail),
                                suffixIconColor: Colors.blueAccent,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // for password
                          Container(
                            height: 70,
                            width: 320,
                            child: TextFormField(
                              controller: passwordtext,
                              obscureText: !_isPasswordVisible,
                              onChanged: (value) {
                                password = value;
                              },
                              validator: (value) {
                                final minLength = 8;
                                final hasUppercase =
                                    RegExp(r'[A-Z]').hasMatch(password);
                                final hasLowercase =
                                    RegExp(r'[a-z]').hasMatch(password);
                                final hasDigits =
                                    RegExp(r'\d').hasMatch(password);
                                if (password.length >= minLength &&
                                    hasUppercase &&
                                    hasLowercase &&
                                    hasDigits) {
                                  return null;
                                }
                                return "password must contain uppercase, lowercase, digit";
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                hintText: "Password",
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    // Toggle the visibility state
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    // register
                    SizedBox(
                      width: 282.w,
                      height: 30.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            print("Enter");
                            try {
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: emailaddress,
                                password: password,
                              );
                              // Get the newly created user's UID
                              Register.uid = credential.user!.uid;
                              storeUserinfo();
                              Navigator.pushReplacementNamed(
                                  context, MyRoutes.lockscreenpage);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                              } else if (e.code == 'email-already-in-use') {
                                print(
                                    'The account already exists for that email.');
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: const Text(
                          "Sign up",
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
                    const SizedBox(
                      height: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account ?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, MyRoutes.signingpage);
                          },
                          child: const Text("Sign in"),
                          style: TextButton.styleFrom(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //for back button
  Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(context, MyRoutes.signingpage);
    return true;
  }

  storeUserinfo() async {
    // Store additional user information in Firestore
    await FirebaseFirestore.instance.collection('user').doc(Register.uid).set({
      'username': usernametext.text,
      'emailaddress': emailaddresstext.text,
      'password': passwordtext.text,
    }).then((value) => {
          usernametext.clear(),
          emailaddresstext.clear(),
          passwordtext.clear(),
        });
  }
}
