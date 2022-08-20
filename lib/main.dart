import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/items_screen.dart';
import 'package:flutter_firebase/splash_screen.dart';
import '/login.dart';
import '/register.dart';
import 'home_screen.dart';


void main()  async{
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

  @override
  Widget build(BuildContext context) {

    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>  const SplashScreen(),
        'login': (context) =>  const Login(),
        'register': (context) => const Register(),
        'home_Page': (context) => const HomeScreen(),
        'items': (context) => const ItemsScreen(),
      },

    );
  }


}