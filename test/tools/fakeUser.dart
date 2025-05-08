import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:project/pages/authentication/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';



class FakeUser implements User {
  @override
  final String uid;
  
  @override
  final String email;
  
  @override
  String? displayName;
  
  final String username;
  final int schoolYear;
  bool advancedMode;
  final int correctCount;
  final int daysInRow;
  final int highestDaysInARow;
  final DateTime? lastResetTimestamp;
  
  FakeUser({
    required this.uid,
    required this.email,
    required this.username,
    required this.schoolYear,
    this.advancedMode = false,
    this.correctCount = 0,
    this.daysInRow = 0,
    this.highestDaysInARow = 0,
    this.lastResetTimestamp,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'schoolYear': schoolYear,
      'advancedMode': advancedMode,
      'correctCount': correctCount,
      'daysInRow': daysInRow,
      'highestDaysInARow': highestDaysInARow,
      'lastResetTimestamp': lastResetTimestamp?.millisecondsSinceEpoch,
    };
  }
  
  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) async {
    return FakeUserCredential(this);
  }
  
  @override
  Future<void> updatePassword(String newPassword) async {}
  
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}




class PasswordCheckingFakeUser extends FakeUser {
  String correctPassword;
  
  PasswordCheckingFakeUser({
    required this.correctPassword,
    required String uid,
    required String email,
    required String username,
    required int schoolYear,
    bool advancedMode = false,
    int correctCount = 0,
    int daysInRow = 0,
    int highestDaysInARow = 0,
    DateTime? lastResetTimestamp,
  }) : super(
    uid: uid,
    email: email,
    username: username,
    schoolYear: schoolYear,
    advancedMode: advancedMode,
    correctCount: correctCount,
    daysInRow: daysInRow,
    highestDaysInARow: highestDaysInARow,
    lastResetTimestamp: lastResetTimestamp,
  );
  
  @override
  Future<UserCredential> reauthenticateWithCredential(AuthCredential credential) async {
    if (credential is EmailAuthCredential) {
      final passwordField = (credential as dynamic).password;
      
      if (passwordField != correctPassword) {
        throw FirebaseAuthException(
          code: 'wrong-password',
        );
      }
    }
    return FakeUserCredential(this);
  }
  
  @override
  Future<void> updatePassword(String newPassword) async {
    correctPassword = newPassword;
    MockAuthService.userPasswords[email] = newPassword;
  }
}




class FakeUserCredential implements UserCredential {
  @override
  final User user;
  
  @override
  final AdditionalUserInfo? additionalUserInfo = null;
  
  @override
  final AuthCredential? credential = null;
  
  FakeUserCredential(this.user);
}



class MockDocumentSnapshotStreamController {
  final StreamController<dynamic> _controller = StreamController<dynamic>.broadcast();
  
  Stream<dynamic> get stream => _controller.stream;
  
  void add(dynamic value) {
    _controller.add(value);
  }
  
  void close() {
    _controller.close();
  }
}



class MockAuthService extends AuthService {
  User? _mockUser;
  final MockDocumentSnapshotStreamController _userDataStreamController = MockDocumentSnapshotStreamController();
  
  static const String _emailsFilePath = 'test_registered_emails.json';
  static const String _usernamesFilePath = 'test_registered_usernames.json';
  
  static Set<String>? _registeredEmails;
  static Set<String>? _registeredUsernames;
  static Map<String, String> userPasswords = {};
  
  static Set<String> get registeredEmails {
    if (_registeredEmails == null) {
      _registeredEmails = _loadSetFromFile(_emailsFilePath);
    }
    return _registeredEmails!;
  }
  
  static Set<String> get registeredUsernames {
    if (_registeredUsernames == null) {
      _registeredUsernames = _loadSetFromFile(_usernamesFilePath);
    }
    return _registeredUsernames!;
  }
  



