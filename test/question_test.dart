import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/pages/about.dart';
import 'package:project/pages/authentication/login.dart';
import 'package:project/pages/faq.dart';
import 'package:project/pages/profile.dart';
import 'package:project/pages/question/question.dart';
import 'tools/fakeUser.dart';


void main() {
  setupFirebaseMocks();
  
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    
    final mockAuthService = MockAuthService();
    await mockAuthService.registerWithEmail(
      '1234321@example.com',
      'Test123!',
      'testuser',
      3
    );
    
    await mockAuthService.signInWithEmail('1234321@example.com', 'Test123!');
  });




  group('Question Tests', () {
    testWidgets('appbar', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Question()));

      expect(find.byType(AppBar), findsOneWidget);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      
      expect(find.descendant(of: find.byType(AppBar), matching: find.text('Math Club')), findsOneWidget);
      expect(appBar.centerTitle, isTrue);
      expect(appBar.automaticallyImplyLeading, false);
      expect(appBar.backgroundColor, Colors.blue);
      expect(appBar.toolbarHeight, 70.0);
    });




testWidgets('Back', (
  WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Question(),
    ),
  );
  
  expect(find.byType(Question), findsOneWidget);
  
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
  
  expect(find.byType(Question), findsOneWidget);
});




    testWidgets('Container', (
      WidgetTester tester) async {
  
      
      await tester.pumpWidget(
        MaterialApp(
          home: Question(
          )
        )
      );
      
      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      
      expect(container.padding, const EdgeInsets.all(16));
      
      final boxDecoration = container.decoration as BoxDecoration;
      expect(boxDecoration.color, Colors.blue);
      expect(boxDecoration.borderRadius, BorderRadius.circular(12));
      final containerSize = tester.getSize(containerFinder);
      expect(containerSize.width.round(), 675);
    });




testWidgets('Navigation', (
  WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Question(),
      routes: {
        '/Profile': (context) => ProfilePage(),
        '/About Us': (context) => AboutPage(),
        '/FAQ': (context) => FAQPage(),
      },
    ));
    await tester.pumpAndSettle();

    expect(find.byType(Question), findsOneWidget);

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);

  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();

    expect(find.byType(Question), findsOneWidget);



    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About Us'));
    await tester.pumpAndSettle();

    expect(find.byType(AboutPage), findsOneWidget);

  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();

    expect(find.byType(Question), findsOneWidget);



    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('FAQ'));
    await tester.pumpAndSettle();

    expect(find.byType(FAQPage), findsOneWidget);

  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();

    expect(find.byType(Question), findsOneWidget);


  });




testWidgets('Container contents', (
  WidgetTester tester) async {
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: '1234321@example.com',
    username: 'testuser',
    schoolYear: 8,
    correctCount: 5,
    daysInRow: 3,
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: Question(
        testUser: testUser,
      ),
    ),
  );
  
  await tester.pumpAndSettle();
  
  expect(find.text('What is 5 + 7?'), findsOneWidget);
  
  expect(find.byType(ElevatedButton), findsNWidgets(3));
  expect(find.text('12'), findsOneWidget);
  expect(find.text('10'), findsOneWidget);
  expect(find.text('14'), findsOneWidget);


  expect(find.byType(Image), findsOneWidget);
  
  expect(find.text('Days in'), findsOneWidget);
  expect(find.text('a row: 3'), findsOneWidget);
  
  expect(find.text('5/10'), findsOneWidget);

  
});




