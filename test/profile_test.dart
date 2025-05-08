import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/pages/authentication/login.dart';
import 'package:project/pages/profile.dart';
import 'tools/fakeUser.dart';
import 'package:project/pages/question/question.dart';
import 'dart:math';


String generateUniqueUsername() {
  int random;
  String username;
  do {
    random = Random().nextInt(99999999);
    username = 'user$random';
  } while (MockAuthService.registeredUsernames.contains(username));
  return username;
}

class TestMockAuthService extends MockAuthService {
  final String takenUsername;
  
  TestMockAuthService(this.takenUsername);
  
  @override
  Future<bool> isUsernameUnique(String username) async {
    if (username == takenUsername) {
      return false;
    }
    return super.isUsernameUnique(username);
  }
}

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






  group('ProfilePage Tests', () {
    testWidgets('appbar', (
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
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      
      expect(find.descendant(of: find.byType(AppBar), matching: find.text('Profile')), findsOneWidget);
      expect(appBar.centerTitle, isTrue);
      expect(appBar.backgroundColor, Colors.blue);
      expect(appBar.toolbarHeight, 70.0);
    });




    
    testWidgets('loading indicator', (
      WidgetTester tester) async {
      final mockAuthService = MockAuthService();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ProfilePage(
            authService: mockAuthService,
            testUserDataStream: mockAuthService.userDataStream,
          ),
        ),
      );
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    




    testWidgets('Back', (
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
          home: Navigator(
            pages: [
              MaterialPage(child: Question()),
              MaterialPage(child: ProfilePage(
                testUserData: testUserData,
              )),
            ],
            onPopPage: (route, result) {
              return route.didPop(result);
            },
          ),
        ),
      );
      
      expect(find.text('Profile'), findsOneWidget);
      
      final backButtonFinder = find.byIcon(Icons.arrow_back);
      expect(backButtonFinder, findsOneWidget);
      
      await tester.tap(backButtonFinder);
      await tester.pumpAndSettle();
      
      expect(find.byType(Question), findsOneWidget);
    });





    testWidgets('Container', (
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
      
      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      
      expect(container.padding, const EdgeInsets.all(16));
      
      final boxDecoration = container.decoration as BoxDecoration;
      expect(boxDecoration.color, Colors.lightBlue[100]);
      expect(boxDecoration.borderRadius, BorderRadius.circular(12));
      final containerSize = tester.getSize(containerFinder);
      expect(containerSize.width.round(), 675);
    });





    testWidgets('User details', (
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
      
      expect(find.text('Username: '), findsOneWidget);
      expect(find.text('testuser'), findsOneWidget);
      
      expect(find.text('Email: '), findsOneWidget);
      expect(find.text('1234321@example.com'), findsOneWidget);
      
      expect(find.text('School year: '), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      
      expect(find.text('Days in a row: 5'), findsOneWidget);
      expect(find.text('Highest days in a row: 7'), findsOneWidget);
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
      await tester.tap(checkboxFinder);
      await tester.pump(); 
      
      checkbox = tester.widget<Checkbox>(checkboxFinder);
      expect(checkbox.value, true);
      expect(find.text('3'), findsNothing);
      expect(find.text('3 + 1'), findsOneWidget);
      
      await tester.tap(checkboxFinder);
      await tester.pump(); 
      
      checkbox = tester.widget<Checkbox>(checkboxFinder);
      expect(checkbox.value, false);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('3 + 1'), findsNothing);
    });





    testWidgets('Forms', (
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
      
      await tester.tap(find.widgetWithText(ElevatedButton, "Change Password"));
      await tester.pumpAndSettle();

      expect(find.text('Change Password'), findsExactly(3));

      await tester.enterText(find.widgetWithText(TextField, 'Current Password'), 'Test123!');
      await tester.enterText(find.widgetWithText(TextField, 'New Password'), 'Test123!');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm New Password'), 'Test123!');
      
      final passwordFields = tester.widgetList<TextField>(find.byType(TextField));
      for (final field in passwordFields) {
        expect(field.obscureText, true);
      }
      
      expect(find.text('Test123!'), findsNWidgets(3));
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Cancel'));
      await tester.pumpAndSettle();
      
      await tester.tap(find.widgetWithText(ElevatedButton, "   Update Profile   "));
      await tester.pumpAndSettle();
        expect(find.text('Update Profile'), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextField, 'Update Username'), 'Test123!');
      await tester.enterText(find.widgetWithText(TextField, 'Update School Year'), 'Test123!');
        
      final profileFields = tester.widgetList<TextField>(find.byType(TextField));
      for (final field in profileFields) {
        expect(field.obscureText, false);
      }

      expect(find.text('Test123!'), findsNWidgets(2));
      
      await tester.tap(find.widgetWithText(ElevatedButton, 'Cancel'));
      await tester.pumpAndSettle();
    });





    testWidgets('highest day in a row update', (
      WidgetTester tester) async {
      final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
      final mockAuthService = MockAuthService();
      
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
        'highestDaysInRow': 4,
      };
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldKey,
          home: ProfilePage(
            testUserData: userData,
            authService: mockAuthService,
            scaffoldMessengerKey: scaffoldKey,
            testUser: testUser,
          ),
        )
      );

      expect(find.text('Days in a row: 5'), findsOneWidget);
      expect(find.text('Highest days in a row: 5'), findsOneWidget);
    });




    testWidgets('details updated', (
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
  await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
  await tester.pumpAndSettle();
  
  expect(find.text('Information updated successfully'), findsOneWidget);
  expect(find.text('4'), findsOneWidget);
  expect(find.text(uniqueUsername), findsOneWidget);

});










