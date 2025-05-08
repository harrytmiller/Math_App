import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/pages/faq.dart';
import 'package:project/pages/question/question.dart';
import 'package:project/pages/profile.dart'; 
import 'package:project/pages/about.dart';
import 'tools/fakeUser.dart';

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

class RouteObserver extends NavigatorObserver {
  Route? pushedRoute;
  
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    pushedRoute = route;
  }
  
  void reset() {
    pushedRoute = null;
  }
}

void main() {
  setupFirebaseMocks();

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  group('FAQPage Tests', () {
    testWidgets('Appbar', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FAQPage()));

      expect(find.byType(AppBar), findsOneWidget);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      
      expect(find.descendant(of: find.byType(AppBar), matching: find.text('Frequently Asked Questions')), findsOneWidget);
      expect(appBar.centerTitle, isTrue);
      expect(appBar.automaticallyImplyLeading, true);
      expect(appBar.backgroundColor, Colors.blue);
      expect(appBar.toolbarHeight, 70.0);
    });




    testWidgets('Back', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            pages: [
              MaterialPage(child: Question()),
              MaterialPage(child: FAQPage()),
            ],
            onPopPage: (route, result) {
              return route.didPop(result);
            },
          ),
        ),
      );
      
      expect(find.text('Frequently Asked Questions'), findsOneWidget);
      
      final backButtonFinder = find.byIcon(Icons.arrow_back);
      expect(backButtonFinder, findsOneWidget);
      
      await tester.tap(backButtonFinder);
      await tester.pumpAndSettle();
      
      expect(find.byType(Question), findsOneWidget);
    });





    testWidgets('Search', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FAQPage(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      int faqCount = 0;
      final listViewFinder = find.byType(ListView);
      Set<String> foundTitles = {};
      
      faqCount = tester.widgetList<QAItem>(find.byType(QAItem)).length;
      expect(faqCount, greaterThan(0));
      
      for (var widget in tester.widgetList<QAItem>(find.byType(QAItem))) {
        foundTitles.add(widget.title);
      }
      
      int previousCount = 0;
      while (foundTitles.length < 22 && previousCount != foundTitles.length) {
        previousCount = foundTitles.length;
        
        await tester.drag(listViewFinder, const Offset(0, -300));
        await tester.pumpAndSettle();
        
        for (var widget in tester.widgetList<QAItem>(find.byType(QAItem))) {
          foundTitles.add(widget.title);
        }
      }
      
      faqCount = foundTitles.length;
      expect(faqCount, 22);
      
      while (tester.any(find.byType(TextField)) == false) {
        await tester.drag(listViewFinder, const Offset(0, 300));
        await tester.pumpAndSettle();
      }
      
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'q');
      await tester.pumpAndSettle();
      
      faqCount = tester.widgetList<QAItem>(find.byType(QAItem)).length;
      expect(faqCount, 2);
      
      final clearButton = find.text('Clear');
      expect(clearButton, findsOneWidget);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();
      
      foundTitles.clear(); 
      
      for (var widget in tester.widgetList<QAItem>(find.byType(QAItem))) {
        foundTitles.add(widget.title);
      }
      
      previousCount = 0;
      while (foundTitles.length < 22 && previousCount != foundTitles.length) {
        previousCount = foundTitles.length;
        
        await tester.drag(listViewFinder, const Offset(0, -300));
        await tester.pumpAndSettle();
        
        for (var widget in tester.widgetList<QAItem>(find.byType(QAItem))) {
          foundTitles.add(widget.title);
        }
      }
      
      faqCount = foundTitles.length;
      expect(faqCount, 22);
    });