testWidgets('score/10', (
  WidgetTester tester) async {
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: '1234321@example.com',
    username: 'testuser',
    schoolYear: 8,
    correctCount: 0,
    daysInRow: 3,
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: Question(
        testUser: testUser,
      ),
    ),
  );
  
  await tester.pumpAndSettle();
      
  expect(find.text('0/10'), findsOneWidget);
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('1/10'), findsOneWidget);

  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('2/10'), findsOneWidget);
  
  final scoreContainer2 = tester.widget<Container>(
    find.ancestor(
      of: find.text('2/10'),
      matching: find.byType(Container),
    ).first
  );
  expect((scoreContainer2.decoration as BoxDecoration).color, 
    const Color.fromARGB(255, 218, 74, 74)); 

  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('3/10'), findsOneWidget);
  
  final scoreContainer3 = tester.widget<Container>(
    find.ancestor(
      of: find.text('3/10'),
      matching: find.byType(Container),
    ).first
  );
  expect((scoreContainer3.decoration as BoxDecoration).color, Colors.orange); 

  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('4/10'), findsOneWidget);

  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('5/10'), findsOneWidget);
  
  final scoreContainer5 = tester.widget<Container>(
    find.ancestor(
      of: find.text('5/10'),
      matching: find.byType(Container),
    ).first
  );
  expect((scoreContainer5.decoration as BoxDecoration).color, Colors.orange); 

  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('6/10'), findsOneWidget);
  
  final scoreContainer6 = tester.widget<Container>(
    find.ancestor(
      of: find.text('6/10'),
      matching: find.byType(Container),
    ).first
  );
  expect((scoreContainer6.decoration as BoxDecoration).color, Colors.yellow);

  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('7/10'), findsOneWidget);

  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('8/10'), findsOneWidget);

  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('9/10'), findsOneWidget);
  
  final scoreContainer9 = tester.widget<Container>(
    find.ancestor(
      of: find.text('9/10'),
      matching: find.byType(Container),
    ).first
  );
  expect((scoreContainer9.decoration as BoxDecoration).color, Colors.yellow); 

  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('10/10'), findsOneWidget);
  
  final scoreContainer10 = tester.widget<Container>(
    find.ancestor(
      of: find.text('10/10'),
      matching: find.byType(Container),
    ).first
  );
  expect((scoreContainer10.decoration as BoxDecoration).color, 
    const Color.fromARGB(255, 74, 218, 122)); 

  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('10/10'), findsOneWidget);
  
});




testWidgets('Days in a row increase', (
  WidgetTester tester) async {
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: '1234321@example.com',
    username: 'testuser',
    schoolYear: 8,
    correctCount: 9,
    daysInRow: 3,
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: Question(
        testUser: testUser,
      ),
    ),
  );
  
  await tester.pumpAndSettle();
      
  expect(find.text('9/10'), findsOneWidget);
  expect(find.text('Days in'), findsOneWidget);
  expect(find.text('a row: 3'), findsOneWidget);


  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('10/10'), findsOneWidget);
  
  expect(find.text('Days in'), findsOneWidget);
  expect(find.text('a row: 4'), findsOneWidget);


  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pumpAndSettle();
  expect(find.text('10/10'), findsOneWidget);
  
  expect(find.text('Days in'), findsOneWidget);
  expect(find.text('a row: 4'), findsOneWidget);
});




