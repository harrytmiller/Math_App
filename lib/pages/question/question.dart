import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../authentication/auth.dart';
import 'dart:async'; 
import 'dart:math'; 
import 'questiongen.dart';



class Question extends StatefulWidget {
  final AuthService? authService;
  final Stream? testUserDataStream;
  final dynamic testUser;
  final int? testCorrectAnswer;

  Question({
    this.authService,
    this.testUserDataStream,
    this.testUser,
    this.testCorrectAnswer,
  });

  @override
  _QuestionState createState() => _QuestionState();
}



class _QuestionState extends State<Question> {
  final AuthService _auth = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId;
  Timer? _timer;
  int learnage = 0;
  String questionText = '';
  List<int> answerOptions = [];
  int correctAnswer = -1;
  int selectedAnswer = -1;
  bool showFeedback = false;
  bool answerCorrect = false;
  String imagePath = '';
    int correctCount = 0;
  int daysInRowCount = 0;
  int highestDaysInRow = 0;
  DateTime? lastResetTimestamp;




  @override
  void initState() {
    super.initState();
    
    if (widget.testUser != null) {
      _updateLearnageFromUser(widget.testUser);

      
      if (widget.testCorrectAnswer != null) {
        correctAnswer = widget.testCorrectAnswer!;
      }
      
      if (widget.testUser.correctCount != null) {
        correctCount = widget.testUser.correctCount;
      }
      
      if (widget.testUser.daysInRow != null) {
        daysInRowCount = widget.testUser.daysInRow;
      }
      
      if (widget.testUser.lastResetTimestamp != null) {
        lastResetTimestamp = widget.testUser.lastResetTimestamp;
      }
      
      imagePath = 'assets/pics/1.jpg';
      
      if (questionText.isEmpty || answerOptions.isEmpty || correctAnswer == -1) {
        var questionData = getRandomQuestionAndAnswers(learnage);
        questionText = questionData['question'];
        answerOptions = questionData['answers'];
        correctAnswer = questionData['correctAnswer'];
      }
    } else {
      getUserId(); 
    }
  }




  void getUserId() async {
    userId = await _auth.getCurrentUserId();
    if (userId != null) {
      await fetchDataFromFirestore(); 
      updateQuestion(); 
    } 
  }




