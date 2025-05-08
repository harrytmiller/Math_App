import 'dart:math';

Map<String, dynamic> getRandomQuestionAndAnswers(int learnage) {
  Random random = Random();
  String question;
  int correctAnswer;
  List<int> answerOptions = [];



  if (learnage == 1) {
    double randomNumber1 = random.nextDouble();
    int result1, result3;
    String result2;


    if (randomNumber1 < 0.4) {
      result2 = "-";
      result1 = random.nextInt(10) + 1;
      int upperLimit = min(result1, 10);
      result3 = random.nextInt(upperLimit) + 1;
      correctAnswer = result1 - result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.8) {
      result2 = "+";
      result1 = random.nextInt(10) + 1;
      result3 = random.nextInt(10) + 1;
      correctAnswer = result1 + result3;
      question = "$result1 $result2 $result3";

    } else {
      int wordedQuestion = random.nextInt(25);


      switch (wordedQuestion) {
        case 0:
          question = "Select the missing number: 1, 2, 3, _, 5";
          correctAnswer = 4;
          break;
        case 1:
          question = "Select the missing number: 3, 4, _, 6, 7";
          correctAnswer = 5;
          break;
        case 2:
          question = "How many sides does a square have?";
          correctAnswer = 4;
          break;
        case 3:
          question = "How many sides does a triangle have?";
          correctAnswer = 3;
          break;
        case 4:
          question = "How many tens are in 20?";
          correctAnswer = 2;
          break;
        case 5:
          question = "Which number has 2 tens and 3 ones?";
          correctAnswer = 23;
          break;
        case 6:
          question = "What is the missing number: 9 = ? + 5";
          correctAnswer = 4;
          break;
        case 7:
          question = "What is the total of 2, 3 and 4?";
          correctAnswer = 9;
          break;
        case 8:
          question = "What is 6 more than 3?";
          correctAnswer = 9;
          break;
        case 9:
          question = "Sam has 3 pens. Sam loses a pen. How many pens does Sam have left?";
          correctAnswer = 2;
          break;
        case 10:
          question = "What number is 3 more than 5?";
          correctAnswer = 8;
          break;
        case 11:
          question = "What number is 7 less than 9?";
          correctAnswer = 2;
          break;
        case 12:
          question = "What number is 7 more than 20?";
          correctAnswer = 27;
          break;
        case 13:
          question = "Which number is added to 14 to make 20?";
          correctAnswer = 6;
          break;
        case 14:
          question = "What is the next number in this sequence?  2, 4, 6, 8, __";
          correctAnswer = 10;
          break;
        case 15:
          question = " How many sides does a rectangle have?";
          correctAnswer = 4;
          break;
        case 16:
          question = "What number has 1 ten and 7 ones?";
          correctAnswer = 17;
          break;
        case 17:
          question = "What is 5 more than 3?";
          correctAnswer = 8;
          break;
        case 18:
          question = "Select the missing number 5, 6, 7, _, 9";
          correctAnswer = 8;
          break;
        case 19:
          question = "Claire and Zoe have 4 sweets each. How many sweets do they have altogether?";
          correctAnswer = 8;
          break;
        case 20:
          question = "What is the missing number: ? - 3 = 2";
          correctAnswer = 5;
          break;
        case 21:
          question = "How many must be added to 9 to get 16?";
          correctAnswer = 7;
          break;
        case 22:
          question = "Sue buys 10 bananas. She eats 2 of them. How many are left?";
          correctAnswer = 8;
          break;
        case 23:
          question = "What is half of 12?";
          correctAnswer = 6;
          break;
        case 24:
          question = "Which number is twenty-seven?";
          correctAnswer = 27;
        default:
          question = "";
          correctAnswer = 0;
      }
    }


    answerOptions.add(correctAnswer);

    while (answerOptions.length < 3) {
      int offset = random.nextInt(13) - 6;
      int incorrectAnswer = correctAnswer + offset;

      if (incorrectAnswer != correctAnswer && incorrectAnswer > 0 && !answerOptions.contains(incorrectAnswer)) {
        answerOptions.add(incorrectAnswer);
      }
    }
    answerOptions.shuffle();
  } 





  else if (learnage == 2) {
    double randomNumber1 = random.nextDouble();
    int result1, result3, result4 ;
    String result2;


    if (randomNumber1 < 0.20) {
      result2 = "-";
      result1 = random.nextInt(100) + 1;
      int upperLimit = min(result1, 20);
      result3 = random.nextInt(upperLimit) + 1;
      correctAnswer = result1 - result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.40) {
      result2 = "x";
      result1 = random.nextInt(5) + 1; 
      result3 = random.nextInt(10) + 1;
      correctAnswer = result1 * result3;
      question = "$result1 $result2 $result3";


    } else if (randomNumber1 < 0.55) {
      result2 = "+";
      result1 = random.nextInt(100) + 1; 
      result3 = random.nextInt(20) + 1;
      correctAnswer = result1 + result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.60) {
      result2 = "+";
      result1 = random.nextInt(10) + 1; 
      result3 = random.nextInt(10) + 1;
      result4 = random.nextInt(10) + 1;
      correctAnswer = result1 + result3 + result4;
      question = "$result1 $result2 $result3 $result2 $result4";

} else if (randomNumber1 < 0.80) {
    result1 = random.nextInt(5) + 1; 
    correctAnswer = random.nextInt(10) + 1;
    result3 = result1 * correctAnswer; 
    result2 = "÷"; 
    question = "$result3 $result2 $result1";

    } else {
 int wordedQuestion = random.nextInt(25);

      
      switch (wordedQuestion) {
        case 0:
          question = "How many sides does a pentagon have?";
          correctAnswer = 5;
          break;
        case 1:
          question = "How many sides does a hexagon have?";
          correctAnswer = 6;
          break;
        case 2:
          question = "How many days in 1 week?";
          correctAnswer = 7;
          break;
        case 3:
          question = "Which number is missing: 10 + ? = 100";
          correctAnswer = 90;
          break;
        case 4:
          question = "Which number is missing: 17 + ? = 20";
          correctAnswer = 3;
          break;
        case 5:
          question = "What is 10 groups of 3?";
          correctAnswer = 30;
          break;
        case 6:
          question = "How many 10’s are there in 50?";
          correctAnswer = 5;
          break;
        case 7:
          question = "Which number is missing? 20 ÷ ? = 4";
          correctAnswer = 5;
          break;
        case 8:
          question = "Which number is missing?  ? ÷ 2 = 7";
          correctAnswer = 14;
          break;
        case 9:
          question = "5 children have 5 sweets each. How many sweets do they have in total?";
          correctAnswer = 25;
          break;
        case 10:
          question = "What is 5 groups of 4?";
          correctAnswer = 20;
          break;
        case 11:
          question = "How many seconds are in one minute?";
          correctAnswer = 60;
          break;
        case 12:
          question = "How many hours are in one day?";
          correctAnswer = 24;
          break;
        case 13:
          question = "How many 5’s are there in 30?";
          correctAnswer = 6;
          break;
        case 14:
          question = "How many minutes are there in a quarter of an hour?";
          correctAnswer = 15;
          break;
        case 15:
          question = "What is the total of 2, 15 and 3?";
          correctAnswer = 20;
          break;
        case 16:
          question = "What is the total of 7 and 26?";
          correctAnswer = 33;
          break;
        case 17:
          question = "What is 5 + 5 + 10 + 5 + 5?";
          correctAnswer = 30;
          break;
        case 18:
          question = "What is the sum of 7, 9 and 3?";
          correctAnswer = 19;
          break;
        case 19:
          question = "A table has 4 legs. How many legs do 4 tables have?";
          correctAnswer = 16;
          break;
        case 20:
          question = "4 friends share 8 slices of pizza. How many slices will they each get?";
          correctAnswer = 2;
          break;
        case 21:
          question = "What is the missing number: 20 - ? = 8";
          correctAnswer = 12;
          break;
        case 22:
          question = "If one child has 10 fingers, how many fingers will 4 children have?";
          correctAnswer = 40;
          break;
        case 23:
          question = "How many tens are there in 170?";
          correctAnswer = 17;
          break;
        case 24:
          question = "What is the missing number: 14 - ? = 2";
          correctAnswer = 12;
        default:
          question = "";
          correctAnswer = 0;
      }
    }



    answerOptions.add(correctAnswer);

    while (answerOptions.length < 3) {
      int offset = random.nextInt(15) - 7;
      int incorrectAnswer = correctAnswer + offset;

      if (incorrectAnswer != correctAnswer && incorrectAnswer > 0 && !answerOptions.contains(incorrectAnswer)) {
        answerOptions.add(incorrectAnswer);
      }
    }
    answerOptions.shuffle();
  } 





  else if (learnage == 3) {
    double randomNumber1 = random.nextDouble();
    int result1, result3, result4;
    String result2;

    if (randomNumber1 < 0.2) {
      result2 = "-";
      result1 = random.nextInt(100) + 1;
      int upperLimit = min(result1, 100);
      result3 = random.nextInt(upperLimit) + 1;
      correctAnswer = result1 - result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.4) {
      result2 = "x";
      result1 = random.nextInt(10) + 1;  
      result3 = random.nextInt(12) + 1;
      correctAnswer = result1 * result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.55) {
      result2 = "+";
      result1 = random.nextInt(100) + 1; 
      result3 = random.nextInt(100) + 1;
      correctAnswer = result1 + result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.60) {
      result2 = "+";
      result1 = random.nextInt(100) + 1; 
      result3 = random.nextInt(50) + 1;
      result4 = random.nextInt(50) + 1;
      correctAnswer = result1 + result3 + result4;
      question = "$result1 $result2 $result3 $result2 $result4";

      } else if (randomNumber1 < 0.80) {
    result1 = random.nextInt(10) + 1; 
    correctAnswer = random.nextInt(12) + 1; 
    result3 = result1 * correctAnswer; 
    result2 = "÷";
    question = "$result3 $result2 $result1";


    } else {
      int wordedQuestion = random.nextInt(25);
      switch (wordedQuestion) {
        case 0:
          question = "What number is missing? 8 x ? = 88";
          correctAnswer = 11;
          break;
        case 1:
          question = "How many sides does an octagon have?";
          correctAnswer = 8;
          break;
        case 2:
          question = "How many sides does a hexagon have?";
          correctAnswer = 6;
          break;
        case 3:
          question = "How many sides does a Pentagon have?";
          correctAnswer = 5;
          break;
        case 4:
          question = "An apple weighs 25g. How many grams would 4 apples weigh?";
          correctAnswer = 100;
          break;
        case 5:
          question = "6 bricks weigh 600g. How many grams do 2 bricks weigh?";
          correctAnswer = 200;
          break;
        case 6:
          question = "How many pence is £7.96?";
          correctAnswer = 796;
          break;
        case 7:
          question = "How many days in 3 weeks?";
          correctAnswer = 21;
          break;
        case 8:
          question = "What is 400 – 100 – 132?";
          correctAnswer = 168;
          break;
        case 9:
          question = "How many seconds in 3 minutes?";
          correctAnswer = 180;
        case 10:
          question = "What is the result of 40 divided by 10?";
          correctAnswer = 4;
          break;
        case 11:
          question = "What is 9 times 5?";
          correctAnswer = 45;
          break;
        case 12:
          question = "How many faces does a cube have?";
          correctAnswer = 6;
          break;
        case 13:
          question = "How many 6s in 36?";
          correctAnswer = 6;
          break;
        case 14:
          question = "What number do I get if I share 45 between 5?";
          correctAnswer = 9;
          break;
        case 15:
          question = "What is the next number in this sequence?  7, 14, 21, 28";
          correctAnswer = 35;
          break;
        case 16:
          question = "What is the next number in this sequence?  18, 24, 30, 36";
          correctAnswer = 42;
          break;
        case 17:
          question = "What number is missing: 12 x ? = 36";
          correctAnswer = 3;
          break;
        case 18:
          question = "What is the next number in this sequence?  8, 16, 24, 32";
          correctAnswer = 40;
          break;
        case 19:
          question = "What number lies halfway between 100 and 200?";
          correctAnswer = 150;
          break;
        case 20:
          question = "What number is missing: 42 - ? = 29";
          correctAnswer = 13;
          break;
        case 21:
          question = "What is the next number in this sequence?  4, 8, 13, 19";
          correctAnswer = 26;
          break;
        case 22:
          question = "What number lies halfway between 40 and 70?";
          correctAnswer = 55;
          break;
        case 23:
          question = "What number lies halfway between 20 and 100?";
          correctAnswer = 60;
          break;
        case 24:
          question = "How many 5’s in 60?";
          correctAnswer = 12;
        default:
          question = "";
          correctAnswer = 0;
      }
    }



    answerOptions.add(correctAnswer);

    while (answerOptions.length < 3) {
      int offset = random.nextInt(15) - 7;
      int incorrectAnswer = correctAnswer + offset;

      if (incorrectAnswer != correctAnswer && incorrectAnswer > 0 && !answerOptions.contains(incorrectAnswer)) {
        answerOptions.add(incorrectAnswer);
      }
    }
    answerOptions.shuffle();
  } 




  else if (learnage == 4) {
        double randomNumber1 = random.nextDouble();
    int result1, result3,result4;
    String result2;


    if (randomNumber1 < 0.2) {
      result2 = "-";
      result1 = random.nextInt(1000) + 1;
      int upperLimit = min(result1, 1000);
      result3 = random.nextInt(upperLimit) + 1;
      correctAnswer = result1 - result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.4) {
      result2 = "x";
      result1 = random.nextInt(12) + 1; 
      result3 = random.nextInt(12) + 1;
      correctAnswer = result1 * result3;
      question = "$result1 $result2 $result3";


    } else if (randomNumber1 < 0.55) {
      result2 = "+";
      result1 = random.nextInt(1000) + 1; 
      result3 = random.nextInt(1000) + 1;
      correctAnswer = result1 + result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.60) {
      result2 = "+";
      result1 = random.nextInt(100) + 1; 
      result3 = random.nextInt(100) + 1;
      result4 = random.nextInt(100) + 1;
      correctAnswer = result1 + result3 + result4;
      question = "$result1 $result2 $result3 $result2 $result4";

} else if (randomNumber1 < 0.80) {
    result1 = random.nextInt(12) + 1; 
    correctAnswer = random.nextInt(12) + 1;
    result3 = result1 * correctAnswer; 
    result2 = "÷"; 
    question = "$result3 $result2 $result1";


    } else {
  int wordedQuestion = random.nextInt(25);
      switch (wordedQuestion) {
        case 0:
          question = "What would we add to 56 to get 100?";
          correctAnswer = 44;
          break;
        case 1:
          question = "How many degrees in half of one whole turn?";
          correctAnswer = 180;
          break;
        case 2:
          question = "Which number comes next? 22, 27, 32, 37";
          correctAnswer = 42;
          break;
        case 3:
          question = "Which number lies halfway between 1,020 and 1,050?";
          correctAnswer = 1035;
          break;
        case 4:
          question = "What is one tenth of 30?";
          correctAnswer = 3;
          break;
        case 5:
          question = "What is one quarter of 60?";
          correctAnswer = 15;
          break;
        case 6:
          question = "Which multiple of 4 comes after 32?";
          correctAnswer = 36;
          break;
        case 7:
          question = "Which number is divisible by 4 and 5?";
          correctAnswer = 20;
          break;
        case 8:
          question = "What is the next number of the sequence? 136, 140, 144, 148";
          correctAnswer = 152;
        case 9:
          question = "How many degrees is one whole turn?";
          correctAnswer = 360;
          break;
       case 10:
          question = "What is one third of 150?";
          correctAnswer = 50;
          break;
        case 11:
          question = "What is one quarter of 100?";
          correctAnswer = 25;
          break;
        case 12:
          question = "What is one third of 21?";
          correctAnswer = 7;
          break;
        case 13:
          question = "What is one quarter of 500?";
          correctAnswer = 125;
        case 14:
          question = "What is one third of 63?";
          correctAnswer = 21;
          break;
       case 15:
          question = "What is half of 340?";
          correctAnswer = 170;
          break;
        case 16:
          question = "What number is missing: 15 x ? = 90";
          correctAnswer = 6;
          break;
        case 17:
          question = "What number is missing: ? – 32 = 32";
          correctAnswer = 64;
          break;
        case 18:
          question = "What number is divisible by 4 and 12?";
          correctAnswer = 24;
        case 19:
          question = "What is one fifth of 100?";
          correctAnswer = 20;
          break;
       case 20:
          question = "What is one third of 36?";
          correctAnswer = 12;
          break;
        case 21:
          question = "What is one tenth of 130?";
          correctAnswer = 13;
          break;
        case 22:
          question = "How many degrees in a right angle?";
          correctAnswer = 90;
          break;
        case 23:
          question = "What is the product of 6 and 9?";
          correctAnswer = 54;
          break;
        case 24:
          question = "A box has 5 rows of 8 apples. How many apples are there in the box?";
          correctAnswer = 40;
        default:
          question = "";
          correctAnswer = 0;
      }
    }

    answerOptions.add(correctAnswer);

    while (answerOptions.length < 3) {
      int offset = random.nextInt(15) - 7;
      int incorrectAnswer = correctAnswer + offset;

      if (incorrectAnswer != correctAnswer && incorrectAnswer > 0 && !answerOptions.contains(incorrectAnswer)) {
        answerOptions.add(incorrectAnswer);
      }
    }
    answerOptions.shuffle();
  } 




  else if (learnage == 5) {
       double randomNumber1 = random.nextDouble();
    int result1, result3, result4;
    String result2;


    if (randomNumber1 < 0.2) {
      result2 = "-";
      result1 = random.nextInt(5000) + 1;
      int upperLimit = min(result1, 5000);
      result3 = random.nextInt(upperLimit) + 1;
      correctAnswer = result1 - result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.32) {
      result2 = "x";
      result1 = random.nextInt(12) + 1;  
      result3 = random.nextInt(100) + 1;
      correctAnswer = result1 * result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.36) {
      result2 = "²";
      result1 = random.nextInt(14) + 1; 
      correctAnswer = result1 * result1;
      question = "$result1$result2 ";

    } else if (randomNumber1 < 0.4) {
      result2 = "³";
      result1 = random.nextInt(5) + 1; 
      correctAnswer = result1 * result1 * result1;
      question = "$result1$result2 ";

    } else if (randomNumber1 < 0.55) {
      result2 = "+";
      result1 = random.nextInt(5000) + 1;  
      result3 = random.nextInt(5000) + 1;
      correctAnswer = result1 + result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.60) {
      result2 = "+";
      result1 = random.nextInt(1000) + 1; 
      result3 = random.nextInt(1000) + 1;
      result4 = random.nextInt(1000) + 1;
      correctAnswer = result1 + result3 + result4;
      question = "$result1 $result2 $result3 $result2 $result4";

    } else if (randomNumber1 < 0.75) {
    result1 = random.nextInt(12) + 1; 
    correctAnswer = random.nextInt(100) + 1; 
    result3 = result1 * correctAnswer; 
    result2 = "÷"; 
    question = "$result3 $result2 $result1";

    } else if (randomNumber1 < 0.80) {
    correctAnswer = random.nextInt(10) + 1; 
    result1 = correctAnswer * correctAnswer; 
    result2  = "Square root of"; 
    question = "$result2 $result1?";


   } else {
  int wordedQuestion = random.nextInt(25);
      switch (wordedQuestion) {
        case 0:
          question = "Which number is halfway between 27,400 and 28,000?";
          correctAnswer = 27700;
          break;
        case 1:
          question = "What is the next number of the following sequence? 64, 56, 48, 40, 32";
          correctAnswer = 24;
          break;
        case 2:
          question = "What will be the next number of this sequence? 11, 22, 33, 44, 55, 66";
          correctAnswer = 77;
          break;
        case 3:
          question = "What needs to be added to 45,600 to make 45,912?";
          correctAnswer = 312;
          break;
        case 4:
          question = "What is 2 fifths of 100?";
          correctAnswer = 40;
          break;
        case 5:
          question = "What needs to be subtracted from 4,733 to make 2,723?";
          correctAnswer = 2010;
          break;
        case 6:
          question = "What is the next number of the sequence? 9, 18, 27, 36";
          correctAnswer = 45;
          break;
        case 7:
          question = "What will be the tenth number of this sequence? 11, 22, 33, 44, 55, 66";
          correctAnswer = 110;
          break;
        case 8:
          question = "What is the product of 7 and 8?";
          correctAnswer = 56;
          break;
        case 9:
          question = "What is the next number in this sequence? 14, 28, 42, 56";
          correctAnswer = 70;
          break;
       case 10:
          question = "What is three quarters of 72?";
          correctAnswer = 54;
          break;
        case 11:
          question = "What is two tenths of 55?";
          correctAnswer = 11;
          break;
        case 12:
          question = "What is the next number in this sequence? 60, 120, 240, 480";
          correctAnswer = 960;
          break;
        case 13:
          question = "What is the next number in this sequence? 150, 300, 450, 600";
          correctAnswer = 750;
        case 14:
          question = "What is 4 tenths of 200?";
          correctAnswer = 80;
          break;
       case 15:
          question = "In every 10 bricks, 3 are red. We have 30 bricks so how many are red?";
          correctAnswer = 9;
          break;
        case 16:
          question = "A box holds 12 eggs. I have 168 eggs. How many boxes do I have?";
          correctAnswer = 14;
          break;
        case 17:
          question = "What is one third of 90?";
          correctAnswer = 30;
          break;
        case 18:
          question = "What is a fifth of 120?";
          correctAnswer = 24;
        case 19:
          question = "What number is missing: 152 - ? = 135";
          correctAnswer = 17;
          break;
       case 20:
          question = "What number is missing:  81 x ? = 243";
          correctAnswer = 3;
          break;
        case 21:
          question = "What is 3 fifths of 250?";
          correctAnswer = 150;
          break;
        case 22:
          question = "What is 4 sixths of 240?";
          correctAnswer = 160;
          break;
        case 23:
          question = "A can holds 50 beans. How many cans are needed for 1000 beans?";
          correctAnswer = 20;
          break;
        case 24:
          question = "If I halve 64 three times, what number do I have left?";
          correctAnswer = 8;
        default:
          question = "";
          correctAnswer = 0;
      }
    }

    answerOptions.add(correctAnswer);

    while (answerOptions.length < 3) {
      int offset = random.nextInt(15) - 7;
      int incorrectAnswer = correctAnswer + offset;

      if (incorrectAnswer != correctAnswer && incorrectAnswer > 0 && !answerOptions.contains(incorrectAnswer)) {
        answerOptions.add(incorrectAnswer);
      }
    }
    answerOptions.shuffle();
  } 



  else if (learnage == 6) {
        double randomNumber1 = random.nextDouble();
    int result1, result3, result4;
    String result2;


    if (randomNumber1 < 0.2) {
      result2 = "-";
      result1 = random.nextInt(9999) + 1;
      int upperLimit = min(result1, 9999);
      result3 = random.nextInt(upperLimit) + 1;
      correctAnswer = result1 - result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.32) {
      result2 = "x";
      result1 = random.nextInt(99) + 1; 
      result3 = random.nextInt(99) + 1;
      correctAnswer = result1 * result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.36) {
      result2 = "²";
      result1 = random.nextInt(15) + 1; 
      correctAnswer = result1 * result1;
      question = "$result1$result2 ";

    } else if (randomNumber1 < 0.4) {
      result2 = "³";
      result1 = random.nextInt(10) + 1; 
      correctAnswer = result1 * result1 * result1;
      question = "$result1$result2 ";

    } else if (randomNumber1 < 0.55) {
      result2 = "+";
      result1 = random.nextInt(9999) + 1; 
      result3 = random.nextInt(9999) + 1;
      correctAnswer = result1 + result3;
      question = "$result1 $result2 $result3";

      } else if (randomNumber1 < 0.60) {
      result2 = "+";
      result1 = random.nextInt(1000) + 1; 
      result3 = random.nextInt(1000) + 1;
      result4 = random.nextInt(1000) + 1;
      correctAnswer = result1 + result3 + result4;
      question = "$result1 $result2 $result3 $result2 $result4";
    
    } else if (randomNumber1 < 0.75) {
    result1 = random.nextInt(99) + 1; 
    correctAnswer = random.nextInt(99) + 1; 
    result3 = result1 * correctAnswer; 
    result2 = "÷"; 
    question = "$result3 $result2 $result1";

    } else if (randomNumber1 < 0.80) {
    correctAnswer = random.nextInt(12) + 1; 
    result1 = correctAnswer * correctAnswer; 
    result2  = "Square root of"; 
    question = "$result2 $result1?";
    }

    else {
  int wordedQuestion = random.nextInt(25);

      
      switch (wordedQuestion) {
        case 0:
          question = "How many faces does a square-based pyramid have?";
          correctAnswer = 5;
          break;
        case 1:
          question = "What is 450 rounded to the nearest 100?";
          correctAnswer = 500;
          break;
        case 2:
          question = "Which is the mode of this data: 2, 5, 7, 2 , 7, 2, 3?";
          correctAnswer = 2;
          break;
        case 3:
          question = "What is the mean of this data: 11, 14, 17, 18, 20?";
          correctAnswer = 16;
          break;
        case 4:
          question = "What is the median of this data: 11, 14, 17, 18, 20?";
          correctAnswer = 17;
          break;
        case 5:
          question = "What is the range of this data: 11, 14, 17, 18, 20?";
          correctAnswer = 9;
          break;
        case 6:
          question = "What is the next number of the sequence? 1, 3, 6, 10, 15, 21";
          correctAnswer = 28;
          break;
        case 7:
          question = "How many sides does a decagon have?";
          correctAnswer = 10;
          break;
        case 8:
          question = "What is multiplied by 4 to give 180?";
          correctAnswer = 45;
          break;
        case 9:
          question = "Which is the median in this set of data: 2, 4, 4, 6,  8, 10, 16?";
          correctAnswer = 6;
          break;
       case 10:
          question = "Which is the mode in this set of data: 2, 4, 4, 6,  8, 10, 16?";
          correctAnswer = 4;
          break;
        case 11:
          question = "What is the mode of this data: 2, 3, 3, 5, 5, 5, 7";
          correctAnswer = 5;
          break;
        case 12:
          question = "What is the mean of this data: 2, 3, 3, 5, 5, 6";
          correctAnswer = 4;
          break;
        case 13:
          question = "What is the median of this data: 2, 3, 3, 5, 5, 5, 7";
          correctAnswer = 5;
          break;
        case 14:
          question = "What is divided by 6 to leave 9?";
          correctAnswer = 54;
          break;
       case 15:
          question = "What is one sixth of 132?";
          correctAnswer = 22;
          break;
        case 16:
          question = "What is 2 sevenths of 140?";
          correctAnswer = 40;
          break;
        case 17:
          question = "What is three quarters of 160?";
          correctAnswer = 120;
          break;
        case 18:
          question = "What number is missing: 131 + ? = 277";
          correctAnswer = 146;
          break;
        case 19:
          question = "What number is missing: 840 - ? = 85";
          correctAnswer = 755;
          break;
       case 20:
          question = "What is 3 eighths of 320?";
          correctAnswer = 120;
          break;
        case 21:
          question = "What is 2 twelves of 72?";
          correctAnswer = 12;
          break;
        case 22:
          question = "What is 4 fifths of 300?";
          correctAnswer = 240;
          break;
        case 23:
          question = "How many faces does a dodecahedron have?";
          correctAnswer = 12;
          break;
        case 24:
          question = "What is the next number of the sequence? 20, 10, 30, 20, 40";
          correctAnswer = 30;
        default:
          question = "";
          correctAnswer = 0;
      }
    }



    answerOptions.add(correctAnswer);

    while (answerOptions.length < 3) {
      int offset = random.nextInt(15) - 7;
      int incorrectAnswer = correctAnswer + offset;

      if (incorrectAnswer != correctAnswer && incorrectAnswer > 0 && !answerOptions.contains(incorrectAnswer)) {
        answerOptions.add(incorrectAnswer);
      }
    }
    answerOptions.shuffle();
  } 





  else if (learnage == 7) {
        double randomNumber1 = random.nextDouble();
    int result1, result3, result4;
    String result2;


    if (randomNumber1 < 0.2) {
      result2 = "-";
      result1 = random.nextInt(9999) + 1;
      int upperLimit = min(result1, 9999);
      result3 = random.nextInt(upperLimit) + 1;
      correctAnswer = result1 - result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.32) {
      result2 = "x";
      result1 = random.nextInt(99) + 1;  
      result3 = random.nextInt(9999) + 1;
      correctAnswer = result1 * result3;
      question = "$result1 $result2 $result3";

    } else if (randomNumber1 < 0.36) {
      result2 = "²";
      result1 = random.nextInt(20) + 1; 
      correctAnswer = result1 * result1;
      question = "$result1$result2 ";

    } else if (randomNumber1 < 0.4) {
      result2 = "³";
      result1 = random.nextInt(12) + 1; 
      correctAnswer = result1 * result1 * result1;
      question = "$result1$result2 ";

      } else if (randomNumber1 < 0.55) {
      result2 = "+";
      result1 = random.nextInt(1000) + 1; 
      result3 = random.nextInt(1000) + 1;
      result4 = random.nextInt(1000) + 1;
      correctAnswer = result1 + result3 + result4;
      question = "$result1 $result2 $result3 $result2 $result4";
    
    } else if (randomNumber1 < 0.6) {
      result2 = "+";
      result1 = random.nextInt(9999) + 1; 
      result3 = random.nextInt(9999) + 1;
      correctAnswer = result1 + result3;
      question = "$result1 $result2 $result3";

      } else if (randomNumber1 < 0.75) {

    result1 = random.nextInt(99) + 1;
    correctAnswer = random.nextInt(9999) + 1; 
    result3 = result1 * correctAnswer; 
    result2 = "÷"; 
    question = "$result3 $result2 $result1";

      } else if (randomNumber1 < 0.80) {
    correctAnswer = random.nextInt(15) + 1; 
    result1 = correctAnswer * correctAnswer; 
    result2  = "Square root of"; 
    question = "$result2 $result1?";
    

    } else {
  int wordedQuestion = random.nextInt(40);
      switch (wordedQuestion) {
        case 0:
          question = "How many faces does a square-based pyramid have?";
          correctAnswer = 5;
          break;
        case 1:
          question = "What is 450 rounded to the nearest 100?";
          correctAnswer = 500;
          break;
        case 2:
          question = "Which is the mode of this data: 2, 5, 7, 2 , 7, 2, 3?";
          correctAnswer = 2;
          break;
        case 3:
          question = "What is the mean of this data: 11, 14, 17, 18, 20?";
          correctAnswer = 16;
          break;
        case 4:
          question = "What is the median of this data: 11, 14, 17, 18, 20?";
          correctAnswer = 17;
          break;
        case 5:
          question = "What is the range of this data: 11, 14, 17, 18, 20?";
          correctAnswer = 9;
          break;
        case 6:
          question = "What is the next number of the sequence? 1, 3, 6, 10, 15, 21";
          correctAnswer = 28;
          break;
        case 7:
          question = "How many sides does a decagon have?";
          correctAnswer = 10;
          break;
        case 8:
          question = "What is multiplied by 4 to give 180?";
          correctAnswer = 45;
          break;
        case 9:
          question = "Which is the median in this set of data: 2, 4, 4, 6,  8, 10, 16?";
          correctAnswer = 6;
          break;
       case 10:
          question = "Which is the mode in this set of data: 2, 4, 4, 6,  8, 10, 16?";
          correctAnswer = 4;
          break;
        case 11:
          question = "What is the mode of this data: 2, 3, 3, 5, 5, 5, 7";
          correctAnswer = 5;
          break;
        case 12:
          question = "What is the mean of this data: 2, 3, 3, 5, 5, 6";
          correctAnswer = 4;
          break;
        case 13:
          question = "What is the median of this data: 2, 3, 3, 5, 5, 5, 7";
          correctAnswer = 5;
        case 14:
          question = "What is divided by 6 to leave 9?";
          correctAnswer = 54;
          break;
       case 15:
          question = "What is one sixth of 132?";
          correctAnswer = 22;
          break;
        case 16:
          question = "What is 2 sevenths of 140?";
          correctAnswer = 40;
          break;
        case 17:
          question = "What is three quarters of 160?";
          correctAnswer = 120;
          break;
        case 18:
          question = "What number is missing: 131 + ? = 277";
          correctAnswer = 146;
          break;
        case 19:
          question = "What number is missing: 840 - ? = 85";
          correctAnswer = 755;
          break;
       case 20:
          question = "What is 3 eighths of 320?";
          correctAnswer = 120;
          break;
        case 21:
          question = "What is 2 twelves of 72?";
          correctAnswer = 12;
          break;
        case 22:
          question = "What is 4 fifths of 300?";
          correctAnswer = 240;
          break;
        case 23:
          question = "How many faces does a dodecahedron have?";
          correctAnswer = 12;
        case 24:
          question = "What is the next number of the sequence? 20, 10, 30, 20, 40";
          correctAnswer = 30;
          break;
        case 25:
          question = "What is the mean of this data: 32, -8, 14, 40, 22?";
          correctAnswer = 20;
          break;
        case 26:
          question = "What is the median of this data: 32, -8, 14, 40, 22?";
          correctAnswer = 22;
          break;
        case 27:
          question = "If a tap drips once every 15 seconds, how many times will it drip in an hour?";
          correctAnswer = 240;
          break;
        case 28:
          question = "What is the mean 22, 23, 23, 25, 27, 30";
          correctAnswer = 25;
          break;
        case 29:
          question = "What is the mode 22, 23, 23, 25, 27, 30";
          correctAnswer = 23;
          break;
        case 30:
          question = "What is the median 22, 23, 23, 25, 27, 30";
          correctAnswer = 24;
          break;
        case 31:
          question = "How many hours is one week?";
          correctAnswer = 168;
          break;
        case 32:
          question = "How many minutes in a day?";
          correctAnswer = 1440;
          break;
        case 33:
          question = "What is the next number of the sequence? 23, 30, 38, 47, 57";
          correctAnswer = 68;
          break;
        case 34:
          question = "What are three eighths of 888?";
          correctAnswer = 333;
          break;
        case 35:
          question = "The 4th and 5th multiples of a number are 24 and 30. What is the number?";
          correctAnswer = 6;
          break;
        case 36:
          question = "Which of the following is a common factor of 15, 30, 45 and 20?";
          correctAnswer = 5;
          break;
        case 37:
          question = "The 2nd and 6th multiples of a number are 22 and 66. What is the number?";
          correctAnswer = 11;
          break;
        case 38:
          question = "The 3rd and 8th multiples of a number are 42 and 112. What is the number?";
          correctAnswer = 14;
          break;
        case 39:
          question = "What is the sixth term in the sequence with Tn = 2n - 5?";
          correctAnswer = 7;
        default:
          question = "";
          correctAnswer = 0;
      }
    }


    answerOptions.add(correctAnswer);

    while (answerOptions.length < 3) {
      int offset = random.nextInt(15) - 7;
      int incorrectAnswer = correctAnswer + offset;

      if (incorrectAnswer != correctAnswer && incorrectAnswer > 0 && !answerOptions.contains(incorrectAnswer)) {
        answerOptions.add(incorrectAnswer);
      }
    }
    answerOptions.shuffle();
  } 




else if (learnage == 8) {

  question = "What is 5 + 7?";
  correctAnswer = 12;
  answerOptions = [12, 10, 14,]; 
  
  answerOptions.shuffle();
}




else if (learnage == 9) {

  question = "What is 5 + 7?";
  correctAnswer = 12;
    answerOptions.add(correctAnswer);

    while (answerOptions.length < 3) {
      int offset = random.nextInt(15) - 7;
      int incorrectAnswer = correctAnswer + offset;

      if (incorrectAnswer != correctAnswer && incorrectAnswer > 0 && !answerOptions.contains(incorrectAnswer)) {
        answerOptions.add(incorrectAnswer);
      }
    }
    answerOptions.shuffle();
}



  else {
    question = "Press one of the awnsers to begin";
    correctAnswer = 1; 
    answerOptions = [1, 1, 1]; 
  }



  return {
    'question': question,
    'answers': answerOptions,
    'correctAnswer': correctAnswer,
  };
}