import 'package:chat_app/main.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/home/home_screens.dart';
import 'package:chat_app/utils/app_colors/app_colors.dart';
import 'package:chat_app/utils/asset_image/k_assets_image.dart';
import 'package:chat_app/network/firebase_dabase.dart';
import 'package:chat_app/utils/helper/helper_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white)
      );

      if(FirebaseDatabase.auth.currentUser !=null){
         kPrint("User : ${FirebaseDatabase.auth.currentUser}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreens()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
      }


    });
  }

  @override
  Widget build(BuildContext context) {
    mqSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: mqSize.width * .25,
            top: mqSize.width * .30,
            width: mqSize.width * .5,
            child: Image.asset(
              KAssetsImage.messageIcon,
            ),
          ),
          Positioned(
            bottom: mqSize.width * .15,
            width: mqSize.width,
            child: const Text(
              "Welcome to our chat app ❤️",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 18,
                color: AppColors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
