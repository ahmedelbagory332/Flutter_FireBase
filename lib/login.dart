import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Utils.dart';
import '../fireBaseHelper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  String email = "";
  String password = "";
  late BuildContext dialogContext;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(
              right: 35,
              left: 35,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 35,
                        top: MediaQuery.of(context).size.height * 0.1,
                        bottom: MediaQuery.of(context).size.height * 0.2),
                    child: const Center(
                      child:  Text(
                        "Login Screen",
                        style: TextStyle(color: Colors.indigoAccent, fontSize: 33),
                      ),
                    ),
                  ),
                  TextField(
                    onChanged: (text) {
                      email = text;
                    },
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    onChanged: (text) {
                      password = text;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xff4c505b),
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xff4c505b),
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            if(email.isEmpty || password.isEmpty ){
                              buildShowSnackBar(context, "please check your info.");

                            }else {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    dialogContext = context;
                                    return  const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                              );
                              FireBaseHelper()
                                  .signIn(email: email.trim().toString(), password: password.trim().toString())
                                  .then((result) {
                                if(result == "Welcome"){
                                  Navigator.pushReplacementNamed(context, 'home_Page');
                                  buildShowSnackBar(context,result+" "+ FirebaseAuth.instance.currentUser!.displayName);
                                } else if (result != null) {
                                  buildShowSnackBar(context, result);
                                  Navigator.pop(dialogContext);
                                }
                                else {
                                  Navigator.pop(dialogContext);
                                  buildShowSnackBar(context, "Try again.");
                                }
                              }).catchError((e) {
                                Navigator.pop(dialogContext);
                                buildShowSnackBar(context, e.toString());
                              });
                            }
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, 'register');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              color: Color(0xff4c505b),
                            ),
                          ),
                        ),
                      ]),
                ]),
          ),
        ),
      ),
    );
  }
}