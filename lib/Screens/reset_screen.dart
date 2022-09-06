
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'login_screen.dart';

class Reset_screen extends StatefulWidget {
  const Reset_screen({Key? key}) : super(key: key);

  @override
  State<Reset_screen> createState() => _Reset_screenState();
}

class _Reset_screenState extends State<Reset_screen> {
  TextEditingController emailcontroller= TextEditingController();
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  var _loading= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
            children: [
        _loading==true? Container(
        child:  Center(
            child:CircularProgressIndicator()
    ),
    ):
    SingleChildScrollView(
    child: Form(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    key: _formKey,
    child: Column(
    children: [
    Image.asset('assets/welcome.png', fit: BoxFit.contain,),
    SizedBox(
    height: 10,
    ),
    Text('Welcome Back',style: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 30,
    fontStyle: FontStyle.italic
    ),),
    SizedBox(
    height: 20,
    ),

    Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
      SizedBox(
        height: 10,
      ),
      InkWell(
        onTap: (){
          reset(emailcontroller.text);
    },
        child: Container(
            width:90,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular( 10)

            ),
            child:Text('Reset',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17
              ),)
        ),
      ),
    ]
    )
    )
    )
    ]
    )
    );
  }
  void reset(String email) async {
    setState(() {
      _loading= true;

    });

    try {
      _auth.sendPasswordResetEmail(
        email: emailcontroller.text,
      ).then((value) =>
          setState(() {
            print("ok");
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login_Screen()));
          })

      );
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

