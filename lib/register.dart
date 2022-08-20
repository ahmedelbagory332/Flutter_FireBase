import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Utils.dart';
import '../fireBaseHelper.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  String email = "";
  String name = "";
  String password = "";
  late BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(right: 35, left: 35),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.only(
                    left: 35,
                    top: 10,
                    bottom: MediaQuery.of(context).size.height * 0.2),
                child: const Center(
                  child:   Text(
                    "Create Account",
                    style: TextStyle(color: Colors.indigoAccent, fontSize: 33),
                  ),
                ),
              ),
              TextField(
                onChanged: (text) {
                  name = text;
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "Name",
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                onChanged: (text) {
                  email = text;
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "Email",
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
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xff4c505b),
                  child: IconButton(
                    onPressed: () {

                      if(email.isEmpty || password.isEmpty || name.isEmpty){
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
                            .signUp(email: email.trim().toString(), password: password.trim().toString())
                            .then((result) {
                          if(result == "true"){
                            Navigator.pushReplacementNamed(
                                context, 'login');
                            FirebaseAuth.instance.currentUser!.updateDisplayName(name.trim().toString());
                            buildShowSnackBar(context, "Now you can login");
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
              ]),
              const SizedBox(
                height: 40,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'login');
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 18,
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