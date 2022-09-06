import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../data_base.dart';
import '../helperfunction.dart';
class Register_Screen extends StatefulWidget {
  const Register_Screen({Key? key}) : super(key: key);

  @override
  State<Register_Screen> createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  TextEditingController emailcontroller= TextEditingController();
  TextEditingController passwordcontroller= TextEditingController();
  TextEditingController usernamecontroller= TextEditingController();

  DataBase databaseMethods= DataBase();
  final _formKey =
  GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  var _loading= false;


  moveToHome(BuildContext context) async {
  signUp(emailcontroller.text ,passwordcontroller.text );
  if (_formKey.currentState!.validate()) {
  setState(() {
        _loading = true;
      });
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _loading== true? Container(
            child:  Center(
              child: CircularProgressIndicator()
            ),
          ):
          SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/login.png', fit: BoxFit.contain,),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Welcome', style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      fontStyle: FontStyle.italic
                  ),),

                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: TextFormField(
                      controller: usernamecontroller,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter Username',
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),

                        ),
                        validator: MultiValidator(
                            [
                              RequiredValidator(errorText: 'Required *'),
                            ]
                        )
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: TextFormField(
                      controller: emailcontroller,

                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter Email',
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail),

                        ),
                        validator: MultiValidator(
                            [
                              RequiredValidator(errorText: 'Required *'),
                              EmailValidator(errorText: 'Not a valid Email')
                            ]
                        )
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: TextFormField(
                      controller: passwordcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required *';
                        }
                        else if (value.length < 6) {
                          return 'Password length should be Atleaset six';
                        }
                      },
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.vpn_key),
                      ),
                    ),
                  ),
                  SizedBox(
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
                            borderRadius: BorderRadius.circular(10)

                        ),

                        child:  Text('Sign Up',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17
                          ),)
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    height: 20,
                  ),


                ],
              ),
            ),
          )
        ],
      ),

    );
  }
  void signUp(String email, String password) async {

    setState(() {
      _loading = false;
    });

    try {
      _auth.createUserWithEmailAndPassword(
          email: emailcontroller.text,
          password: passwordcontroller.text
      ).then((value) =>
          setState(() {
            _loading = false;
            print("ok");

            Map<String , String > userInfoMap={
                'name' : usernamecontroller.text,
              'email' : emailcontroller.text,
            };

            HelperFunctions.saveUserNameInSharedPrefernce(usernamecontroller.text);
            HelperFunctions.saveUserEmailSharedPrefernce(emailcontroller.text);
            databaseMethods.uploadUserInfo(userInfoMap);
            HelperFunctions.saveUserLoggedInSharedPrefernce(true);
            Navigator.pushNamed(context, 'home');
          })

      ).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });;

    } on FirebaseAuthException catch (e) {
      setState(() {
        _loading = false;
      });
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    }


  }
}
