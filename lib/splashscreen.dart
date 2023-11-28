import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passguard_pro/utils/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    _navigator();
  }

  _navigator() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.pushReplacementNamed(
      context,
      user != null ? MyRoutes.signlockscreenpage : MyRoutes.signingpage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/loginpass.png',
                width: 180.sp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "PassGuard ",
                    style: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontSize: 24.sp,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Pro",
                    style: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontSize: 23.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ],
              ),
              Text(
                "Where Passwords Rest in Fortified Vaults",
                style: TextStyle(
                    fontFamily: GoogleFonts.lato().fontFamily, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
