
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chatting_app/Screens/reset_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_base.dart';
import '../helperfunction.dart';
import 'chat_room.dart';
import 'constants.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({Key? key}) : super(key: key);

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  DataBase databaseMethods =  DataBase();
  var _loading = false;
  final _auth = FirebaseAuth.instance;
  late QuerySnapshot snapshotUserInfo;
  var check = false;

  final _formKey = GlobalKey<FormState>();

  moveToHome(BuildContext context) {
    signIn(_emailcontroller.text, _passwordcontroller.text);
    if (_formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmailSharedPrefernce(_emailcontroller.text);
    }
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    //  Constants.myname= await HelperFunctions.getUserNameSharedPrefernce().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _loading == true
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/welcome.png',
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: TextFormField(
                              controller: _emailcontroller,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Enter Email',
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.mail),
                              ),
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Required *'),
                                EmailValidator(errorText: 'Not a valid Email')
                              ])),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: TextFormField(
                            controller: _passwordcontroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Required *';
                              } else if (value.length < 6) {
                                return 'Please Enter a Valid Password(Min .6 Characters)';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Enter Password',
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.vpn_key),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () => moveToHome(context),
                          child: Container(
                              width: 100,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                'Sign in',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'register');
                              },
                              child: const Text(
                                'SignUp',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Forgotten Password? ",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Reset_screen()));
                              },
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  void signIn(String email, String password) async {
    setState(() {
      _loading = true;
    });

    try {
      _auth
          .signInWithEmailAndPassword(
              email: _emailcontroller.text, password: _passwordcontroller.text)
          .then((value) => databaseMethods
                  .getUserByEmail(_emailcontroller.text)
                  .then((value) async {
                snapshotUserInfo = value;
                HelperFunctions.saveUserLoggedInSharedPrefernce(true);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                try {
                  prefs.setString(
                      "USERNAMEKEY", snapshotUserInfo.docs[0]['name']);

                  Constants.myname = prefs.get("USERNAMEKEY").toString();
                  prefs.setBool("ISLOGGEDIN", true);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Chat_Room()));
                } catch (e) {
                  print("PREF = $e");
                }
                setState(() {
                  _loading = false;
                });
              }).catchError((e) {
                setState(() {
                  _loading = false;
                });
                Fluttertoast.showToast(msg: "get name" + e!.message);
              }))
          .catchError((e) {
        setState(() {
          _loading = false;
        });
        Fluttertoast.showToast(msg: "sign in" + e!.message);
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
      });
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
