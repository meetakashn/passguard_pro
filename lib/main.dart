import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:passguard_pro/AboutUs/aboutus.dart';
import 'package:passguard_pro/Screenlock/screenlock.dart';
import 'package:passguard_pro/Screenlock/signlock.dart';
import 'package:passguard_pro/homepage/homepage.dart';
import 'package:passguard_pro/homepage/profileaccount.dart';
import 'package:passguard_pro/loginpage/forgotpassword.dart';
import 'package:passguard_pro/loginpage/signin.dart';
import 'package:passguard_pro/splashscreen.dart';
import 'package:passguard_pro/utils/routes.dart';
import 'package:passguard_pro/widgets/theme.dart';

import 'loginpage/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const app());
}

class app extends StatefulWidget {
  const app({super.key});

  @override
  State<app> createState() => _appState();
}

class _appState extends State<app> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  //internet checker
  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox(context);
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) {
          return MaterialApp(
            themeMode: ThemeMode.light,
            theme: Mytheme.lighttheme(context),
            darkTheme: Mytheme.darktheme(context),
            debugShowCheckedModeBanner: false,
            initialRoute: MyRoutes.splashpage,
            routes: {
              MyRoutes.splashpage: (context) => SplashScreen(),
              MyRoutes.signingpage: (context) => SignIn(),
              MyRoutes.registerpage: (context) => Register(),
              MyRoutes.forgotpasswordpage: (context) => ForgotPassword(),
              MyRoutes.profilepage: (context) => ProfileAccount(),
              MyRoutes.homepage: (context) => HomePage(),
              MyRoutes.lockscreenpage: (context) => LockScreen(),
              MyRoutes.signlockscreenpage: (context) => SignLockScreen(),
              MyRoutes.aboutuspage: (context) => AboutUs(),
            },
          );
        });
  }

  showDialogBox(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("No Connection"),
      content: Text("Please check your internet connectivity"),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () async {
            Navigator.of(context).pop();
            setState(() => isAlertSet = false);
            isDeviceConnected = await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              showDialogBox(context);
              setState(() => isAlertSet = true);
            }
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
