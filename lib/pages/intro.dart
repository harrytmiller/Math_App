import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/Login');
        },


        child: Center(
          child: Container(
            width: 675,
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: const [


                Text(
                  'Welcome to Math Club',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                
                Text(
                  'Click anywhere to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
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