testWidgets('Answer position changes', (
  WidgetTester tester) async {
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: '1234321@example.com',
    username: 'testuser',
    schoolYear: 8,
    correctCount: 5,
    daysInRow: 3,
  );

  const int maxAttempts = 10;
  bool testPassed = false;

  for (int attempt = 0; attempt < maxAttempts; attempt++) {
    await tester.pumpWidget(
      MaterialApp(
        home: Question(
          testUser: testUser,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final firstAnswerButtons = find.byType(ElevatedButton);
    final firstAnswerTexts = tester.widgetList(firstAnswerButtons)
      .map((button) => int.parse(
        tester.widget<Text>(find.descendant(
          of: find.byWidget(button),
          matching: find.byType(Text)
        )).data!
      ))
      .toList();

    await tester.tap(firstAnswerButtons.first);
    await tester.pumpAndSettle();
    await tester.tap(firstAnswerButtons.first);
    await tester.pumpAndSettle();

    final secondAnswerButtons = find.byType(ElevatedButton);
    final secondAnswerTexts = tester.widgetList(secondAnswerButtons)
      .map((button) => int.parse(
        tester.widget<Text>(find.descendant(
          of: find.byWidget(button),
          matching: find.byType(Text)
        )).data!
      ))
      .toList();

    try {
      expect(firstAnswerTexts.toString(), isNot(equals(secondAnswerTexts.toString())));
      testPassed = true;
      break;
    } catch (_) {
      continue;
    }
  }

  expect(testPassed, isTrue);
});



testWidgets('false answers', (
  WidgetTester tester) async {
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: '1234321@example.com',
    username: 'testuser',
    schoolYear: 9,
    correctCount: 5,
    daysInRow: 3,
  );

  const int maxAttempts = 10;
  bool testPassed = false;

  for (int attempt = 0; attempt < maxAttempts; attempt++) {
    await tester.pumpWidget(
      MaterialApp(
        home: Question(
          testUser: testUser,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final firstAnswerButtons = find.byType(ElevatedButton);
    final firstAnswerTexts = tester.widgetList(firstAnswerButtons)
      .map((button) => int.parse(
        tester.widget<Text>(find.descendant(
          of: find.byWidget(button),
          matching: find.byType(Text)
        )).data!
      ))
      .toList();

    await tester.tap(firstAnswerButtons.first);
    await tester.pumpAndSettle();
    await tester.tap(firstAnswerButtons.first);
    await tester.pumpAndSettle();

    final secondAnswerButtons = find.byType(ElevatedButton);
    final secondAnswerTexts = tester.widgetList(secondAnswerButtons)
      .map((button) => int.parse(
        tester.widget<Text>(find.descendant(
          of: find.byWidget(button),
          matching: find.byType(Text)
        )).data!
      ))
      .toList();

    try {
      expect(firstAnswerTexts, isNot(unorderedEquals(secondAnswerTexts)));
      testPassed = true;
      break;
    } catch (_) {
      continue;
    }
  }

  expect(testPassed, isTrue);
});



testWidgets('logout', (
  WidgetTester tester) async {
  final mockAuthService = MockAuthService();
  
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: '1234321@example.com',
    username: 'testuser',
    schoolYear: 3,
    correctCount: 5,
    daysInRow: 3,
  );
  
  await tester.pumpWidget(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Question(
          authService: mockAuthService,
          testUser: testUser,
        ),
        '/Login': (context) => LoginPage(),
      },
    ),
  );
  
  await tester.pumpAndSettle();
  
  await tester.tap(find.byType(DropdownButton<String>));
  await tester.pumpAndSettle();
  
  await tester.tap(find.text('Logout'));
  await tester.pumpAndSettle();
  
  expect(mockAuthService.currentUser, isNull);
  expect(find.byType(LoginPage), findsOneWidget);


});



testWidgets('Next question', (
  WidgetTester tester) async {
  int attempts = 0;
  const maxAttempts = 5;
  bool testPassed = false;
  
  while (attempts < maxAttempts && !testPassed) {
    try {
      tester.binding.window.physicalSizeTestValue = Size(1280, 1080);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      
      final testUser = FakeUser(
        uid: 'test-user-id',
        email: '1234321@example.com',
        username: 'testuser',
        schoolYear: 3,
        correctCount: 5,
        daysInRow: 3,
        advancedMode: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Question(
            testUser: testUser,
          ),
        ),
      );
      await tester.pumpAndSettle();
      


      final questionText = tester.widget<Text>(
        find.descendant(
          of: find.byType(Container).first,
          matching: find.byType(Text),
        ).first
      ).data!;
      
      final answerButtons = find.byType(ElevatedButton);
      final answerSet = tester.widgetList(answerButtons)
        .map((button) => int.parse(
          tester.widget<Text>(find.descendant(
            of: find.byWidget(button),
            matching: find.byType(Text)
          )).data!
        ))
        .toSet();
      
      final imageFinder = find.byType(Image);
      final imagePath = (tester.widget<Image>(imageFinder).image as AssetImage).assetName;
      


      await tester.tap(answerButtons.first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pumpAndSettle();


      
      final newText = tester.widget<Text>(
        find.descendant(
          of: find.byType(Container).first,
          matching: find.byType(Text),
        ).first
      ).data!;
      
      final newButtons = find.byType(ElevatedButton);
      final newSet = tester.widgetList(newButtons)
        .map((button) => int.parse(
          tester.widget<Text>(find.descendant(
            of: find.byWidget(button),
            matching: find.byType(Text)
          )).data!
        ))
        .toSet();
      
      final newImage = find.byType(Image);
      final newPath = (tester.widget<Image>(newImage).image as AssetImage).assetName;
      


      expect(questionText != newText, isTrue);
      expect(answerSet != newSet, isTrue);
      expect(imagePath != newPath, isTrue);
      
      testPassed = true;
    } catch (e) {
      attempts++;
      if (attempts >= maxAttempts) {
        rethrow;
      }
    }
  }
});



testWidgets('Learnage calculate', (
  WidgetTester tester) async {


      final testUser = FakeUser(
        uid: 'test-user-id',
        email: 'test@example.com',
        username: 'testuser',
        schoolYear: 1,
        correctCount: 5,
        daysInRow: 3,
        advancedMode: true,
      );
      
      final Set<String> allQuestions = {};
      const String multiplicationSymbol = 'x';
      const String divisionSymbol = '÷';
      
      for (int i = 0; i < 25; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Question(
              testUser: testUser,
            ),
          ),
        );
        
        await tester.pumpAndSettle();
        
        final questionContainer = find.byType(Container);
        final textWidgetsInContainer = find.descendant(
          of: questionContainer,
          matching: find.byType(Text),
        );
        
        String fullQuestionText = '';
        for (final textWidget in tester.widgetList<Text>(textWidgetsInContainer)) {
          fullQuestionText += textWidget.data ?? '';
        }
        
        allQuestions.add(fullQuestionText);
        
        final answerButtons = find.byType(ElevatedButton);
        await tester.tap(answerButtons.first);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ElevatedButton).first);
        await tester.pumpAndSettle();
      }
      
      bool hasMultiplicationSymbol = allQuestions.any((question) => question.contains(multiplicationSymbol));
      bool hasDivisionSymbol = allQuestions.any((question) => question.contains(divisionSymbol));
      
      expect(hasMultiplicationSymbol, isTrue);
      expect(hasDivisionSymbol, isTrue);
      
});








