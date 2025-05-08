import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/pages/question/question.dart';
import 'package:project/pages/authentication/login.dart';
import 'package:project/pages/authentication/register.dart';
import 'package:project/pages/faq.dart';
import 'package:project/pages/about.dart';
import 'package:project/pages/profile.dart';
import 'package:project/pages/intro.dart';
import 'dart:math';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'tools/fakeUser.dart';
import 'tools/mockEmail.dart';


class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  String? lastLaunchedUrl;
  
  @override
  Future<bool> canLaunch(String url) {
    return Future.value(true);
  }

  @override
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    String? webOnlyWindowName,
  }) {
    lastLaunchedUrl = url;
    return Future.value(true);
  }
}

class Mock extends Fake {}

String generateUniqueEmail() {
  int random;
  String email;
  do {
    random = Random().nextInt(99999999);
    email = '$random@example.com';
  } while (MockAuthService.registeredEmails.contains(email));
  return email;
}

String generateUniqueUsername() {
  int random;
  String username;
  do {
    random = Random().nextInt(99999999);
    username = 'user$random';
  } while (MockAuthService.registeredUsernames.contains(username));
  return username;
}

void main() {
  setupFirebaseMocks();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });


  

  group('Performance Tests', () {
    final results = <String, double>{};
    
    testWidgets('Load pages', (
      WidgetTester tester) async {
      final pages = [
        {'name': 'Intro Page', 'widget': IntroPage()},
        {'name': 'Login Page', 'widget': LoginPage()},
        {'name': 'Register Page', 'widget': RegisterPage()},
        {'name': 'FAQ Page', 'widget': FAQPage()},
        {'name': 'About Page', 'widget': AboutPage()},
        {'name': 'Question Page', 'widget': Question()},
        {'name': 'Profile Page', 'widget': ProfilePage()},
      ];

      for (var page in pages) {
        final pageName = page['name'] as String;
        final widget = page['widget'] as Widget;

        final stopwatch = Stopwatch()..start();
        
        await tester.pumpWidget(
          MaterialApp(home: widget)
        );
        
        await tester.pumpAndSettle();
        
        stopwatch.stop();
        final milliseconds = stopwatch.elapsedMilliseconds;
        
        results[pageName] = milliseconds.toDouble();
        
        expect(milliseconds, lessThan(2000));
      }
    });


    
    testWidgets('Login',(
      WidgetTester tester) async {
      
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1920, 1080)), 
            child: LoginPage(auth: MockAuthService()),
          ),
          routes: {
            '/question': (context) => Question(),
          },
        ),
      );

      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');

      await tester.enterText(emailField, '27946228@example.com');
      await tester.enterText(passwordField, 'Test123!');
      
      final stopwatch = Stopwatch()..start();
      
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      
      stopwatch.stop();
      final loginNavigationTime = stopwatch.elapsedMilliseconds;

      expect(find.byType(Question), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
      
      results['Login Process'] = loginNavigationTime.toDouble();
      
      expect(loginNavigationTime, lessThan(1500));
    });
    


    testWidgets('Register', (
      WidgetTester tester) async {
      final mockAuthService = MockAuthService();
      final stopwatch = Stopwatch()..start();
      
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1920, 1080)),
            child: RegisterPage(authService: mockAuthService),
          ),
        ),
      );
      
      String uniqueEmail = generateUniqueEmail();
      String uniqueUsername = generateUniqueUsername();
      
      await tester.enterText(find.widgetWithText(TextField, 'Email'), uniqueEmail);
      await tester.enterText(find.widgetWithText(TextField, 'Username (4-12 characters)'), uniqueUsername);
      await tester.enterText(find.widgetWithText(TextField, 'School Year (1-6)'), '3');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'Test123!');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'Test123!');
      
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      await tester.tap(registerButton);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Question(),
        ),
      );
      
      expect(find.byType(Question), findsOneWidget);
      
      expect(MockAuthService.registeredEmails.contains(uniqueEmail), isTrue);
      expect(MockAuthService.registeredUsernames.contains(uniqueUsername), isTrue);
      
      stopwatch.stop();
      final registerTime = stopwatch.elapsedMilliseconds;
      
      results['Register Process'] = registerTime.toDouble();
      
      expect(registerTime, lessThan(2000));
    });



    testWidgets('Faq search', (
      WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: FAQPage()));
      await tester.pumpAndSettle();
      
      int faqCount = tester.widgetList<QAItem>(find.byType(QAItem)).length;
      expect(faqCount, 6);
      
      final searchField = find.byType(TextField);
      final searchStopwatch = Stopwatch()..start();
      await tester.enterText(searchField, 'q');
      
      int frameCount = 0;
      while (++frameCount <= 120) {
        await tester.pump();
        int currentCount = tester.widgetList<QAItem>(find.byType(QAItem)).length;
        if (currentCount != faqCount) {
          faqCount = currentCount;
          break;
        }
      }
      
      searchStopwatch.stop();
      expect(faqCount, 2);
      results['FAQ Search Response'] = searchStopwatch.elapsedMilliseconds.toDouble();
      
      final clearButton = find.text('Clear');
      final clearStopwatch = Stopwatch()..start();
      await tester.tap(clearButton);
      
      frameCount = 0;
      int searchResultCount = faqCount;
      while (++frameCount <= 120) {
        await tester.pump();
        int currentCount = tester.widgetList<QAItem>(find.byType(QAItem)).length;
        if (currentCount != searchResultCount) {
          faqCount = currentCount;
          break;
        }
      }
      
      clearStopwatch.stop();
      expect(faqCount, 6);
      results['FAQ Clear Response'] = clearStopwatch.elapsedMilliseconds.toDouble();
    });




