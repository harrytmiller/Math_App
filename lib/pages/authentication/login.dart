import 'package:flutter/material.dart';
import 'auth.dart'; 
import 'register.dart'; 
import '../question/question.dart';
import '../intro.dart'; 



class LoginPage extends StatefulWidget {
  final AuthService auth;

  LoginPage({Key? key, AuthService? auth})
      : auth = auth ?? AuthService(),
        super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final Color darkGreyColor = Colors.grey[800]!;



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IntroPage()),
        );
        return false; 
      },



      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, 
          title: Text(
            'Login',
            style: TextStyle(fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          toolbarHeight: 70.0,
        ),



        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[



                TextField(
                  controller: emailController,
                  cursorColor: darkGreyColor,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: darkGreyColor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkGreyColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkGreyColor),
                    ),
                  ),
                ),



                TextField(
                  controller: passwordController,
                  obscureText: true,
                  cursorColor: darkGreyColor,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: darkGreyColor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkGreyColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkGreyColor),
                    ),
                  ),
                ),



                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, 
                  ),
                  onPressed: () async {
                    dynamic result = await widget.auth.signInWithEmail(
                    emailController.text,
                    passwordController.text,
                    );
                    if (result != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Question()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Incorrect email or password')),
                      );
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.black), 
                  ),
                ),



                SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text(
                     "Don't have an account? Register",
                    style: TextStyle(color: Colors.blue), 
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
