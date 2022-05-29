import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  late User user;
  bool isSignedIn=false;

  navigateToSigninPage(){
    Navigator.of(context).pushReplacementNamed("/");
  }

  checkAuthentication() async{
    _auth.authStateChanges().listen((tempUser) {
      if(tempUser==null)
      {
        navigateToSigninPage();
      }
     });
  }

  getUser() async{
    User u= _auth.currentUser!;
    // await u.reload();  //? otherwise, displayName will be null
    // u=_auth.currentUser!;

    setState(() {
      user=u;
      isSignedIn=true;
    });
  }


  signOut() async{
    await _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body:Center(
        child: !isSignedIn 
        ? CircularProgressIndicator() 
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding:const EdgeInsets.all(20),
              child:const Image(
                image:AssetImage("assets/logo.png"),
                height:100.0,
                width:100.0
              )
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Hello! You're logged in as ${user.email}",
                style:const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: signOut, 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Logout',
                      style:TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_outlined),
                  ],
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 40,vertical: 12)),
                  backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
                ),
              ),
            ),
          ],

        ) 
      )
    );
  }
}