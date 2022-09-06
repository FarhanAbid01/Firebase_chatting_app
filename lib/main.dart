
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/chat_room.dart';
import 'Screens/login_screen.dart';
import 'Screens/registration_screen.dart';
import 'Screens/search.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedIn = false;
  @override
  void initState() {
    getLoggedInstate();
    super.initState();
  }

  getLoggedInstate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isUserLoggedIn = prefs.getBool('ISLOGGEDIN')!;
      print(isUserLoggedIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
        primaryColor: Colors.blue,
      ),
      home: isUserLoggedIn == true ? Chat_Room() : Login_Screen(),
      routes: {
        'home': (context) => Login_Screen(),
        'register': (context) => Register_Screen(),
        'chat': (context) => Chat_Room(),
        'search': (conext) => Search_Screen(),
      },
    );
  }
}
