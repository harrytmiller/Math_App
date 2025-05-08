import 'package:flutter/material.dart';
import 'auth.dart'; 
import 'login.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../question/question.dart';



class RegisterPage extends StatefulWidget {
  final AuthService? authService;

  RegisterPage({Key? key, this.authService}) : super(key: key);
  
  @override
  _RegisterPageState createState() => _RegisterPageState();
}




class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController schoolYearController = TextEditingController();
  late final AuthService _auth;

  final Color darkGreyColor = Colors.grey[800]!;
  final Color buttonTextColor = Colors.black;



  @override
  void initState() {
    super.initState();
    _auth = widget.authService ?? AuthService();
  }



  bool isUsernameValid(String username) {
    return username.length >= 4 && username.length <= 12;
  }



  bool isSchoolYearValid(String schoolYear) {
    final year = int.tryParse(schoolYear);
    return year != null && year >= 1 && year <= 6;
  }



  bool isSchoolYearWholeNumber(String schoolYear) {
  return double.tryParse(schoolYear) != null && 
         double.parse(schoolYear) == double.parse(schoolYear).toInt();
}



  Future<bool> isUsernameUnique(String username) async {
    if (widget.authService != null) {
      return await _auth.isUsernameUnique(username);
    }


    
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }



  bool doPasswordsMatch() {
    return passwordController.text == confirmPasswordController.text;
  }



  bool isPasswordValid(String password) {
    final RegExp passwordRegex = RegExp(r'^(?=.*[0-9])(?=.*[!@#\$&*~])(?=.*[a-z])(?=.*[A-Z]).{8,}$');
    return passwordRegex.hasMatch(password);
  }



bool isEmailValid(String email) {
  final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}



  Future<bool> isEmailUnique(String email) async {
    if (widget.authService != null) {
      return await _auth.isEmailUnique(email);
    }
    


    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isEmpty;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        title: Text('Register', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        toolbarHeight: 70.0,
        automaticallyImplyLeading: false, 
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
                controller: usernameController,
                cursorColor: darkGreyColor,
                decoration: InputDecoration(
                  labelText: 'Username (4-12 characters)',
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
                controller: schoolYearController,
                keyboardType: TextInputType.number,
                cursorColor: darkGreyColor,
                decoration: InputDecoration(
                  labelText: 'School Year (1-6)',
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


              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                cursorColor: darkGreyColor,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
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

                  if (!isUsernameValid(usernameController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Username must be 4-12 characters long')),
                    );
                    return;
                  }

                  if (double.tryParse(schoolYearController.text) != null && 
                      double.parse(schoolYearController.text) != double.parse(schoolYearController.text).roundToDouble()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('School Year must be a whole number')),
                    );
                    return;
                  }

                  if (!isSchoolYearValid(schoolYearController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('School Year must be between 1 and 6')),
                    );
                    return;
                  }

                  if (!isSchoolYearWholeNumber(schoolYearController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('School Year must be a whole number')),
                    );
                    return;
                  }

                  if (!isEmailValid(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid email address')),
                    );
                    return;
                  }

                  if (!isPasswordValid(passwordController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password must be at least 8 characters long, include a number, an uppercase letter, a lowercase letter, and a symbol',),
                        duration: Duration(seconds: 6),
                      ),
                    );
                    return;
                  }

                  if (!doPasswordsMatch()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Passwords do not match')),
                    );
                    return;
                  }

                  bool uniqueUsername = await isUsernameUnique(usernameController.text);
                  if (!uniqueUsername) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Username is already in use')),
                    );
                    return;
                  }

                  bool uniqueEmail = await isEmailUnique(emailController.text);
                  if (!uniqueEmail) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email is already in use')),
                    );
                    return;
                  }


                  try {
                    User? user = await _auth.registerWithEmail(
                      emailController.text.trim(),
                      passwordController.text,
                      usernameController.text,
                      int.parse(schoolYearController.text),
                    );

                    if (user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Question()), 
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error registering')),
                    );
                  }
                },

                child: Text(
                  'Register',
                  style: TextStyle(color: buttonTextColor),
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },




                child: Text(
                  "Already have an account? Login",
                  style: TextStyle(color: Colors.blue),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}