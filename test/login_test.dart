import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/pages/authentication/login.dart';
import 'package:project/pages/authentication/register.dart';
import 'package:project/pages/question/question.dart';
import 'package:project/pages/intro.dart';

import 'tools/fakeUser.dart';

void main() {
  setupFirebaseMocks();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  

  group('LoginPage Tests', () {
    testWidgets('Appbar',(
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage()));

      expect(find.byType(AppBar), findsOneWidget);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));

      expect(find.descendant(of: find.byType(AppBar), matching: find.text('Login')), findsOneWidget);
      expect(appBar.centerTitle, isTrue);
      expect(appBar.automaticallyImplyLeading, false);
      expect(appBar.backgroundColor, Colors.blue);
      expect(appBar.toolbarHeight, 70.0);
    });




    testWidgets('Typable fields', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage()));

      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);

      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);

      await tester.enterText(emailField, 'test@example.com');
      expect(find.text('test@example.com'), findsOneWidget);

      await tester.enterText(passwordField, 'password123');
      final passwordTextField = tester.widget<TextField>(passwordField);
      expect(passwordTextField.obscureText, isTrue);
      expect(find.text('password123'), findsOneWidget);
    });










    testWidgets('Incorrect login',(
      WidgetTester tester) async {

      await tester.pumpWidget(MaterialApp(home: LoginPage(auth: MockAuthService())));

      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');



      await tester.tap(loginButton);

      await tester.pump(); 
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Incorrect email or password'), findsOneWidget);

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text('Login'), findsWidgets); 

      await tester.pump(const Duration(seconds: 2));





      await tester.enterText(emailField, 'gicepa7720@dwriters.com');
      await tester.enterText(passwordField, 'wrongpassword');

      await tester.tap(loginButton);

      await tester.pump(); 
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Incorrect email or password'), findsOneWidget);

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text('Login'), findsWidgets); 

      await tester.pump(const Duration(seconds: 2));



      await tester.enterText(emailField, 'invalid');
      await tester.enterText(passwordField, '11111111!Aa');

      await tester.tap(loginButton);

      await tester.pump(); 
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Incorrect email or password'), findsOneWidget);

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text('Login'), findsWidgets); 
    });











    testWidgets('Successful login',(
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
      await tester.enterText(passwordField, 'Tesxt123!');

      
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(Question), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
    });





    testWidgets('Register',(
      WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LoginPage()));

    final registerButton = find.text("Don't have an account? Register");
    expect(registerButton, findsOneWidget);

    expect(find.ancestor(
      of: registerButton,
      matching: find.byType(TextButton),
    ), findsOneWidget);

    await tester.tap(registerButton);
    
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    
    await tester.pumpAndSettle();

    expect(find.byType(RegisterPage), findsOneWidget);
    

    expect(find.text('Register'), findsWidgets);
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
            MaterialPage(child: IntroPage()),
            MaterialPage(child: LoginPage()),
          ],
          onPopPage: (route, result) {
            didPop = true;
            return route.didPop(result);
          },
        ),
      ),
    );
    
    expect(find.byType(LoginPage), findsOneWidget);
    
    final navigator = navigatorKey.currentState;
    
    navigator!.pop();
    await tester.pumpAndSettle();
    
    expect(didPop, true);
    expect(find.byType(IntroPage), findsOneWidget);
    });
  });
}

