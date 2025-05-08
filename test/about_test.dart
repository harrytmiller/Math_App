import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/pages/about.dart';
import 'package:project/pages/question/question.dart';
import 'tools/fakeUser.dart';
import 'tools/mockEmail.dart';

class TestNavigatorObserver extends NavigatorObserver {
  final Function? onPop;
  
  TestNavigatorObserver({this.onPop});
  
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (onPop != null) {
      onPop!();
    }
  }
}

void main() {
  setupFirebaseMocks();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  group('AboutPage Tests', () {
    testWidgets('Appbar', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AboutPage()));

      expect(find.byType(AppBar), findsOneWidget);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      
      expect(find.descendant(of: find.byType(AppBar), matching: find.text('About Us')), findsOneWidget);
      expect(appBar.centerTitle, isTrue);
      expect(appBar.automaticallyImplyLeading, true);
      expect(appBar.backgroundColor, Colors.blue);
      expect(appBar.toolbarHeight, 70.0);
    });




    testWidgets('Container', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AboutPage()));
      
      final containerFinder = find.byType(Container);
      final container = tester.widget<Container>(find.byType(Container));
      final boxDecoration = container.decoration as BoxDecoration;
      
      final containerSize = tester.getSize(containerFinder);
      expect(containerSize.width, 675);
      expect(container.padding, EdgeInsets.all(16));
      expect(boxDecoration.color, Colors.lightBlue[100]);
      expect(boxDecoration.borderRadius, BorderRadius.circular(12));
    });





    testWidgets('Text', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: 
        AboutPage()));
      
      expect(find.text('About Us:'), findsOneWidget);
      expect(find.text('Welcome to Math Club, the ultimate maths companion designed specifically for students in years 1-6. Math Club Is a maths app designed to be used for a short time every day. The design enforces the little and often method of revision. It is self-paced and mostly intended for children to use alone. This app can help improve confidence answering questions and reinforce mathematical principles, helping children develop strong foundational skills.'),
        findsOneWidget);
    });




    testWidgets('Email', 
    (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = Size(1080, 1920);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      
      MockEmail.reset();
      
      final aboutPage = AboutPage(
        canLaunchUrlOverride: MockEmail.canLaunchUrl,
        launchUrlOverride: MockEmail.launchUrl
      );
      
      await tester.pumpWidget(MaterialApp(home: aboutPage));
      
      expect(find.text('Email:'), findsOneWidget);
      
      final expectedEmail = 'up2120303@myport.ac.uk';
      final emailText = find.text(expectedEmail);
      expect(emailText, findsOneWidget);
      
      final gestureDetector = find.ancestor(
        of: emailText, 
        matching: find.byType(GestureDetector)
      );
      expect(gestureDetector, findsOneWidget);
      
      (tester.widget(find.byType(AboutPage)) as AboutPage).launchEmailForTest();
      await tester.pumpAndSettle();
      
      expect(MockEmail.lastLaunchedUrl, equals('mailto:$expectedEmail'));
      expect(MockEmail.isValidEmailUrl(expectedEmail), isTrue);
    });






    testWidgets('Phone Number', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AboutPage()));
      
      expect(find.text('Phone Number:'), findsOneWidget);
      expect(find.text('+44 1234 567890'), findsOneWidget);
    });

    testWidgets('Postal Address', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AboutPage()));
      
      expect(find.text('Postal Address:'), findsOneWidget);
      expect(find.text('123 Tech Street, Innovation Park, London, UK, SW1A 1AA'), findsOneWidget);
    });
    


    
    testWidgets('Back', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            pages: [
              MaterialPage(child: Question()),
              MaterialPage(child: AboutPage()),
            ],
            onPopPage: (route, result) {
              return route.didPop(result);
            },
          ),
        ),
      );
      
      expect(find.text('About Us'), findsOneWidget);
      
      final backButtonFinder = find.byIcon(Icons.arrow_back);
      expect(backButtonFinder, findsOneWidget);
      
      await tester.tap(backButtonFinder);
      await tester.pumpAndSettle();
      
      expect(find.byType(Question), findsOneWidget);
    });
  });
}