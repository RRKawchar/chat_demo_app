// ignore_for_file: use_build_context_synchronously

import 'dart:io';


import 'package:chat_app/screens/home/home_screens.dart';
import 'package:chat_app/utils/app_colors/app_colors.dart';
import 'package:chat_app/utils/asset_image/k_assets_image.dart';
import 'package:chat_app/utils/helper/dialogs.dart';
import 'package:chat_app/network/firebase_dabase.dart';
import 'package:chat_app/utils/helper/helper_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  _onClickLoginButton() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user)async {
      Navigator.pop(context);
      if (user != null) {
        kPrint("User :${user.user}");
        kPrint("AdditionalUser Info :${user.additionalUserInfo}");

        if(await FirebaseDatabase.userExists()){

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreens(),
            ),
          );
        }else{
          await FirebaseDatabase.createUser().then((value) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreens(),
              ),
            );
          });
        }

      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseDatabase.auth.signInWithCredential(credential);
    } catch (e) {
      kPrint("\n_signInWithGoogle : ${e.toString()}");
      Dialogs.showSnackBar(context, "Something went wrong (Check Internet!)");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Welcome To Chat App"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            left: _isAnimated ? size.width * .25 : -size.width * .5,
            top: size.width * .22,
            width: size.width * .5,
            duration: const Duration(seconds: 1),
            child: Image.asset(
              KAssetsImage.messageIcon,
            ),
          ),
          Positioned(
              left: size.width * .05,
              bottom: size.width * .15,
              width: size.width * .9,
              height: size.height * .07,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenColor.withOpacity(0.4),
                ),
                onPressed: () {
                  _onClickLoginButton();
                },
                icon: Image.asset(
                  KAssetsImage.googleIcon,
                  height: 35,
                ),
                label: const Text(
                  "Signing with Google",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: AppColors.textColor,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
