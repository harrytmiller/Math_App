import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';


class QAItem extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color backgroundColor;
  final Color titleColor;
  final Color childrenColor;


  const QAItem({
    Key? key,
    required this.title,
    required this.children,
    this.backgroundColor = const Color.fromARGB(255, 146, 221, 255),
    this.titleColor = Colors.black,
    this.childrenColor = Colors.black,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      children: children
          .map((child) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: childrenColor,
                      fontSize: 16.0,
                    ),
                    child: child,
                  ),
                ),
              ))
          .toList(),
      backgroundColor: backgroundColor,
    );
  }
}


class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  _FAQPageState createState() => _FAQPageState();
}



class _FAQPageState extends State<FAQPage> {
  late TextEditingController _searchController;
  List<QAItem> _allQuestions = [];
  List<QAItem> _filteredQuestions = [];



  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);

    _allQuestions = [


      QAItem(
        title: "How do I answer questions?",
        children: [
          RichText(
            text: TextSpan(
              text: "To answer a question, first be on the homepage/Math club. Read the question above the image and the answers below the image. Press the answer you think is correct and acknowledge feedback. If you want to skip the timer for the next question to arrive, press any of the answers again.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "How does daily reset work?",
        children: [
          RichText(
            text: TextSpan(
              text: "Every day at 12am, the score /10 will be set to 0. If the score doesn't equal 10 when the reset occurs, or if a reset didn’t occur the previous day, then ‘days in a row’ will also be reset along with the score. If the score reaches 10/10, then days in a row will increase by 1.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "How does score and days in a row work?",
        children: [
          RichText(
            text: TextSpan(
              text: "From the homepage/Math Club, you can see a score /10. The score resets at 12am every day. If your score does not reach 10/10 by the end of the day, or if you don’t login on a day, then your current ‘days in a row’ will also be reset. Getting a score of 10/10 will cause days in a row to increase by 1. View your 'highest days in a row' from the ‘Profile’ page.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "How can I monitor my daily score?",
        children: [
          RichText(
            text: TextSpan(
              text: "From the homepage/Math Club, you can see a score /10, which resets at 12am every day. If your score does not reach 10/10 correct answers by the end of the day, or if you don’t login, then your current ‘days in a row’ will also be reset. Getting a score of 10/10 will cause days in a row to increase by 1.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "How can I monitor days in a row?",
        children: [
          RichText(
            text: TextSpan(
              text: "From the homepage/Math Club or Profile page, you can see ‘days in a row’ and score /10. The score resets at 12am every day. If your score does not reach 10/10 correct answers by the end of the day, then your current ‘days in a row’ will also be reset. Getting a score of 10/10 will cause days in a row to increase by 1.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "How can I monitor highest days in a row?",
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              children: [
                TextSpan(text: "From the homepage/Math Club, click the ‘menu’ and press ‘"),
                TextSpan(
                  text: "Profile",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.pushNamed(context, '/Profile');
                  },
                ),
                TextSpan(text: "'. View your 'days in a row' and 'highest days in a row' there."),
              ],
            ),
          ),
        ],
      ),



      QAItem(
        title: "How do I navigate between pages?",
        children: [
          RichText(
            text: TextSpan(
              text: "From the homepage/Math Club, click the ‘menu’ in the top left corner and select the page you want. To return to the homepage, press the back arrow in the top left corner.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "How can I log out?",
        children: [
          RichText(
            text: TextSpan(
              text: "From the homepage/Math Club, click the ‘menu’ in the top left corner and select ‘Log Out’.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "How can I view my profile details?",
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              children: [
                TextSpan(text: "From the homepage/Math Club, click the ‘menu’ and press ‘"),
                TextSpan(
                  text: "Profile",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.pushNamed(context, '/Profile');
                  },
                ),
                TextSpan(text: "'. View your details there."),
              ],
            ),
          ),
        ],
      ),



      QAItem(
        title: "How can I change my profile details?",
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              children: [
                TextSpan(text: "From the homepage/Math Club, click the ‘menu’ and press ‘"),
                TextSpan(
                  text: "Profile",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.pushNamed(context, '/Profile');
                  },
                ),
                TextSpan(text: "'. From the Profile page press ‘update profile’."),
              ],
            ),
          ),
        ],
      ),



      QAItem(
        title: "How does advanced mode work?",
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              children: [
                TextSpan(text: "From the homepage/Math Club, click the ‘menu’ and press ‘"),
                TextSpan(
                  text: "Profile",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.pushNamed(context, '/Profile');
                  },
                ),
                TextSpan(text: "'. Activate 'Advanced Mode' in the settings."),
              ],
            ),
          ),
        ],
      ),




      QAItem(
        title: "How can I change my password?",
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              children: [
                TextSpan(text: "From the homepage/Math Club, click the ‘menu’ and press ‘"),
                TextSpan(
                  text: "Profile",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.pushNamed(context, '/Profile');
                  },
                ),
                TextSpan(text: "'. From there press ‘Change Password’ and follow the prompts."),
              ],
            ),
          ),
        ],
      ),



      QAItem(
        title: "How can I contact the people behind this app?",
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              children: [
                TextSpan(text: "From the homepage/Math Club, click the ‘menu’ and press ‘"),
                TextSpan(
                  text: "About Us",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.pushNamed(context, '/About Us');
                  },
                ),
                TextSpan(text: "'. Find our contact details there."),
              ],
            ),
          ),
        ],
      ),



      QAItem(
        title: "Where can I find information about this app?",
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              children: [
                TextSpan(text: "For information about Math Club, visit the FAQ or "),
                TextSpan(
                  text: "About Us",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.pushNamed(context, '/About Us');
                  },
                ),
                TextSpan(text: " page."),
              ],
            ),
          ),
        ],
      ),



      QAItem(
        title: "What is the purpose of math club?",
        children: [
          RichText(
            text: TextSpan(
              text: "This app provides engaging age-specific questions based on the national curriculum.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),
      QAItem(
        title: "What are the benefits of this app?",
        children: [
          RichText(
            text: TextSpan(
              text: "This app can be used at home or at school and provides age-specific questions based on the national curriculum.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "Can children use the app without adult supervision?",
        children: [
          RichText(
            text: TextSpan(
              text: "Yes, the app is designed to be child-friendly and safe to use independently.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "Can the app be used in classrooms?",
        children: [
          RichText(
            text: TextSpan(
              text: "Yes, the app is designed to be used both at home and in the classroom, as permitted by the teacher.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "Is there a cost to use the app?",
        children: [
          RichText(
            text: TextSpan(
              text: "No, this app is free to use.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "Is the app suitable for all children?",
        children: [
          RichText(
            text: TextSpan(
              text: "The app is suitable for children aged 5 and over, covering the primary maths curriculum from Year 1 to Year 6.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "How are questions generated?",
        children: [
          RichText(
            text: TextSpan(
              text: "A random number between 0-1 determines which kind of question is called (+,-,x,÷,worded). Two numbers are generated to be used in the question, these two numbers are random within their range and their range is dependent on the user's learning age (school year + advanced mode). Note: worded questions are generated differently but do scale with difficulty as age increases.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),



      QAItem(
        title: "How is privacy protected on the app?",
        children: [
          RichText(
            text: TextSpan(
              text: "The app complies with all relevant data protection regulations.",
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            )
          )
        ],
      ),
    ];


    _filteredQuestions = List.from(_allQuestions);
  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredQuestions = _allQuestions
          .where((qaItem) => qaItem.title.toLowerCase().contains(query))
          .toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(



      appBar: AppBar(
        title: Text(
          'Frequently Asked Questions',
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        toolbarHeight: 70,
      ),



      body: Column(
        children: [



          Container(
            color: Colors.blue[700],
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                

                ElevatedButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    minimumSize: const Size(0, 50),
                  ),
                  child: const Text(
                    'Clear',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),



          Expanded(
            child: ListView.builder(
              itemCount: _filteredQuestions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _filteredQuestions[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}