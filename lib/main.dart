import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'SignupPage.dart';
import 'SigninPage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Firebase Auth Demo',
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        primarySwatch: Colors.blue
      ),
      home: SigninPage(),
      routes: <String,WidgetBuilder>{
        '/sign-up': (BuildContext context) => SignupPage(),
        '/home': (BuildContext context) => HomePage()
      },
    );
  }
}