testWidgets('timer', (
  WidgetTester tester) async {
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: 'test@example.com',
    username: 'testuser',
    schoolYear: 1,
    correctCount: 5,
    daysInRow: 3,
    advancedMode: true,
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: Question(
        testUser: testUser,
      ),
    ),
  );
  await tester.pumpAndSettle();
  
  final initialQuestion = tester.widget<Text>(find.descendant(
    of: find.byType(Container),
    matching: find.byType(Text),
  ).first).data;
  
  await tester.tap(find.byType(ElevatedButton).first);
  await tester.pumpAndSettle();
  
  final afterClick = tester.widget<Text>(find.descendant(
    of: find.byType(Container),
    matching: find.byType(Text),
  ).first).data;
  
  expect(afterClick, equals(initialQuestion));
  

  await tester.tap(find.byType(ElevatedButton).first);
  await tester.pumpAndSettle();
  
  final secondClick = tester.widget<Text>(find.descendant(
    of: find.byType(Container),
    matching: find.byType(Text),
  ).first).data;
  
  expect(secondClick != initialQuestion, isTrue);
  

  
  final initialQuestion2 = tester.widget<Text>(find.descendant(
    of: find.byType(Container),
    matching: find.byType(Text),
  ).first).data;
  
  await tester.tap(find.byType(ElevatedButton).first);  
  await tester.pump(const Duration(seconds: 3));
  
  final secondClick2 = tester.widget<Text>(find.descendant(
    of: find.byType(Container),
    matching: find.byType(Text),
  ).first).data;
  
  expect(secondClick2 != initialQuestion2, isTrue);
});




testWidgets('Incomplete reset', (
  WidgetTester tester) async {   
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: 'test@example.com',
    username: 'testuser',
    schoolYear: 1,
    correctCount: 9, 
    daysInRow: 3,
    lastResetTimestamp: DateTime.now(),
  );
   
  await tester.pumpWidget(
    MaterialApp(
      home: Question(
        testUser: testUser,
      ),
    ),
  );
   
  await tester.pumpAndSettle();
   
  expect(find.text('9/10'), findsOneWidget);
  expect(find.text('a row: 3'), findsOneWidget);
   
  final questionFinder = find.byType(Question);
  final State questionState = tester.state(questionFinder);
   
  (questionState as dynamic).resetCorrectCount();
   
  await tester.pumpAndSettle();
   
  expect(find.text('0/10'), findsOneWidget);
  expect(find.text('a row: 0'), findsOneWidget);
});



