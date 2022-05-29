import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({ Key? key }) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final _formKey=GlobalKey<FormState>();
  String email='';
  String password='';
  String name='';

  onChangedEmail(input) => setState(()=>email=input);
  onChangedPassword(input) => setState(()=>password=input);
  onChangedName(input) => setState(()=>name=input);

  void navigateToSigninPage(){
    Navigator.of(context).pushReplacementNamed("/");
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

  void signup() async{
    final isValid=_formKey.currentState!.validate();

    if(isValid){
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
        );
        User user=userCredential.user!;
        user.updateDisplayName(name);
        navigateToSigninPage();

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for the email.');
        }
      } catch (e) {
        showError(e.toString());
      }

    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Sign Up')
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
            height:340,
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
                      labelText: 'Name',
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
                        return 'Provide a name';
                    },
                    onChanged: onChangedName,
                  ),
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
                  Padding(padding: EdgeInsets.only(top:30)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: signup, 
                          child: Text('Sign Up',
                            style:TextStyle(
                              fontSize: 20,
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 30,vertical: 12)),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                          ),
                        ),
                        GestureDetector(
                          child: const Text(
                            "Already have an account?",
                            style: TextStyle(
                              color:Colors.white70,
                              fontSize: 16
                            ),
                          ),
                          onTap: navigateToSigninPage,
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