testWidgets('1 details updated', (
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

  await tester.enterText(find.widgetWithText(TextField, 'Update School Year'), '4');
  await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
  await tester.pumpAndSettle();
  
  expect(find.text('Information updated successfully'), findsOneWidget);
  await tester.pumpAndSettle();
  expect(find.text('testuser'), findsOneWidget);
  expect(find.text('4'), findsOneWidget);



  await tester.tap(find.widgetWithText(ElevatedButton, "   Update Profile   "));
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, 'Update Username'), uniqueUsername);

  await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
  await tester.pumpAndSettle();
  
  expect(find.text('Information updated successfully'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  expect(find.text(uniqueUsername), findsOneWidget);
});








    testWidgets('School year', (
      WidgetTester tester) async {
      final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
      final mockAuthService = MockAuthService();
      
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

      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldKey,
          home: ProfilePage(
            testUserData: userData,
            authService: mockAuthService,
            scaffoldMessengerKey: scaffoldKey,
            testUser: testUser,
          ),
        )
      );
      
      await tester.pumpAndSettle();
      
      await tester.tap(find.widgetWithText(ElevatedButton, "   Update Profile   "));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, 'Update Username'), 'test123');
      await tester.enterText(find.widgetWithText(TextField, 'Update School Year'), '0');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
      
      await tester.pump(const Duration(milliseconds: 750));
      
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('School year must be between 1 and 6'), findsOneWidget);
      
      scaffoldKey.currentState?.clearSnackBars();
      await tester.pump(const Duration(seconds: 1));



      
      await tester.tap(find.widgetWithText(ElevatedButton, "   Update Profile   "));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, 'Update Username'), 'test123');
      await tester.enterText(find.widgetWithText(TextField, 'Update School Year'), '7');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
      
      await tester.pump(const Duration(milliseconds: 750));
      
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('School year must be between 1 and 6'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });





    testWidgets('School year decimal', (
      WidgetTester tester) async {
      final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
      final mockAuthService = MockAuthService();
      
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

      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldKey,
          home: ProfilePage(
            testUserData: userData,
            authService: mockAuthService,
            scaffoldMessengerKey: scaffoldKey,
            testUser: testUser,
          ),
        )
      );
      
      await tester.pumpAndSettle();
      

      
      await tester.tap(find.widgetWithText(ElevatedButton, "   Update Profile   "));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, 'Update Username'), 'test123');
      await tester.enterText(find.widgetWithText(TextField, 'Update School Year'), '5.2');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
      
      await tester.pump(const Duration(milliseconds: 750));
      
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('School Year must be a whole number'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });






    testWidgets('Username legnth', (
      WidgetTester tester) async {
      final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
      final mockAuthService = MockAuthService();
      
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

      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldKey,
          home: ProfilePage(
            testUserData: userData,
            authService: mockAuthService,
            scaffoldMessengerKey: scaffoldKey,
            testUser: testUser,
          ),
        )
      );
      
      await tester.pumpAndSettle();
      
      await tester.tap(find.widgetWithText(ElevatedButton, "   Update Profile   "));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, 'Update Username'), 'abc');
      await tester.enterText(find.widgetWithText(TextField, 'Update School Year'), '3');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
      
      await tester.pump(const Duration(milliseconds: 750));
      
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Username must be between 4 and 12 characters long'), findsOneWidget);
      
      scaffoldKey.currentState?.clearSnackBars();
      await tester.pump(const Duration(seconds: 1));




      await tester.tap(find.widgetWithText(ElevatedButton, "   Update Profile   "));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, 'Update Username'), 'abcdefghijklmn');
      await tester.enterText(find.widgetWithText(TextField, 'Update School Year'), '3');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
      
      await tester.pump(const Duration(milliseconds: 750));
      
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Username must be between 4 and 12 characters long'), findsOneWidget);
      expect(find.text('testuser'), findsOneWidget);
    });





    testWidgets('Username taken', (
      WidgetTester tester) async {
      final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
      
      final mockAuthService = TestMockAuthService('user10000000');
      
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
      expect(MockAuthService.registeredUsernames.contains('user10000000'), isTrue);

      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldKey,
          home: ProfilePage(
            testUserData: userData,
            authService: mockAuthService,
            scaffoldMessengerKey: scaffoldKey,
            testUser: testUser,
          ),
        )
      );

      
      await tester.pumpAndSettle();
      
      await tester.tap(find.widgetWithText(ElevatedButton, "   Update Profile   "));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, 'Update Username'), 'user10000000');
      await tester.enterText(find.widgetWithText(TextField, 'Update School Year'), '3');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
      
      await tester.pump(); 
      await tester.pump(const Duration(milliseconds: 800)); 
      
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Username is already in use'), findsOneWidget);
      
      expect(find.text('testuser'), findsOneWidget);
      expect(find.text('user10000000'), findsNothing);
    });






    testWidgets('No data', (
      WidgetTester tester) async {
      final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
      
      
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


      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldKey,
          home: ProfilePage(
            testUserData: userData,
            scaffoldMessengerKey: scaffoldKey,
            testUser: testUser,
          ),
        )
      );

      
      await tester.pumpAndSettle();
      
      await tester.tap(find.widgetWithText(ElevatedButton, "   Update Profile   "));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Update'));
      
      await tester.pump(); 
      await tester.pump(const Duration(milliseconds: 800)); 
      
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please enter at least one field to update'), findsOneWidget);
      
      expect(find.text('testuser'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

    });