testWidgets('Incomplete reset 2', (
  WidgetTester tester) async {   
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: 'test@example.com',
    username: 'testuser',
    schoolYear: 1,
    correctCount: 10, 
    daysInRow: 3,
    lastResetTimestamp: DateTime.now().subtract(Duration(days: 2)),
  );
   
  await tester.pumpWidget(
    MaterialApp(
      home: Question(
        testUser: testUser,
      ),
    ),
  );
   
  await tester.pumpAndSettle();
   
  expect(find.text('10/10'), findsOneWidget);
  expect(find.text('a row: 3'), findsOneWidget);
   
  final questionFinder = find.byType(Question);
  final State questionState = tester.state(questionFinder);
   
  (questionState as dynamic).resetCorrectCount(); 
   
  await tester.pumpAndSettle();
   
  expect(find.text('0/10'), findsOneWidget);
  expect(find.text('a row: 0'), findsOneWidget);
});



testWidgets('Complete reset', (
  WidgetTester tester) async {   
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: 'test@example.com',
    username: 'testuser',
    schoolYear: 1,
    correctCount: 10,
    daysInRow: 3,
    lastResetTimestamp: DateTime.now(),
  );
   
  await tester.pumpWidget(
    MaterialApp(
      home: Question(
        testUser: testUser,
      ),
    ),
  );
   
  await tester.pumpAndSettle();
   
  expect(find.text('10/10'), findsOneWidget);
  expect(find.text('a row: 3'), findsOneWidget);
   
  final questionFinder = find.byType(Question);
  final State questionState = tester.state(questionFinder);
   
  (questionState as dynamic).resetCorrectCount();
   
  await tester.pumpAndSettle();
   
  expect(find.text('0/10'), findsOneWidget);
  expect(find.text('a row: 3'), findsOneWidget);
});




testWidgets('correct feedback', (
  WidgetTester tester) async {
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: 'test@example.com',
    username: 'testuser',
    schoolYear: 8,
    correctCount: 0,
    daysInRow: 0,
    advancedMode: false,
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: Question(
        testUser: testUser,
      ),
    ),
  );
  
  await tester.pumpAndSettle();
  
  final button1 = find.widgetWithText(ElevatedButton, '12');
  final button2 = find.widgetWithText(ElevatedButton, '10');
  final button3 = find.widgetWithText(ElevatedButton, '14');
  
  final correctBefore = tester.widget<ElevatedButton>(button1);
  final wrong1Before = tester.widget<ElevatedButton>(button2);
  final wrong2Before = tester.widget<ElevatedButton>(button3);
  
  final color1Before = correctBefore.style?.backgroundColor.toString();
  final color2Before = wrong1Before.style?.backgroundColor.toString();
  final color3Before = wrong2Before.style?.backgroundColor.toString();
  
  expect(color1Before!.contains('blue: 0.9'), isTrue);
  expect(color2Before!.contains('blue: 0.9'), isTrue);
  expect(color3Before!.contains('blue: 0.9'), isTrue);
  
  await tester.tap(find.widgetWithText(ElevatedButton, '12'));
  await tester.pump();
  
  expect(find.text('Correct!'), findsOneWidget);
  
  final correctAfter = tester.widget<ElevatedButton>(button1);
  final wrong1After = tester.widget<ElevatedButton>(button2);
  final wrong2After = tester.widget<ElevatedButton>(button3);
  
  final color1After = correctAfter.style?.backgroundColor.toString();
  final color2After = wrong1After.style?.backgroundColor.toString();
  final color3After = wrong2After.style?.backgroundColor.toString();
  
  expect(color1After!.contains('green: 0.8'), isTrue);
  expect(color1Before != color1After, isTrue);
  
  expect(color2After, equals(color2Before));
  expect(color3After, equals(color3Before));

  await tester.pump(const Duration(seconds: 4));
  await tester.pumpWidget(Container());
  await tester.pump();
});




testWidgets('Intro message', (
  WidgetTester tester) async {
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: 'test@example.com',
    username: 'testuser',
    schoolYear: 0,
    correctCount: 0,
    daysInRow: 0,
    advancedMode: false,
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: Question(
        testUser: testUser,
      ),
    ),
  );
  
  await tester.pumpAndSettle();
  
  expect(find.text('Press one of the awnsers to begin'), findsOneWidget);

