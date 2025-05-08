import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project/pages/intro.dart';

void main() {
  group('IntroPage Tests', () {
    testWidgets('container',(
      WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
        home: const IntroPage(),
        onGenerateRoute: (settings) {
          if (settings.name == '/Login') {
            return MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('Login')));
          }
          return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Error: Unknown Route')));
        },
      ));

      expect(find.byType(Container), findsOneWidget);

      expect(
          find.byWidgetPredicate((widget) =>
              widget is Container &&
              widget.child is Column &&
              (widget.child as Column).children.any((child) =>
                  child is Text && child.data == 'Welcome to Math Club')),
          findsOneWidget);

      expect(
          find.byWidgetPredicate((widget) =>
              widget is Container &&
              widget.child is Column &&
              (widget.child as Column).children.any((child) =>
                  child is Text && child.data == 'Click anywhere to continue')),
          findsOneWidget);

      await tester.tap(find.byType(Container));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
    });






testWidgets('Back', (
  WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: IntroPage(),
    ),
  );
  
  expect(find.byType(IntroPage), findsOneWidget);
  
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
  
  expect(find.byType(IntroPage), findsOneWidget);
});







  });
}


