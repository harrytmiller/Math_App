import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutPage extends StatelessWidget {
  final Future<bool> Function(Uri)? canLaunchUrlOverride;
  final Future<bool> Function(Uri, {LaunchMode? mode})? launchUrlOverride;


  const AboutPage({
    Key? key, 
    this.canLaunchUrlOverride,
    this.launchUrlOverride
  }) : super(key: key);


  void launchEmailForTest() {
    _launchEmail();
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'up2120303@myport.ac.uk',
    );
    
    final canLaunchFunction = canLaunchUrlOverride ?? canLaunchUrl;
    final launchFunction = launchUrlOverride ?? launchUrl;
    
    if (await canLaunchFunction(emailUri)) {
      await launchFunction(emailUri, mode: LaunchMode.platformDefault);
    } else {
      throw 'Could not launch $emailUri';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        toolbarHeight: 70.0,
      ),


      body: Center(
        child: Container(
          width: 675,
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.lightBlue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [



                Text(
                  'About Us:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 8),
                Text(
                  'Welcome to Math Club, the ultimate maths companion designed specifically for students in years 1-6. Math Club Is a maths app designed to be used for a short time every day. The design enforces the little and often method of revision. It is self-paced and mostly intended for children to use alone. This app can help improve confidence answering questions and reinforce mathematical principles, helping children develop strong foundational skills.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 24),



                Text(
                  'Email:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: _launchEmail,
                  child: Text(
                    'up2120303@myport.ac.uk',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 0, 122, 222),
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 24),



                Text(
                  'Phone Number:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 8),
                Text(
                  '+44 1234 567890',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 24),



                Text(
                  'Postal Address:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 8),
                Text(
                  '123 Tech Street, Innovation Park, London, UK, SW1A 1AA',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}