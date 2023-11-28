import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:passguard_pro/utils/routes.dart';
import 'package:pinput/pinput.dart';

class SignLockScreen extends StatefulWidget {
  @override
  _SignLockScreenState createState() => _SignLockScreenState();
}

class _SignLockScreenState extends State<SignLockScreen> {
  String enteredpin = '';
  bool button = false, statetext = false;
  TextEditingController pinController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String verifypin = "";
  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "assets/images/lockscreen.png",
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "App Lock Pin",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 55,
                    ),
                    statetext
                        ? Text(
                            "Wrong password",
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          )
                        : Text(""),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 300.w,
                      child: Pinput(
                        length: 6,
                        showCursor: true,
                        focusNode: _pinPutFocusNode,
                        controller: pinController,
                        keyboardType: TextInputType.none,
                        onChanged: (value) {
                          enteredpin = value;
                          setState(() {
                            if (enteredpin.length == 6) {
                              button = true;
                            }
                          });
                        },
                        defaultPinTheme: PinTheme(
                          width: 57.w,
                          height: 45.h,
                          textStyle: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(11.h),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildCustomKeyboard(),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 295.w,
                      height: 30.h,
                      child: button
                          ? ElevatedButton(
                              onPressed: () async {
                                Verification();
                              },
                              child: const Text(
                                "verify pin",
                                style: TextStyle(fontSize: 20),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 1,
                                backgroundColor: Colors.blueAccent,
                                enableFeedback: false,
                              ),
                            )
                          : null,
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

  Widget buildCustomKeyboard() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildKeyboardRow(['1', '2', '3']),
          SizedBox(height: 10.0),
          buildKeyboardRow(['4', '5', '6']),
          SizedBox(height: 10.0),
          buildKeyboardRow(['7', '8', '9']),
          SizedBox(height: 10.0),
          buildKeyboardRow(['', '0', '<']),
        ],
      ),
    );
  }

  Widget buildKeyboardRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: keys.map((key) {
          return buildKeyboardKey(key);
        }).toList(),
      ),
    );
  }

  Widget buildKeyboardKey(String key) {
    Color keyColor = key == '<' ? Colors.blueAccent : Colors.black;
    Color textColor = key == '<' ? Colors.white : Colors.blueAccent;

    return InkWell(
      onTap: () {
        handleKeyboardKeyPress(key);
      },
      child: Container(
        width: 80.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(11.0),
        ),
        alignment: Alignment.center,
        child: Text(
          key,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }

  void handleKeyboardKeyPress(String key) {
    if (key == '<') {
      // Handle backspace
      if (pinController.text.isNotEmpty) {
        pinController.text =
            pinController.text.substring(0, pinController.text.length - 1);
        setState(() {
          if (enteredpin.length < 6) {
            button = false;
          }
        });
      }
    } else {
      // Handle numeric key
      if (pinController.text.length < 6) {
        pinController.text += key;
      }
    }
  }

  getdata() async {
    User? user = auth.currentUser;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get();
    setState(() {
      verifypin = userDoc.get('screenpass');
    });
  }

  Verification() {
    if (enteredpin == verifypin) {
      Navigator.pushReplacementNamed(context, MyRoutes.homepage);
    } else {
      setState(() {
        statetext = true;
      });
      Future.delayed(Duration(milliseconds: 2000), () {
        setState(() {
          statetext = false;
        });
      });
    }
    setState(() {
      pinController.clear();
      button = false;
      enteredpin = "";
    });
  }

  //for back button
  Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(context, MyRoutes.signingpage);
    return true;
  }
}