testWidgets('faqs', (
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FAQPage(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      final listViewFinder = find.byType(ListView);
      
      final Map<String, String> expectedFAQAnswers = {
        "How do I answer questions?": "To answer a question, first be on the homepage/Math club. Read the question above the image and the answers below the image. Press the answer you think is correct and acknowledge feedback. If you want to skip the timer for the next question to arrive, press any of the answers again.",
        "How does daily reset work?": "Every day at 12am, the score /10 will be set to 0. If the score doesn't equal 10 when the reset occurs, or if a reset didn't occur the previous day, then 'days in a row' will also be reset along with the score. If the score reaches 10/10, then days in a row will increase by 1.",
        "How does score and days in a row work?": "From the homepage/Math Club, you can see a score /10. The score resets at 12am every day. If your score does not reach 10/10 by the end of the day, or if you don't login on a day, then your current 'days in a row' will also be reset. Getting a score of 10/10 will cause days in a row to increase by 1. View your highest days in a row in the 'Profile' page.",
        "How can I monitor my daily score?": "From the homepage/Math Club, you can see a score /10, which resets at 12am every day. If your score does not reach 10/10 correct answers by the end of the day, or if you don't login, then your current 'days in a row' will also be reset. Getting a score of 10/10 will cause days in a row to increase by 1.",
        "How can I monitor days in a row?": "From the homepage/Math Club or Profile page, you can see 'days in a row' and score /10. The score resets at 12am every day. If your score does not reach 10/10 correct answers by the end of the day, then your current 'days in a row' will also be reset. Getting a score of 10/10 will cause days in a row to increase by 1.",
        "How can I monitor highest days in a row?": "From the homepage/Math Club, click the 'menu' and press 'Profile'. View your 'days in a row' and 'highest days in a row' there.",
        "How do I navigate between pages?": "From the homepage/Math Club, click the 'menu' in the top left corner and select the page you want. To return to the homepage, press the back arrow in the top left corner.",
        "How can I log out?": "From the homepage/Math Club, click the 'menu' in the top left corner and select 'Log Out'.",
        "How can I view my profile details?": "From the homepage/Math Club, click the 'menu' and press 'Profile'. View your details there.",
        "How can I change my profile details?": "From the homepage/Math Club, click the 'menu' and press 'Profile'. From the Profile page press 'update profile'.",
        "How does advanced mode work?": "From the homepage/Math Club, click the 'menu' and press 'Profile'. Activate 'Advanced Mode' in the settings.",
        "How can I change my password?": "From the homepage/Math Club, click the 'menu' and press 'Profile'. From there press 'Change Password' and follow the prompts.",
        "How can I contact the people behind this app?": "From the homepage/Math Club, click the 'menu' and press 'About Us'. Find our contact details there.",
        "Where can I find information about this app?": "For information about Math Club, visit the FAQ or About Us page.",
        "What is the purpose of math club?": "This app provides engaging age-specific questions based on the national curriculum.",
        "What are the benefits of this app?": "This app can be used at home or at school and provides age-specific questions based on the national curriculum.",
        "Can children use the app without adult supervision?": "Yes, the app is designed to be child-friendly and safe to use independently.",
        "Can the app be used in classrooms?": "Yes, the app is designed to be used both at home and in the classroom, as permitted by the teacher.",
        "Is there a cost to use the app?": "No, this app is free to use.",
        "Is the app suitable for all children?": "The app is suitable for children aged 5 and over, covering the primary maths curriculum from Year 1 to Year 6.",
        "How are questions generated?": "A random number between 0-1 determines which kind of question is called (+,-,x,÷,worded). Two numbers are generated to be used in the question, these two numbers are random within their range and their range is dependent on the user's learning age (school year + advanced mode). Note: worded questions are generated differently but do scale with difficulty as age increases.",
        "How is privacy protected on the app?": "The app complies with all relevant data protection regulations."
      };
      
      Set<String> verifiedFAQs = {};
      
      int maxScrolls = 30;
      int scrollCount = 0;
      
      while (verifiedFAQs.length < expectedFAQAnswers.length && scrollCount < maxScrolls) {
        final expansionTiles = find.byType(ExpansionTile);
        int initialVerifiedCount = verifiedFAQs.length;
        
        for (int i = 0; i < expansionTiles.evaluate().length; i++) {
          final tileFinder = expansionTiles.at(i);
          
          final titleWidget = tester.widget<ExpansionTile>(tileFinder);
          final textWidget = (titleWidget.title as Text);
          final titleText = textWidget.data!;
          
          if (verifiedFAQs.contains(titleText)) {
            continue;
          }
          
          final RenderBox renderBox = tester.renderObject(tileFinder);
          final position = renderBox.localToGlobal(Offset.zero);
          final size = renderBox.size;
          
          if (position.dy >= 0 && position.dy + size.height <= 600) {
            expect(expectedFAQAnswers.containsKey(titleText), isTrue);
            
            await tester.tap(tileFinder, warnIfMissed: false);
            await tester.pumpAndSettle();
            
            final expectedAnswer = expectedFAQAnswers[titleText]!;
            
            final hasExpectedAnswer = tester.any(find.textContaining(expectedAnswer.substring(0, 20), findRichText: true));
            
            expect(hasExpectedAnswer, isTrue);
            
            verifiedFAQs.add(titleText);
            
            await tester.tap(tileFinder, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        
        if (initialVerifiedCount == verifiedFAQs.length && scrollCount > 10 ||
            verifiedFAQs.length >= expectedFAQAnswers.length) {
          break;
        }
        
        await tester.drag(listViewFinder, const Offset(0, -200));
        await tester.pumpAndSettle();
        scrollCount++;
      }
      
      for (final title in expectedFAQAnswers.keys) {
        expect(verifiedFAQs.contains(title), isTrue);
      }
      
      expect(verifiedFAQs.length, expectedFAQAnswers.length);
      expect(verifiedFAQs.length, 22);
    });







testWidgets('Links', (
  WidgetTester tester) async {
  final observer = TestNavigatorObserver();
  
  await tester.pumpWidget(
    MaterialApp(
      navigatorObservers: [observer],
      home: FAQPage(),
      routes: {
        '/Profile': (context) => ProfilePage(),
        '/About Us': (context) => AboutPage(),
      },
    ),
  );
  
  await tester.pumpAndSettle();
  
  final NavigatorState navigator = tester.state(find.byType(Navigator));
  navigator.pushNamed('/About Us');
  await tester.pumpAndSettle();
  
  expect(find.byType(AboutPage), findsOneWidget);
  expect(find.byType(FAQPage), findsNothing);
  
  final backButton = find.byIcon(Icons.arrow_back);
  expect(backButton, findsOneWidget);
  await tester.tap(backButton);
  await tester.pumpAndSettle();
  
  expect(find.byType(FAQPage), findsOneWidget);
  expect(find.byType(AboutPage), findsNothing);
  
  navigator.pushNamed('/Profile');
  await tester.pumpAndSettle();
  
  expect(find.byType(ProfilePage), findsOneWidget);
  expect(find.byType(FAQPage), findsNothing);
  
  await tester.tap(backButton);
  await tester.pumpAndSettle();
  
  expect(find.byType(FAQPage), findsOneWidget);
  expect(find.byType(ProfilePage), findsNothing);
});


  });
}