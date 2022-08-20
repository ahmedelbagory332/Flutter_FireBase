import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';



class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2),(){
      if(FirebaseAuth.instance.currentUser != null){
        Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => const HomeScreen()));
      }else{
        Navigator.pushReplacementNamed(context, 'login');
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Splash Screen',
                  style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                      color: Colors.black87
                  ),
                ),
                CircularProgressIndicator()
              ],
            ),
          )
      ),
    );
  }
}