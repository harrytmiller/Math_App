import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';

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



  group('Question Generation Tests', () {

    testWidgets('Learnage 1', (
      WidgetTester tester) async {
      int attempts = 0;
      const int maxAttempts = 3;
      bool testPassed = false;

      while (attempts < maxAttempts && !testPassed) {
        try {
          tester.binding.window.physicalSizeTestValue = Size(1280, 1080);
          tester.binding.window.devicePixelRatioTestValue = 1.0;

          final testUser = FakeUser(
            uid: 'test-user-id',
            email: 'test@example.com',
            username: 'testuser',
            schoolYear: 1,
            correctCount: 5,
            daysInRow: 3,
            advancedMode: false,
          );
          
          final Set<String> allQuestions = {};
          const String divisionSymbol = '÷';
          const String additionSymbol = '+';
          const String subtractionSymbol = '-';
          const String squaredSymbol = '²';
          const String cubedSymbol = '³';
          const String squareRootText = 'Square root of';
          
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
            
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
          }
          
          bool hasDivisionSymbol = allQuestions.any((question) => question.contains(divisionSymbol));
          bool hasAdditionSymbol = allQuestions.any((question) => question.contains(additionSymbol));
          bool hasSubtractionSymbol = allQuestions.any((question) => question.contains(subtractionSymbol));
          bool hasSquaredSymbol = allQuestions.any((question) => question.contains(squaredSymbol));
          bool hasCubedSymbol = allQuestions.any((question) => question.contains(cubedSymbol));
          bool hasSquareRootText = allQuestions.any((question) => question.contains(squareRootText));
          
          expect(hasDivisionSymbol, isFalse);
          expect(hasAdditionSymbol, isTrue);
          expect(hasSubtractionSymbol, isTrue);
          expect(hasSquaredSymbol, isFalse);
          expect(hasCubedSymbol, isFalse);
          expect(hasSquareRootText, isFalse);
          
          testPassed = true;
        } catch (e) {
          attempts++;
          if (attempts >= maxAttempts) {
            rethrow;
          }
        }
      }
    });



    testWidgets('Learnage 2', (
      WidgetTester tester) async {
      int attempts = 0;
      const int maxAttempts = 3;
      bool testPassed = false;

      while (attempts < maxAttempts && !testPassed) {
        try {
          tester.binding.window.physicalSizeTestValue = Size(1280, 1080);
          tester.binding.window.devicePixelRatioTestValue = 1.0;

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
          const String additionSymbol = '+';
          const String subtractionSymbol = '-';
          const String squaredSymbol = '²';
          const String cubedSymbol = '³';
          const String squareRootText = 'Square root of';
          
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
            
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
          }
          
          bool hasMultiplicationSymbol = allQuestions.any((question) => question.contains(multiplicationSymbol));
          bool hasDivisionSymbol = allQuestions.any((question) => question.contains(divisionSymbol));
          bool hasAdditionSymbol = allQuestions.any((question) => question.contains(additionSymbol));
          bool hasSubtractionSymbol = allQuestions.any((question) => question.contains(subtractionSymbol));
          bool hasSquaredSymbol = allQuestions.any((question) => question.contains(squaredSymbol));
          bool hasCubedSymbol = allQuestions.any((question) => question.contains(cubedSymbol));
          bool hasSquareRootText = allQuestions.any((question) => question.contains(squareRootText));
          
          expect(hasMultiplicationSymbol, isTrue);
          expect(hasDivisionSymbol, isTrue);
          expect(hasAdditionSymbol, isTrue);
          expect(hasSubtractionSymbol, isTrue);
          expect(hasSquaredSymbol, isFalse);
          expect(hasCubedSymbol, isFalse);
          expect(hasSquareRootText, isFalse);
          
          testPassed = true;
        } catch (e) {
          attempts++;
          if (attempts >= maxAttempts) {
            rethrow;
          }
        }
      }
    });



    testWidgets('Learnage 3', (
      WidgetTester tester) async {
      int attempts = 0;
      const int maxAttempts = 3;
      bool testPassed = false;

      while (attempts < maxAttempts && !testPassed) {
        try {
          tester.binding.window.physicalSizeTestValue = Size(1280, 1080);
          tester.binding.window.devicePixelRatioTestValue = 1.0;

          final testUser = FakeUser(
            uid: 'test-user-id',
            email: 'test@example.com',
            username: 'testuser',
            schoolYear: 2,
            correctCount: 5,
            daysInRow: 3,
            advancedMode: true,
          );
          
          final Set<String> allQuestions = {};
          const String multiplicationSymbol = 'x';
          const String divisionSymbol = '÷';
          const String additionSymbol = '+';
          const String subtractionSymbol = '-';
          const String squaredSymbol = '²';
          const String cubedSymbol = '³';
          const String squareRootText = 'Square root of';
          
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
            
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
          }
          
          bool hasMultiplicationSymbol = allQuestions.any((question) => question.contains(multiplicationSymbol));
          bool hasDivisionSymbol = allQuestions.any((question) => question.contains(divisionSymbol));
          bool hasAdditionSymbol = allQuestions.any((question) => question.contains(additionSymbol));
          bool hasSubtractionSymbol = allQuestions.any((question) => question.contains(subtractionSymbol));
          bool hasSquaredSymbol = allQuestions.any((question) => question.contains(squaredSymbol));
          bool hasCubedSymbol = allQuestions.any((question) => question.contains(cubedSymbol));
          bool hasSquareRootText = allQuestions.any((question) => question.contains(squareRootText));
          
          expect(hasMultiplicationSymbol, isTrue);
          expect(hasDivisionSymbol, isTrue);
          expect(hasAdditionSymbol, isTrue);
          expect(hasSubtractionSymbol, isTrue);
          expect(hasSquaredSymbol, isFalse);
          expect(hasCubedSymbol, isFalse);
          expect(hasSquareRootText, isFalse);
          
          testPassed = true;
        } catch (e) {
          attempts++;
          if (attempts >= maxAttempts) {
            rethrow;
          }
        }
      }
    });



    testWidgets('Learnage 4', (
      WidgetTester tester) async {
      int attempts = 0;
      const int maxAttempts = 3;
      bool testPassed = false;

      while (attempts < maxAttempts && !testPassed) {
        try {
          tester.binding.window.physicalSizeTestValue = Size(1280, 1080);
          tester.binding.window.devicePixelRatioTestValue = 1.0;

          final testUser = FakeUser(
            uid: 'test-user-id',
            email: 'test@example.com',
            username: 'testuser',
            schoolYear: 4,
            correctCount: 5,
            daysInRow: 3,
            advancedMode: false,
          );
          
          final Set<String> allQuestions = {};
          const String multiplicationSymbol = 'x';
          const String divisionSymbol = '÷';
          const String additionSymbol = '+';
          const String subtractionSymbol = '-';
          const String squaredSymbol = '²';
          const String cubedSymbol = '³';
          const String squareRootText = 'Square root of';
          
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
            
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
          }
          
          bool hasMultiplicationSymbol = allQuestions.any((question) => question.contains(multiplicationSymbol));
          bool hasDivisionSymbol = allQuestions.any((question) => question.contains(divisionSymbol));
          bool hasAdditionSymbol = allQuestions.any((question) => question.contains(additionSymbol));
          bool hasSubtractionSymbol = allQuestions.any((question) => question.contains(subtractionSymbol));
          bool hasSquaredSymbol = allQuestions.any((question) => question.contains(squaredSymbol));
          bool hasCubedSymbol = allQuestions.any((question) => question.contains(cubedSymbol));
          bool hasSquareRootText = allQuestions.any((question) => question.contains(squareRootText));
          
          expect(hasMultiplicationSymbol, isTrue);
          expect(hasDivisionSymbol, isTrue);
          expect(hasAdditionSymbol, isTrue);
          expect(hasSubtractionSymbol, isTrue);
          expect(hasSquaredSymbol, isFalse);
          expect(hasCubedSymbol, isFalse);
          expect(hasSquareRootText, isFalse);
          
          testPassed = true;
        } catch (e) {
          attempts++;
          if (attempts >= maxAttempts) {
            rethrow;
          }
        }
      }
    });



    testWidgets('Learnage 5', (
      WidgetTester tester) async {
      int attempts = 0;
      const int maxAttempts = 3;
      bool testPassed = false;

      while (attempts < maxAttempts && !testPassed) {
        try {
          tester.binding.window.physicalSizeTestValue = Size(1280, 1080);
          tester.binding.window.devicePixelRatioTestValue = 1.0;

          final testUser = FakeUser(
            uid: 'test-user-id',
            email: 'test@example.com',
            username: 'testuser',
            schoolYear: 4,
            correctCount: 5,
            daysInRow: 3,
            advancedMode: true,
          );
          
          final Set<String> allQuestions = {};
          const String multiplicationSymbol = 'x';
          const String divisionSymbol = '÷';
          const String additionSymbol = '+';
          const String subtractionSymbol = '-';
          const String squaredSymbol = '²';
          const String cubedSymbol = '³';
          const String squareRootText = 'Square root of';
          
          for (int i = 0; i < 100; i++) {
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
            
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
          }
          
          bool hasMultiplicationSymbol = allQuestions.any((question) => question.contains(multiplicationSymbol));
          bool hasDivisionSymbol = allQuestions.any((question) => question.contains(divisionSymbol));
          bool hasAdditionSymbol = allQuestions.any((question) => question.contains(additionSymbol));
          bool hasSubtractionSymbol = allQuestions.any((question) => question.contains(subtractionSymbol));
          bool hasSquaredSymbol = allQuestions.any((question) => question.contains(squaredSymbol));
          bool hasCubedSymbol = allQuestions.any((question) => question.contains(cubedSymbol));
          bool hasSquareRootText = allQuestions.any((question) => question.contains(squareRootText));
          
          expect(hasMultiplicationSymbol, isTrue);
          expect(hasDivisionSymbol, isTrue);
          expect(hasAdditionSymbol, isTrue);
          expect(hasSubtractionSymbol, isTrue);
          expect(hasSquaredSymbol, isTrue);
          expect(hasCubedSymbol, isTrue);
          expect(hasSquareRootText, isTrue);
          
          testPassed = true;
        } catch (e) {
          attempts++;
          if (attempts >= maxAttempts) {
            rethrow;
          }
        }
      }
    });



    testWidgets('Learnage 6', (
      WidgetTester tester) async {
      int attempts = 0;
      const int maxAttempts = 3;
      bool testPassed = false;

      while (attempts < maxAttempts && !testPassed) {
        try {
          tester.binding.window.physicalSizeTestValue = Size(1280, 1080);
          tester.binding.window.devicePixelRatioTestValue = 1.0;

          final testUser = FakeUser(
            uid: 'test-user-id',
            email: 'test@example.com',
            username: 'testuser',
            schoolYear: 5,
            correctCount: 5,
            daysInRow: 3,
            advancedMode: true,
          );
          
          final Set<String> allQuestions = {};
          const String multiplicationSymbol = 'x';
          const String divisionSymbol = '÷';
          const String additionSymbol = '+';
          const String subtractionSymbol = '-';
          const String squaredSymbol = '²';
          const String cubedSymbol = '³';
          const String squareRootText = 'Square root of';
          
          for (int i = 0; i < 100; i++) {
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
            
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
          }
          
          bool hasMultiplicationSymbol = allQuestions.any((question) => question.contains(multiplicationSymbol));
          bool hasDivisionSymbol = allQuestions.any((question) => question.contains(divisionSymbol));
          bool hasAdditionSymbol = allQuestions.any((question) => question.contains(additionSymbol));
          bool hasSubtractionSymbol = allQuestions.any((question) => question.contains(subtractionSymbol));
          bool hasSquaredSymbol = allQuestions.any((question) => question.contains(squaredSymbol));
          bool hasCubedSymbol = allQuestions.any((question) => question.contains(cubedSymbol));
          bool hasSquareRootText = allQuestions.any((question) => question.contains(squareRootText));
          
          expect(hasMultiplicationSymbol, isTrue);
          expect(hasDivisionSymbol, isTrue);
          expect(hasAdditionSymbol, isTrue);
          expect(hasSubtractionSymbol, isTrue);
          expect(hasSquaredSymbol, isTrue);
          expect(hasCubedSymbol, isTrue);
          expect(hasSquareRootText, isTrue);
          
          testPassed = true;
        } catch (e) {
          attempts++;
          if (attempts >= maxAttempts) {
            rethrow;
          }
        }
      }
    });



    testWidgets('Learnage 7', (
      WidgetTester tester) async {
      int attempts = 0;
      const int maxAttempts = 3;
      bool testPassed = false;

      while (attempts < maxAttempts && !testPassed) {
        try {
          tester.binding.window.physicalSizeTestValue = Size(1280, 1080);
          tester.binding.window.devicePixelRatioTestValue = 1.0;
          
          final testUser = FakeUser(
            uid: 'test-user-id',
            email: 'test@example.com',
            username: 'testuser',
            schoolYear: 6,
            correctCount: 5,
            daysInRow: 3,
            advancedMode: true,
          );
          
          final Set<String> allQuestions = {};
          const String divisionSymbol = '÷';
          const String additionSymbol = '+';
          const String subtractionSymbol = '-';
          const String squaredSymbol = '²';
          const String cubedSymbol = '³';
          const String squareRootText = 'Square root of';
          
          for (int i = 0; i < 100; i++) {
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
            
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
            await tester.tap(find.byType(ElevatedButton).first);
            await tester.pumpAndSettle();
          }
          
          bool hasDivisionSymbol = allQuestions.any((question) => question.contains(divisionSymbol));
          bool hasAdditionSymbol = allQuestions.any((question) => question.contains(additionSymbol));
          bool hasSubtractionSymbol = allQuestions.any((question) => question.contains(subtractionSymbol));
          bool hasSquaredSymbol = allQuestions.any((question) => question.contains(squaredSymbol));
          bool hasCubedSymbol = allQuestions.any((question) => question.contains(cubedSymbol));
          bool hasSquareRootText = allQuestions.any((question) => question.contains(squareRootText));
          
          expect(hasDivisionSymbol, isTrue);
          expect(hasAdditionSymbol, isTrue);
          expect(hasSubtractionSymbol, isTrue);
          expect(hasSquaredSymbol, isTrue);
          expect(hasCubedSymbol, isTrue);
          expect(hasSquareRootText, isTrue);
          
          testPassed = true;
        } catch (e) {
          attempts++;
          if (attempts >= maxAttempts) {
            rethrow;
          }
        }
      }
    });

    

    
  });
}