  Future<void> fetchDataFromFirestore() async {
    try {
      if (userId != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          setState(() {
            daysInRowCount = userDoc['daysInRow'] ?? 0; 
            correctCount = userDoc['correctCount'] ?? 0; 
            lastResetTimestamp = userDoc['lastResetTimestamp']?.toDate(); 
            highestDaysInRow = userDoc['highestDaysInRow'] ?? 0; 
            
            int schoolYear = userDoc['schoolYear'] ?? 0; 
            bool advancedMode = userDoc['advancedMode'] ?? false; 
            learnage = schoolYear + (advancedMode ? 1 : 0);
          });
          checkForDailyReset(); 
        }
      }
    } catch (e) {
      print('Error fetching data from Firestore');
    }
  }





  void updateFirestore() async {
    try {
      if (userId != null) {
        if (daysInRowCount > highestDaysInRow) {
          highestDaysInRow = daysInRowCount;
        }

        await _firestore.collection('users').doc(userId).update({
          'daysInRow': daysInRowCount,
          'correctCount': correctCount,
          'highestDaysInRow': highestDaysInRow,
          'lastResetTimestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating Firestore');
    }
  }






  void recalculateLearnage() {
    if (widget.testUser != null) {
      _updateLearnageFromUser(widget.testUser);
      return;
    }
    
    if (userId != null) {
      _firestore.collection('users').doc(userId).get().then((userDoc) {
        if (userDoc.exists) {
          setState(() {
            int schoolYear = userDoc['schoolYear'] ?? 0;
            bool advancedMode = userDoc['advancedMode'] ?? false;
            learnage = schoolYear + (advancedMode ? 1 : 0);
          });
        }
      }).catchError((e) {
        print('Error recalculating learnage');
      });
    }
  }





  void onSelect(String? page) async {
    final authService = widget.authService ?? _auth;

    if (page == 'logout') {
      await authService.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/Login');
      }
    } else if (page != null) {
      if (mounted) {
        Navigator.pushNamed(context, page);
      }
    }
  }





  void updateQuestion() {
    recalculateLearnage(); 
    var questionData = getRandomQuestionAndAnswers(learnage); 
    setState(() {
      questionText = questionData['question'];
      answerOptions = questionData['answers'];
      correctAnswer = questionData['correctAnswer'];
      selectedAnswer = -1; 
      showFeedback = false; 
      imagePath = getRandomImagePath(); 
    });
  }






  String getRandomImagePath() {
    final random = Random();
    int randomImageIndex = random.nextInt(56) + 1; 
    return 'assets/pics/$randomImageIndex.jpg'; 
  }






  void onAnswerSelected(int answer) async {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      updateQuestion();
      return;
    }






    setState(() {
      selectedAnswer = answer;
      answerCorrect = (selectedAnswer == correctAnswer);
      showFeedback = true;

      if (answerCorrect) {
        if (correctCount < 10) {
          correctCount += 1;
          
          if (correctCount == 10) {
            daysInRowCount += 1;
          }
        }
      }

      if (widget.testUser == null) {
        updateFirestore();
      }
    });

    _timer = Timer(Duration(seconds: 3), () {
      updateQuestion();
    });
  }







  void checkForDailyReset() {
    DateTime now = DateTime.now();
    DateTime resetTimeToday = DateTime(now.year, now.month, now.day, 00, 00);

    if (now.isAfter(resetTimeToday)) {
      resetTimeToday = resetTimeToday.add(Duration(days: 1));
    }

    if (lastResetTimestamp == null || lastResetTimestamp!.isBefore(resetTimeToday.subtract(Duration(days: 1)))) {
      resetCorrectCount();
    }
  }






  void resetCorrectCount() {
    DateTime now = DateTime.now();
    DateTime resetTimeToday = DateTime(now.year, now.month, now.day, 00, 00);
    
    bool shouldResetDaysInRow = lastResetTimestamp == null || lastResetTimestamp!.isBefore(resetTimeToday.subtract(Duration(days: 1)));
    
    setState(() {
      if (correctCount < 10 || shouldResetDaysInRow) {
        daysInRowCount = 0;
      }
      correctCount = 0;
    });
    updateFirestore();
  }





  Color getCorrectCountColor() {
    if (correctCount >= 10) {
      return const Color.fromARGB(255, 74, 218, 122); 
    } else if (correctCount >= 6) {
      return Colors.yellow; 
    } else if (correctCount >= 3) {
      return Colors.orange; 
    } else {
      return const Color.fromARGB(255, 218, 74, 74); 
    }
  }





  void _updateLearnageFromUser(dynamic user) {
    int schoolYear = user.schoolYear ?? 0;
    bool advancedMode = user.advancedMode ?? false;
    setState(() {
      learnage = schoolYear + (advancedMode ? 1 : 0);
    });
  }





  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Math Club',
            style: TextStyle(fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          toolbarHeight: 70.0,
          automaticallyImplyLeading: false,
          leading: Container(
            width: 180, 
            
            
            
            
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true, 
                dropdownColor: Colors.blue,
                menuMaxHeight: 300, 
                alignment: Alignment.centerLeft, 
                value: null,
                hint: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'Menu',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                onChanged: onSelect,
                iconSize: 0,
                items: <String>['/Menu', '/Profile', '/About Us', '/FAQ', 'logout']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: SizedBox(
                      width: 180, 
                      child: Text(
                        value == 'logout' ? 'Logout' : value.substring(1),
                        style: TextStyle(color: Colors.black),
                        overflow: TextOverflow.visible, 
                        softWrap: false, 
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),





        
        body: Center(
          child: SingleChildScrollView( 
            child: Container(
              width: 675,
              height: widget.testUser == null ? 550 : null,             
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 500,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      questionText,
                      style: TextStyle(fontSize: 24, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      
                      
                      
                      
                      
                      
                      Container(
                        width: 80,
                        height: 80,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: getCorrectCountColor(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '$correctCount/10',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Spacer(),
                    




                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                              ),
                              child: imagePath.isNotEmpty
                                  ? Image.asset(
                                      imagePath, 
                                      fit: BoxFit.cover, 
                                    )
                                  : Center(child: Text('No Image Available')), 
                            ),
                          ),
                        
                        
                          if (showFeedback)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.5),
                                child: Container(
                                  color: answerCorrect
                                      ? const Color.fromARGB(255, 74, 218, 122) 
                                      : const Color.fromARGB(255, 218, 74, 74), 
                                  child: Center(
                                    child: Text(
                                      answerCorrect ? 'Correct!' : 'Incorrect',
                                      style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Spacer(),







                      Container(
                        width: 80,
                        height: 80,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 74, 218, 122),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Days in',
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'a row: $daysInRowCount',
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                 
                 
                 
                 
                 
                 
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < answerOptions.length; i++)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22.0),
                            child: ElevatedButton(
                              onPressed: () {
                                onAnswerSelected(answerOptions[i]);
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(110, 80),
                                backgroundColor: selectedAnswer == -1
                                    ? Colors.lightBlue[100]
                                    : (answerOptions[i] == correctAnswer
                                        ? const Color.fromARGB(255, 74, 218, 122)
                                        : (selectedAnswer == answerOptions[i]
                                            ? const Color.fromARGB(255, 218, 74, 74)
                                            : Colors.lightBlue[100])),

                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                '${answerOptions[i]}',
                                style: TextStyle(fontSize: 24, color: Colors.black),
                              ),
                            ),
                          ),



                          
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}