testWidgets('Launch email', (
  WidgetTester tester) async {
  tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
  tester.binding.window.devicePixelRatioTestValue = 1.0;
  addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  
  MockEmail.reset();
  
  final aboutPage = AboutPage(
    canLaunchUrlOverride: MockEmail.canLaunchUrl,
    launchUrlOverride: MockEmail.launchUrl
  );
  
  await tester.pumpWidget(MaterialApp(home: aboutPage));
  
  final stopwatch = Stopwatch()..start();
  
  (tester.widget(find.byType(AboutPage)) as AboutPage).launchEmailForTest();
  await tester.pumpAndSettle();
  
  stopwatch.stop();
  
  expect(MockEmail.lastLaunchedUrl, startsWith('mailto:'));
  
  results['Email Launch'] = stopwatch.elapsedMilliseconds.toDouble();
});



    

testWidgets('Change details', (
  WidgetTester tester) async {
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final mockAuthService = MockAuthService();
  final String uniqueUsername = generateUniqueUsername();

  final testUser = FakeUser(
    uid: 'test-user-id',
    email: '1234321@example.com',
    username: 'testuser',
    schoolYear: 3,
  );

  final userData = {
    'uid': 'test-user-id',
    'email': '1234321@example.com',
    'username': 'testuser',
    'schoolYear': 3,
    'advancedMode': false,
    'correctCount': 10,
    'daysInRow': 5,
    'highestDaysInRow': 7,
  };

  MockAuthService.addUsername('testuser');
  expect(MockAuthService.registeredUsernames.contains('testuser'), isTrue);

  await tester.pumpWidget(
    MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      home: ProfilePage(
        testUserData: userData,
        authService: mockAuthService,
        scaffoldMessengerKey: scaffoldKey,
        testUser: testUser,
        onInformationUpdated: (bool success) {
        },
      ),
    )
  );

  await tester.pumpAndSettle();

  expect(find.text('testuser'), findsOneWidget);
  expect(find.text('3'), findsOneWidget);

  await tester.tap(find.widgetWithText(ElevatedButton, "   Update Profile   "));
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, 'Update Username'), uniqueUsername);
  await tester.enterText(find.widgetWithText(TextField, 'Update School Year'), '4');
 
  final stopwatch = Stopwatch()..start();

  await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
  await tester.pumpAndSettle();
  
  expect(find.text('Information updated successfully'), findsOneWidget);
  
  stopwatch.stop();

  expect(find.text('4'), findsOneWidget);
  expect(find.text(uniqueUsername), findsOneWidget);

    results['Profile Update'] = stopwatch.elapsedMilliseconds.toDouble();
  
  expect(stopwatch.elapsedMilliseconds, lessThan(1500));

});




