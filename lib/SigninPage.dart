import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({ Key? key }) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final _formKey=GlobalKey<FormState>();
  String email='';
  String password='';

  onChangedEmail(input) => setState(()=>email=input);
  onChangedPassword(input) => setState(()=>password=input);

  void checkAuthentication() async{
    _auth.authStateChanges().listen((user) {
      if(user!=null){
        navigateToHomePage();
      }
     });
  }

  void navigateToSignupPage(){
    Navigator.of(context).pushReplacementNamed("/sign-up");
  }

  void navigateToHomePage(){
    Navigator.of(context).pushReplacementNamed("/home");
  }

  showError(String errMsg){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title:Text('Error'),
        content: Text(errMsg),
        actions: [
          ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))
        ],
      );
    });
  }

  signin() async{
    final isValid=_formKey.currentState!.validate();
    if(isValid){
        try {
          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password
          );
          
          navigateToHomePage();

        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            showError('No user found for the email.');
          } else if (e.code == 'wrong-password') {
            showError('Wrong password provided for the user.');
          }
        }  
    }
  }


  resetPassword() async{
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Sign In')
      ),
      body:ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 30.0),
            child: const Image(
              image: AssetImage('assets/logo.png'),
              height:100.0,
              width:100.0
            )
          ),
          Container(
            width: 200,
            height:300,
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.blue,
            padding: EdgeInsets.all(12),
            child: Form(
              key:_formKey,
              child: Column(
                children: [
                  TextFormField(
                    cursorColor: Colors.white70,
                    style: const TextStyle(
                      color:Colors.white,
                      fontSize: 18
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color:Colors.white70
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Colors.white)
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Colors.white)
                      ),
                    ),
                    validator: (input){
                      if(input!=null && input.isEmpty)
                        return 'Provide an email';
                    },
                    onChanged: onChangedEmail,
                  ),
                  SizedBox(height:20),
                  TextFormField(
                    cursorColor: Colors.white70,
                    style: const TextStyle(
                      color:Colors.white,
                      fontSize: 18
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color:Colors.white70
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Colors.white)
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Colors.white)
                      ),
                    ),
                    validator: (input){
                      if(input!=null && input.isEmpty)
                        return 'Provide a password';
                      else if(input !=null && input.length<6)
                        return 'Password must be atleast 6 characters long';
                    },
                    onChanged: onChangedPassword,
                    obscureText: true,
                  ),
                  const Padding(padding: EdgeInsets.only(top:10)),
                  Row(
                    children: [
                      GestureDetector(
                        child:Text('Forgot Password?', style:TextStyle(color:Colors.white60)),
                        onTap: resetPassword,
                      ),                      
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top:30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: signin, 
                        child: Text('Login',
                          style:TextStyle(
                            fontSize: 20,
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 40,vertical: 12)),
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                      GestureDetector(
                        child: const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color:Colors.white70,
                            fontSize: 16
                          ),
                        ),
                        onTap: navigateToSignupPage,
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      )
      
    );
  }
}