  static Set<String> _loadSetFromFile(String filePath) {
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        final jsonString = file.readAsStringSync();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((item) => item.toString()).toSet();
      }
    } catch (e) {
      print('Error loading data from file');
    }
    return <String>{};
  }


  
  static void _saveSetToFile(Set<String> data, String filePath) {
    try {
      final file = File(filePath);
      final jsonString = jsonEncode(data.toList());
      file.writeAsStringSync(jsonString);
    } catch (e) {
      print('Error saving data to file');
    }
  }
  


  static void addEmail(String email) {
    registeredEmails.add(email);
    _saveSetToFile(registeredEmails, _emailsFilePath);
  }
  

  static void addUsername(String username) {
    registeredUsernames.add(username);
    _saveSetToFile(registeredUsernames, _usernamesFilePath);
  }
  

  static void registerUser(String email, String username, String password) {
    addEmail(email);
    addUsername(username);
    userPasswords[email] = password;
  }
  

  void emitUserData(Map<String, dynamic> data) {
    _userDataStreamController.add(_createMockDocSnapshot(data));
  }
  

  dynamic _createMockDocSnapshot(Map<String, dynamic> data) {
    return _MockDocumentSnapshot(data);
  }
  
  Stream<dynamic> get userDataStream => _userDataStreamController.stream;
  



  @override
  Future<User?> signInWithEmail(String email, String password) async {
    if (registeredEmails.contains(email)) {
      String? storedPassword = userPasswords[email];
      if (storedPassword != null && storedPassword != password) {
        return null; 
      }
      
      _mockUser = FakeUser(
        uid: 'test-user-id',
        email: email,
        username: 'testuser',
        schoolYear: 3,
        advancedMode: false,
        correctCount: 10,
        daysInRow: 5,
        highestDaysInARow: 7,
        lastResetTimestamp: DateTime.now(),
      );
      
      emitUserData((_mockUser as FakeUser).toMap());
      
      return _mockUser;
    }
    return null;
  }
  



  @override
  Future<User?> registerWithEmail(
    String email, 
    String password, 
    String username, 
    int schoolYear
  ) async {
    if (registeredEmails.contains(email)) {
      return null;
    }
    
    if (registeredUsernames.contains(username)) {
      return null;
    }
    
    _mockUser = FakeUser(
      uid: 'test-user-id',
      email: email,
      username: username,
      schoolYear: schoolYear,
      advancedMode: false,
      correctCount: 0,
      daysInRow: 0,
      highestDaysInARow: 0,
      lastResetTimestamp: DateTime.now(),
    );
    
    registerUser(email, username, password);
    
    emitUserData((_mockUser as FakeUser).toMap());
    
    return _mockUser;
  }
  



  @override
  Future<bool> isUsernameUnique(String username) async {
    return !registeredUsernames.contains(username);
  }
  
  @override
  Future<bool> isEmailUnique(String email) async {
    return !registeredEmails.contains(email);
  }
  
  @override
  Future<void> signOut() async {
    _mockUser = null;
  }
  
  @override
  User? get currentUser => _mockUser;

  void dispose() {
    _userDataStreamController.close();
  }
}





class PasswordCheckingMockAuthService extends MockAuthService {
  final String correctPassword;
  
  PasswordCheckingMockAuthService(this.correctPassword);
  
  @override
  Future<User?> signInWithEmail(String email, String password) async {
    if (password == correctPassword) {
      _mockUser = PasswordCheckingFakeUser(
        uid: 'test-user-id',
        email: email,
        username: 'testuser',
        schoolYear: 3,
        advancedMode: false,
        correctCount: 10,
        daysInRow: 5,
        highestDaysInARow: 7,
        lastResetTimestamp: DateTime.now(),
        correctPassword: correctPassword,
      );
      
      emitUserData((_mockUser as FakeUser).toMap());
      
      return _mockUser;
    }
    return null;
  }
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



class _MockDocumentSnapshot {
  final Map<String, dynamic> _data;
  bool exists = true;

  _MockDocumentSnapshot(this._data);

  Map<String, dynamic> data() => _data;
}



class MockFirebasePlatform extends FirebasePlatform {
  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return FakeFirebaseApp(
      name ?? defaultFirebaseAppName,
      options ??
          const FirebaseOptions(
            apiKey: 'fake-api-key',
            appId: '1:1234567890:web:fake-web-app-id',
            messagingSenderId: 'fakeSenderId',
            projectId: 'fake-project-id',
            authDomain: 'fake-auth-domain.firebaseapp.com',
            storageBucket: 'fake-project-id.appspot.com',
          ),
    );
  }
  

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return FakeFirebaseApp(
      name,
      const FirebaseOptions(
        apiKey: 'fake-api-key',
        appId: 'fake-app-id',
        messagingSenderId: 'fake-messaging-id',
        projectId: 'fake-project-id',
      ),
    );
  }
  
  @override
  List<FirebaseAppPlatform> get apps => [app()];
}


class FakeFirebaseApp extends FirebaseAppPlatform {
  FakeFirebaseApp(String name, FirebaseOptions options)
      : super(name, options);
}

void setupFirebaseMocks() {
  FirebasePlatform.instance = MockFirebasePlatform();
}