final button1 = find.widgetWithText(ElevatedButton, '1').at(0);
final button2 = find.widgetWithText(ElevatedButton, '1').at(1);
final button3 = find.widgetWithText(ElevatedButton, '1').at(2);
  
  final correctBefore = tester.widget<ElevatedButton>(button1);
  final wrong1Before = tester.widget<ElevatedButton>(button2);
  final wrong2Before = tester.widget<ElevatedButton>(button3);
  
  final color1Before = correctBefore.style?.backgroundColor.toString();
  final color2Before = wrong1Before.style?.backgroundColor.toString();
  final color3Before = wrong2Before.style?.backgroundColor.toString();
  
  expect(color1Before!.contains('blue: 0.9'), isTrue);
  expect(color2Before!.contains('blue: 0.9'), isTrue);
  expect(color3Before!.contains('blue: 0.9'), isTrue);
  
  await tester.tap(find.widgetWithText(ElevatedButton, '1').first);
  await tester.pump();
  
  expect(find.text('Correct!'), findsOneWidget);
  
  final correctAfter = tester.widget<ElevatedButton>(button1);
  final wrong1After = tester.widget<ElevatedButton>(button2);
  final wrong2After = tester.widget<ElevatedButton>(button3);
  
  final color1After = correctAfter.style?.backgroundColor.toString();
  final color2After = wrong1After.style?.backgroundColor.toString();
  final color3After = wrong2After.style?.backgroundColor.toString();
  
  expect(color1After!.contains('green: 0.8'), isTrue);
  expect(color1Before != color1After, isTrue);
  
  expect(color2After!.contains('green: 0.8'), isTrue);
  expect(color2Before != color2After, isTrue);  

  expect(color3After!.contains('green: 0.8'), isTrue);
  expect(color3Before != color3After, isTrue);

  await tester.pump(const Duration(seconds: 4));
  await tester.pumpWidget(Container());
  await tester.pump();
});





testWidgets('incorrect feedback', (
  WidgetTester tester) async {
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: 'test@example.com',
    username: 'testuser',
    schoolYear: 8,
    correctCount: 0,
    daysInRow: 0,
    advancedMode: false,
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: Question(
        testUser: testUser,
      ),
    ),
  );
  
  await tester.pumpAndSettle();
  
  final button1 = find.widgetWithText(ElevatedButton, '12');
  final button2 = find.widgetWithText(ElevatedButton, '10');
  final button3 = find.widgetWithText(ElevatedButton, '14');
  
  final correctBefore = tester.widget<ElevatedButton>(button1);
  final wrong1Before = tester.widget<ElevatedButton>(button2);
  final wrong2Before = tester.widget<ElevatedButton>(button3);
  
  final color1Before = correctBefore.style?.backgroundColor.toString();
  final color2Before = wrong1Before.style?.backgroundColor.toString();
  final color3Before = wrong2Before.style?.backgroundColor.toString();
  
  expect(color1Before!.contains('blue: 0.9'), isTrue);
  expect(color2Before!.contains('blue: 0.9'), isTrue);
  expect(color3Before!.contains('blue: 0.9'), isTrue);
  
  await tester.tap(find.widgetWithText(ElevatedButton, '10'));
  await tester.pump();
  
  expect(find.text('Incorrect'), findsOneWidget);
  expect(find.byType(Image), findsOneWidget);


  final correctAfter = tester.widget<ElevatedButton>(button1);
  final wrong1After = tester.widget<ElevatedButton>(button2);
  final wrong2After = tester.widget<ElevatedButton>(button3);
  
  final color1After = correctAfter.style?.backgroundColor.toString();
  final color2After = wrong1After.style?.backgroundColor.toString();
  final color3After = wrong2After.style?.backgroundColor.toString();
  
  expect(color1After!.contains('green: 0.8'), isTrue);
  expect(color1Before != color1After, isTrue);
  
  expect(color2After!.contains('red: 0.8'), isTrue);
  expect(color2After != color2Before, isTrue);


  expect(color3After, equals(color3Before));


  
  
  await tester.pump(const Duration(seconds: 4));
  await tester.pumpWidget(Container());
  await tester.pump();
});







  });

}