testWidgets('Password changed', (
  WidgetTester tester) async {
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final initialPassword = 'Test123!';
  final newPassword = 'newTest123!';
  
  MockAuthService.registerUser('1234321@example.com', 'testuser', initialPassword);
  
  final testUser = PasswordCheckingFakeUser(
    correctPassword: initialPassword,
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
  
  final mockAuthService = MockAuthService();
  
  await tester.pumpWidget(
    MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      home: ProfilePage(
        testUserData: userData,
        testUser: testUser,
        authService: mockAuthService,
        scaffoldMessengerKey: scaffoldKey,
      ),
    )
  );
  
  await tester.pumpAndSettle();
  
  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").first);
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, 'Current Password'), initialPassword);
  await tester.enterText(find.widgetWithText(TextField, 'New Password'), newPassword);
  await tester.enterText(find.widgetWithText(TextField, 'Confirm New Password'), newPassword);
  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").last);
  await tester.pump(const Duration(milliseconds: 750));
  
  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('Password updated successfully'), findsOneWidget);
  
  scaffoldKey.currentState?.clearSnackBars();
  await tester.pump(const Duration(seconds: 1));
  
  expect(testUser.correctPassword, equals(newPassword));
  expect(MockAuthService.userPasswords['1234321@example.com'], equals(newPassword));
  
  await tester.pumpWidget(
    MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      home: LoginPage(
        auth: mockAuthService,
      ),
    )
  );
  
  await tester.pumpAndSettle();
  
  await tester.enterText(find.byType(TextField).first, '1234321@example.com');
  await tester.enterText(find.byType(TextField).last, initialPassword);
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
  
  expect(find.byType(LoginPage), findsOneWidget);
  
  await tester.enterText(find.byType(TextField).last, newPassword);
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pumpAndSettle();
  
  expect(find.byType(Question), findsOneWidget);
});



