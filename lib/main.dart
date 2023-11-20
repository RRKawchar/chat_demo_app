import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/splash_screen/splash_screen.dart';
import 'package:chat_app/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAKZndG2CBr7E100Xbso69ViBhVv4JI0II',
      appId: '1:820412691807:android:67576dee11465d0195f2ea',
      messagingSenderId: '820412691807',
      projectId: 'zoom-clone-c8045',
    ),
  );
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: KThemeData.lightTheme,
        darkTheme: KThemeData.darkTheme,
        // theme: ThemeData(
        //     appBarTheme: const AppBarTheme(
        //   iconTheme: IconThemeData(color: Colors.black),
        //   backgroundColor: Colors.lightBlueAccent,
        //   elevation: 1,
        //   centerTitle: true,
        //   titleTextStyle: TextStyle(
        //     fontSize: 20,
        //     fontWeight: FontWeight.normal,
        //     color: Colors.black,
        //   ),
        // )),
        home: const SplashScreen());
  }
}