testWidgets('Change password', (
  WidgetTester tester) async {
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  
  final testUser = PasswordCheckingFakeUser(
    correctPassword: 'Test123!',
    uid: 'test-user-id',
    email: '1234321@example.com',
    username: 'testuser',
    schoolYear: 3,
  );
  
  final userData = {
    'uid': 'test-user-id',
    'email': '1234321@example.com',
    'username': 'testuser',
    'schoolYear': 3,
    'advancedMode': false,
    'correctCount': 10,
    'daysInRow': 5,
    'highestDaysInRow': 7,
  };
  
  await tester.pumpWidget(
    MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      home: ProfilePage(
        testUserData: userData,
        testUser: testUser,
        scaffoldMessengerKey: scaffoldKey,
      ),
    )
  );
  
  await tester.pumpAndSettle();
  
  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").first);
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, 'Current Password'), 'Test123!');
  await tester.enterText(find.widgetWithText(TextField, 'New Password'), 'NewTest123!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm New Password'), 'NewTest123!');
  
  final stopwatch = Stopwatch()..start();
  
  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").last);
  await tester.pumpAndSettle();
  
  
  expect(find.byType(SnackBar), findsOneWidget);

    stopwatch.stop();

  expect(find.text('Password updated successfully'), findsOneWidget);
  
  results['Password Change'] = stopwatch.elapsedMilliseconds.toDouble();
  expect(stopwatch.elapsedMilliseconds, lessThan(1500));
});





    testWidgets('Advanced mode', (
      WidgetTester tester) async {
      final testUserData = {
        'uid': 'test-user-id',
        'email': '1234321@example.com',
        'username': 'testuser',
        'schoolYear': 3,
        'advancedMode': false,
        'correctCount': 10,
        'daysInRow': 5,
        'highestDaysInRow': 7,
      };
      
      await tester.pumpWidget(
        MaterialApp(
          home: ProfilePage(
            testUserData: testUserData, 
          )
        )
      );
      
      final checkboxFinder = find.byType(Checkbox);
      expect(checkboxFinder, findsOneWidget);
      
      var checkbox = tester.widget<Checkbox>(checkboxFinder);
      expect(checkbox.value, false); 
      
      expect(find.text('3'), findsOneWidget);
      expect(find.text('3 + 1'), findsNothing);

  final stopwatch = Stopwatch()..start();

      await tester.tap(checkboxFinder);
      await tester.pump(); 
      
      checkbox = tester.widget<Checkbox>(checkboxFinder);
      expect(checkbox.value, true);
      expect(find.text('3'), findsNothing);
      expect(find.text('3 + 1'), findsOneWidget);
      
  stopwatch.stop();

  results['Advanced Mode'] = stopwatch.elapsedMilliseconds.toDouble();
  expect(stopwatch.elapsedMilliseconds, lessThan(1500));
    });





testWidgets('Questiongen', (WidgetTester tester) async {
  final testUser = FakeUser(
    uid: 'test-user-id',
    email: 'test@example.com',
    username: 'testuser',
    schoolYear: 1,
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
  
  final initialQuestionText = tester.widget<Text>(find.descendant(
    of: find.byType(Container),
    matching: find.byType(Text),
  ).first).data;
  
  final stopwatch = Stopwatch()..start();
  
  await tester.tap(find.byType(ElevatedButton).first);
  await tester.pumpAndSettle();
  
  await tester.tap(find.byType(ElevatedButton).first);
  await tester.pumpAndSettle();
  
  
  final newQuestionText = tester.widget<Text>(find.descendant(
    of: find.byType(Container),
    matching: find.byType(Text),
  ).first).data;
  
    stopwatch.stop();

  expect(newQuestionText, isNot(equals(initialQuestionText)));

    results['Question Generation'] = stopwatch.elapsedMilliseconds.toDouble();
  expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    
});



test('Summary', () {
  expect(results.length, 16);
  
  expect(results.containsKey('Intro Page'), isTrue);
  expect(results.containsKey('Login Page'), isTrue);
  expect(results.containsKey('Register Page'), isTrue);
  expect(results.containsKey('FAQ Page'), isTrue);
  expect(results.containsKey('About Page'), isTrue);
  expect(results.containsKey('Question Page'), isTrue);
  expect(results.containsKey('Profile Page'), isTrue);
  expect(results.containsKey('Login Process'), isTrue);
  expect(results.containsKey('Register Process'), isTrue);
  expect(results.containsKey('FAQ Search Response'), isTrue);
  expect(results.containsKey('FAQ Clear Response'), isTrue);
  expect(results.containsKey('Email Launch'), isTrue);
  expect(results.containsKey('Profile Update'), isTrue);
  expect(results.containsKey('Password Change'), isTrue);
  expect(results.containsKey('Advanced Mode'), isTrue);
  expect(results.containsKey('Question Generation'), isTrue);
  
  print('\nPerformance Summary:');
  results.forEach((operation, time) {
    print('$operation: ${time.toStringAsFixed(2)} ms');
  });
});


  });
}