testWidgets('Password requirements', (
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
  await tester.enterText(find.widgetWithText(TextField, 'New Password'), 'test123!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm New Password'), 'test123!');
  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").last);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 750));
  
  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('New password must be at least 8 characters long, include a number, an uppercase letter, a lowercase letter, and a symbol'), findsOneWidget);
  
  scaffoldKey.currentState?.clearSnackBars();
  await tester.pump(const Duration(seconds: 1));




  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").first);
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, 'Current Password'), 'Test123!');
  await tester.enterText(find.widgetWithText(TextField, 'New Password'), 'Testtest!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm New Password'), 'Testtest!');
  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").last);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 750));
  
  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('New password must be at least 8 characters long, include a number, an uppercase letter, a lowercase letter, and a symbol'), findsOneWidget);

  scaffoldKey.currentState?.clearSnackBars();
  await tester.pump(const Duration(seconds: 1));




  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").first);
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, 'Current Password'), 'Test123!');
  await tester.enterText(find.widgetWithText(TextField, 'New Password'), 'TEST123!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm New Password'), 'TEST123!');
  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").last);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 750));
  
  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('New password must be at least 8 characters long, include a number, an uppercase letter, a lowercase letter, and a symbol'), findsOneWidget);

  scaffoldKey.currentState?.clearSnackBars();
  await tester.pump(const Duration(seconds: 1));





  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").first);
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, 'Current Password'), 'Test123!');
  await tester.enterText(find.widgetWithText(TextField, 'New Password'), 'Test1!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm New Password'), 'Test1!');
  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").last);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 750));
  
  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('New password must be at least 8 characters long, include a number, an uppercase letter, a lowercase letter, and a symbol'), findsOneWidget);

  scaffoldKey.currentState?.clearSnackBars();
  await tester.pump(const Duration(seconds: 1));
});




testWidgets('Passwords dont match', (
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
  await tester.enterText(find.widgetWithText(TextField, 'New Password'), 'Test1234!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm New Password'), 'test12345!');
  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").last);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 750));
  
  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('New passwords do not match'), findsOneWidget);
  scaffoldKey.currentState?.clearSnackBars();
  });








testWidgets('Incorrect password', (
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
  
  await tester.enterText(find.widgetWithText(TextField, 'Current Password'), 'Test12!');
  await tester.enterText(find.widgetWithText(TextField, 'New Password'), 'newTest123!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm New Password'), 'newTest123!');
  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").last);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 750));
  
  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('Incorrect current password'), findsOneWidget);
  scaffoldKey.currentState?.clearSnackBars();
});






testWidgets('New password same as old password', (
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
  await tester.enterText(find.widgetWithText(TextField, 'New Password'), 'Test123!');
  await tester.enterText(find.widgetWithText(TextField, 'Confirm New Password'), 'Test123!');
  await tester.tap(find.widgetWithText(ElevatedButton, "Change Password").last);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 750));
  
  expect(find.byType(SnackBar), findsOneWidget);
  expect(find.text('New password must be different to current password'), findsOneWidget);
  scaffoldKey.currentState?.clearSnackBars();

});





  });
}