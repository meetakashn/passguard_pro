import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/routes.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController countrycode = TextEditingController();
  bool _isPasswordVisible = false;
  String emailaddress = "";
  String password = "";
  @override
  void initState() {
    // TODO: implement initState
    countrycode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Image.asset("assets/images/loginpass.png",
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
                    "\" Welcome back \"",
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
                      SizedBox(
                        height: 20,
                      ),
                      // for password
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
                              obscureText: !_isPasswordVisible,
                              onChanged: (value) {
                                password = value;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
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
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 27.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, MyRoutes.forgotpasswordpage);
                            },
                            child: Text("Forgot password ?"))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 282.w,
                    height: 30.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (emailaddress.toString().isEmpty ||
                            password.toString().isEmpty) {
                          _noempty(context);
                        } else {
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailaddress, password: password);
                            FocusScope.of(context).unfocus();
                            Navigator.pushReplacementNamed(
                                context, MyRoutes.signlockscreenpage);
                          } on FirebaseAuthException catch (e) {
                            _wronguser(context);
                          }
                        }
                      },
                      child: Text(
                        "Sign in",
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
                  SizedBox(
                    height: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have account ?"),
                      TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pushReplacementNamed(
                              context, MyRoutes.registerpage);
                        },
                        child: Text("Sign up"),
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
        content: const Text('Field should not be empty'),
      ),
    );
  }

  void _wronguser(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text("Incorrect email or password"),
      ),
    );
  }
}
