import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/pages/authentication/login.dart';
import 'package:project/pages/authentication/register.dart';
import 'package:project/pages/question/question.dart';
import 'dart:math';
import 'tools/fakeUser.dart';


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

  


  group('Register Tests', () {
    testWidgets('Appbar',(
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RegisterPage()));

      expect(find.byType(AppBar), findsOneWidget);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));

      expect(find.descendant(of: find.byType(AppBar), matching: find.text('Register')), findsOneWidget);
      expect(appBar.centerTitle, isTrue);
      expect(appBar.automaticallyImplyLeading, false);
      expect(appBar.backgroundColor, Colors.blue);
      expect(appBar.toolbarHeight, 70.0);
    });





    testWidgets('login',(
    WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: RegisterPage()));

      final registerButton = find.text("Already have an account? Login");
      expect(registerButton, findsOneWidget);

      expect(find.ancestor(
        of: registerButton,
        matching: find.byType(TextButton),
      ), findsOneWidget);

      await tester.tap(registerButton);
      
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text('Login'), findsWidgets);
    });





    testWidgets('Typable fields', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RegisterPage()));

      final fields = find.byType(TextField);
      expect(fields, findsNWidgets(5)); 

      final emailField = find.widgetWithText(TextField, 'Email');
      final usernameField = find.widgetWithText(TextField, 'Username (4-12 characters)');
      final schoolYearField = find.widgetWithText(TextField, 'School Year (1-6)');
      final passwordField = find.widgetWithText(TextField, 'Password');
      final confirmPasswordField = find.widgetWithText(TextField, 'Confirm Password');

      expect(emailField, findsOneWidget);
      expect(usernameField, findsOneWidget);
      expect(schoolYearField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(confirmPasswordField, findsOneWidget);

      await tester.enterText(emailField, 'test@example.com');
      expect(find.text('test@example.com'), findsOneWidget);

      await tester.enterText(usernameField, 'testuser');
      expect(find.text('testuser'), findsOneWidget);

      await tester.enterText(schoolYearField, '3');
      expect(find.text('3'), findsOneWidget);

      await tester.enterText(passwordField, 'Password123');
      final passwordTextFieldWidget = tester.widget<TextField>(passwordField);
      expect(passwordTextFieldWidget.obscureText, isTrue);
      expect(find.text('Password123'), findsOneWidget);

      await tester.enterText(confirmPasswordField, 'Password123');
      final confirmPasswordTextFieldWidget = tester.widget<TextField>(confirmPasswordField);
      expect(confirmPasswordTextFieldWidget.obscureText, isTrue);
      expect(find.text('Password123'), findsNWidgets(2)); 
    });




    testWidgets('Register', (
      WidgetTester tester) async {
      final mockAuthService = MockAuthService();
      
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
      
      expect(find.text(uniqueEmail), findsOneWidget);
      expect(find.text(uniqueUsername), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Test123!'), findsNWidgets(2));
      
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      expect(registerButton, findsOneWidget);
      
      await tester.tap(registerButton);
      await tester.pumpAndSettle();
      
      expect(find.byType(Question), findsOneWidget);
      
      expect(MockAuthService.registeredEmails.contains(uniqueEmail), isTrue);
      expect(MockAuthService.registeredUsernames.contains(uniqueUsername), isTrue);
    });




    testWidgets('unique email', (
      WidgetTester tester) async {
      final mockAuthService = MockAuthService();
      
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1920, 1080)),
            child: RegisterPage(authService: mockAuthService),
          ),
        ),
      );

      final existingEmail = MockAuthService.registeredEmails.last;

      String uniqueUsername = generateUniqueUsername();
      
      await tester.enterText(find.widgetWithText(TextField, 'Email'), existingEmail);
      await tester.enterText(find.widgetWithText(TextField, 'Username (4-12 characters)'), uniqueUsername);
      await tester.enterText(find.widgetWithText(TextField, 'School Year (1-6)'), '3');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'Test123!');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'Test123!');
      
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      expect(registerButton, findsOneWidget);
      
      await tester.tap(registerButton);
      await tester.pumpAndSettle();
      
      expect(find.text('Email is already in use'), findsOneWidget);
      
      expect(find.byType(RegisterPage), findsOneWidget);
      expect(find.byType(Question), findsNothing);
    });





    testWidgets('unique username', (
      WidgetTester tester) async {
      final mockAuthService = MockAuthService();

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(1920, 1080)),
            child: RegisterPage(authService: mockAuthService),
          ),
        ),
      );

      final existingUsername = MockAuthService.registeredUsernames.last;

      String uniqueEmail = generateUniqueEmail();
      
      await tester.enterText(find.widgetWithText(TextField, 'Email'), uniqueEmail);
      await tester.enterText(find.widgetWithText(TextField, 'Username (4-12 characters)'), existingUsername);
      await tester.enterText(find.widgetWithText(TextField, 'School Year (1-6)'), '3');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'Test123!');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'Test123!');
      
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');
      expect(registerButton, findsOneWidget);
      
      await tester.tap(registerButton);
      await tester.pumpAndSettle();
      
      expect(find.text('Username is already in use'), findsOneWidget);
      
      expect(find.byType(RegisterPage), findsOneWidget);
      expect(find.byType(Question), findsNothing);
    });
    



    testWidgets('username length', (
  WidgetTester tester) async {
  final mockAuthService = MockAuthService();
  
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(1920, 1080)),
        child: RegisterPage(authService: mockAuthService),
      ),
    ),
  );

  await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
  await tester.enterText(find.widgetWithText(TextField, 'Username (4-12 characters)'),'abc');
  await tester.enterText(find.widgetWithText(TextField, 'School Year (1-6)'), '3');
  await tester.enterText(find.widgetWithText(TextField, 'Password'), 'Test123!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'Test123!');
  
  final registerButton = find.widgetWithText(ElevatedButton, 'Register');
  expect(registerButton, findsOneWidget);
  
  await tester.tap(registerButton);
  await tester.pumpAndSettle();
  
  expect(find.text('Username must be 4-12 characters long'), findsOneWidget);
  
  await tester.enterText(find.widgetWithText(TextField, 'Username (4-12 characters)'), 'abcdefghijklm');
  
  await tester.tap(registerButton);
  await tester.pumpAndSettle();
  
  expect(find.text('Username must be 4-12 characters long'), findsOneWidget);
  
  expect(find.byType(RegisterPage), findsOneWidget);
  expect(find.byType(Question), findsNothing);
});







    testWidgets('password', (
  WidgetTester tester) async {
  final mockAuthService = MockAuthService();
  
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(1920, 1080)),
        child: RegisterPage(authService: mockAuthService),
      ),
    ),
  );

  await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
  await tester.enterText(find.widgetWithText(TextField, 'Username (4-12 characters)'),'abcd');
  await tester.enterText(find.widgetWithText(TextField, 'School Year (1-6)'), '3');
  await tester.enterText(find.widgetWithText(TextField, 'Password'), 'Test123');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'Test123');
  
  final registerButton = find.widgetWithText(ElevatedButton, 'Register');
  expect(registerButton, findsOneWidget);
  
  await tester.tap(registerButton);
  await tester.pumpAndSettle();
  
  expect(find.text('Password must be at least 8 characters long, include a number, an uppercase letter, a lowercase letter, and a symbol'), findsOneWidget);
  
  await tester.enterText(find.widgetWithText(TextField, 'Password'), 'test123!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'test123!');

  await tester.tap(registerButton);
  await tester.pumpAndSettle();
  
  expect(find.text('Password must be at least 8 characters long, include a number, an uppercase letter, a lowercase letter, and a symbol'), findsOneWidget);
  
  await tester.enterText(find.widgetWithText(TextField, 'Password'), 'Testtest!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'Testtest!');

  await tester.tap(registerButton);
  await tester.pumpAndSettle();


  expect(find.text('Password must be at least 8 characters long, include a number, an uppercase letter, a lowercase letter, and a symbol'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'TEST123!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'TEST123!');

  await tester.tap(registerButton);
  await tester.pumpAndSettle();


  expect(find.text('Password must be at least 8 characters long, include a number, an uppercase letter, a lowercase letter, and a symbol'), findsOneWidget);
  


  await tester.enterText(find.widgetWithText(TextField, 'Password'), 'Test12!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'Test12!');

  await tester.tap(registerButton);
  await tester.pumpAndSettle();


  expect(find.text('Password must be at least 8 characters long, include a number, an uppercase letter, a lowercase letter, and a symbol'), findsOneWidget);
  



  expect(find.byType(RegisterPage), findsOneWidget);
  expect(find.byType(Question), findsNothing);
});







    testWidgets('confirm password', (
  WidgetTester tester) async {
  final mockAuthService = MockAuthService();
  
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(1920, 1080)),
        child: RegisterPage(authService: mockAuthService),
      ),
    ),
  );

  await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
  await tester.enterText(find.widgetWithText(TextField, 'Username (4-12 characters)'),'abcd');
  await tester.enterText(find.widgetWithText(TextField, 'School Year (1-6)'), '3');
  await tester.enterText(find.widgetWithText(TextField, 'Password'), 'Test123!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'Test123?');
  
  final registerButton = find.widgetWithText(ElevatedButton, 'Register');
  expect(registerButton, findsOneWidget);
  
  await tester.tap(registerButton);
  await tester.pumpAndSettle();
  
  expect(find.text('Passwords do not match'), findsOneWidget);
  


  expect(find.byType(RegisterPage), findsOneWidget);
  expect(find.byType(Question), findsNothing);
});







    testWidgets('school year', (
  WidgetTester tester) async {
  final mockAuthService = MockAuthService();
  
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(1920, 1080)),
        child: RegisterPage(authService: mockAuthService),
      ),
    ),
  );

  await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
  await tester.enterText(find.widgetWithText(TextField, 'Username (4-12 characters)'),'abcd');
  await tester.enterText(find.widgetWithText(TextField, 'School Year (1-6)'), '0');
  await tester.enterText(find.widgetWithText(TextField, 'Password'), 'Test123!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'Test123!');
  
  final registerButton = find.widgetWithText(ElevatedButton, 'Register');
  expect(registerButton, findsOneWidget);
  
  await tester.tap(registerButton);
  await tester.pumpAndSettle();
  
  expect(find.text('School Year must be between 1 and 6'), findsOneWidget);
  
  await tester.enterText(find.widgetWithText(TextField, 'School Year (1-6)'), '7');

  await tester.tap(registerButton);
  await tester.pumpAndSettle();

    expect(find.text('School Year must be between 1 and 6'), findsOneWidget);


  expect(find.byType(RegisterPage), findsOneWidget);
  expect(find.byType(Question), findsNothing);
});







    testWidgets('school year decimal', (
  WidgetTester tester) async {
  final mockAuthService = MockAuthService();
  
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(1920, 1080)),
        child: RegisterPage(authService: mockAuthService),
      ),
    ),
  );

  await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
  await tester.enterText(find.widgetWithText(TextField, 'Username (4-12 characters)'),'abcd');
  await tester.enterText(find.widgetWithText(TextField, 'School Year (1-6)'), '4.1');
  await tester.enterText(find.widgetWithText(TextField, 'Password'), 'Test123!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'Test123!');
  
  final registerButton = find.widgetWithText(ElevatedButton, 'Register');
  expect(registerButton, findsOneWidget);
  
  await tester.tap(registerButton);
  await tester.pumpAndSettle();


    expect(find.text('School Year must be a whole number'), findsOneWidget);


  expect(find.byType(RegisterPage), findsOneWidget);
  expect(find.byType(Question), findsNothing);
});









    testWidgets('email', (
  WidgetTester tester) async {
  final mockAuthService = MockAuthService();
  
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(1920, 1080)),
        child: RegisterPage(authService: mockAuthService),
      ),
    ),
  );

  await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@examplecom');
  await tester.enterText(find.widgetWithText(TextField, 'Username (4-12 characters)'),'abcd');
  await tester.enterText(find.widgetWithText(TextField, 'School Year (1-6)'), '2');
  await tester.enterText(find.widgetWithText(TextField, 'Password'), 'Test123!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'Test123!');
  final registerButton = find.widgetWithText(ElevatedButton, 'Register');
  expect(registerButton, findsOneWidget);
  
  await tester.tap(registerButton);
  await tester.pumpAndSettle();
  
  expect(find.text('Please enter a valid email address'), findsOneWidget);
  
  await tester.enterText(find.widgetWithText(TextField, 'Email'), 'testexample.com');

  await tester.tap(registerButton);
  await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address'), findsOneWidget);

  await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@.com');

  await tester.tap(registerButton);
  await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address'), findsOneWidget);

  await tester.enterText(find.widgetWithText(TextField, 'Email'), '@example.com');

  await tester.tap(registerButton);
  await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address'), findsOneWidget);

  await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.');

  await tester.tap(registerButton);
  await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address'), findsOneWidget);


await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.c');

  await tester.tap(registerButton);
  await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address'), findsOneWidget);



  expect(find.byType(RegisterPage), findsOneWidget);
  expect(find.byType(Question), findsNothing);
});





testWidgets('Back', (
    WidgetTester tester) async {

  bool didPop = false;
  final navigatorKey = GlobalKey<NavigatorState>();
  
  await tester.pumpWidget(
    MaterialApp(
      home: Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(child: LoginPage()),
          MaterialPage(child: RegisterPage()),
        ],
        onPopPage: (route, result) {
          didPop = true;
          return route.didPop(result);
        },
      ),
    ),
  );
  
  expect(find.byType(RegisterPage), findsOneWidget);
  
  final navigator = navigatorKey.currentState;
  
  navigator!.pop();
  await tester.pumpAndSettle();
  
  expect(didPop, true);
  expect(find.byType(LoginPage), findsOneWidget);
});



  });
}


