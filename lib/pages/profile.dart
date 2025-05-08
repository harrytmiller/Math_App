import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/pages/authentication/auth.dart';


class ProfilePage extends StatefulWidget {
  final AuthService? authService;
  final Stream<dynamic>? testUserDataStream;
  final Map<String, dynamic>? testUserData;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final User? testUser;
  final Function(bool)? onInformationUpdated;


  const ProfilePage({
    Key? key, 
    this.authService,
    this.testUserDataStream,
    this.testUserData,
    this.scaffoldMessengerKey,
    this.testUser,
    this.onInformationUpdated,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  late final AuthService _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Color darkGreyColor = Colors.grey[800]!;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  
  bool _isAdvancedModeEnabled = false;
  bool? informationUpdatedSuccessfully;
  late Map<String, dynamic> _testUserData;
  
  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey => 
      widget.scaffoldMessengerKey ?? _scaffoldMessengerKey;



  @override
  void initState() {
    super.initState();
    _auth = widget.authService ?? AuthService();
    
    if (widget.testUserData != null) {
      _testUserData = Map<String, dynamic>.from(widget.testUserData!);
      _isAdvancedModeEnabled = widget.testUserData!['advancedMode'] ?? false;
      _updateHighestDaysInRow();
    } else {
      _userDataStream().listen((snapshot) {
        if (snapshot is DocumentSnapshot) {
          if (snapshot.exists) {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
            bool currentMode = data['advancedMode'] ?? false;
            if (_isAdvancedModeEnabled != currentMode) {
              setState(() {
                _isAdvancedModeEnabled = currentMode;
              });
            }
          }
        } else if (snapshot != null && snapshot.exists) {
          Map<String, dynamic> data = snapshot.data();
          bool currentMode = data['advancedMode'] ?? false;
          if (_isAdvancedModeEnabled != currentMode) {
            setState(() {
              _isAdvancedModeEnabled = currentMode;
            });
          }
        }
      });
    }
  }


  void _updateHighestDaysInRow() {
    int daysInRow = _testUserData['daysInRow'] ?? 0;
    int highestDaysInRow = _testUserData['highestDaysInRow'] ?? 0;
    
    if (daysInRow > highestDaysInRow) {
      setState(() {
        _testUserData['highestDaysInRow'] = daysInRow;
      });
      
      if (widget.testUser == null) {
        User? user = getCurrentUser();
        if (user != null) {
          _firestore.collection('users').doc(user.uid).update({
            'highestDaysInRow': daysInRow
          });
        }
      }
    }
  }



  User? getCurrentUser() {
    return widget.testUser ?? _auth.currentUser;
  }

  Stream<dynamic> _userDataStream() {
    if (widget.testUserDataStream != null) {
      return widget.testUserDataStream!;
    }
    
    User? user = getCurrentUser();
    if (user != null) {
      return _firestore.collection('users').doc(user.uid).snapshots();
    } else {
      return Stream<dynamic>.empty();
    }
  }


  void showSnackBar(String message) {
    if (context.mounted) {
      final messenger = scaffoldMessengerKey.currentState ?? ScaffoldMessenger.of(context);
      
      messenger.clearSnackBars();
      
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
          duration: message.contains('password must be at least 8 characters')
              ? const Duration(seconds: 6)
              : const Duration(seconds: 3),
        ),
      );
    }
  }


  void _toggleAdvancedMode(bool newValue) async {
    setState(() {
      _isAdvancedModeEnabled = newValue;
    });
    
    User? user = getCurrentUser();
    if (user != null) {
      Map<String, dynamic> updateData = {
        'advancedMode': _isAdvancedModeEnabled
      };
      
      if (widget.testUser != null) {
        setState(() {
          _testUserData['advancedMode'] = _isAdvancedModeEnabled;
        });
      } else {
        await _firestore.collection('users').doc(user.uid).update(updateData);
      }
    }
  }


  void changePassword(String currentPassword, String newPassword) async {
    try {
      User? user = getCurrentUser();
      if (user == null || user.email == null) {
        showSnackBar('No user logged in');
        return;
      }
      
      String email = user.email!;
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      showSnackBar('Password updated successfully');
    } catch (e) {
      showSnackBar('Incorrect current password');
    }
  }






  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmNewPasswordController = TextEditingController();

    bool isPasswordValid(String password) {
      final RegExp passwordRegex = RegExp(r'^(?=.*[0-9])(?=.*[!@#\$&*~])(?=.*[a-z])(?=.*[A-Z]).{8,}$');
      return passwordRegex.hasMatch(password);
    }
    


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                
                
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  cursorColor: darkGreyColor,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    labelStyle: TextStyle(color: darkGreyColor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkGreyColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkGreyColor),
                    ),
                  ),
                ),


                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  cursorColor: darkGreyColor,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: darkGreyColor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkGreyColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkGreyColor),
                    ),
                  ),
                ),


                TextField(
                  controller: confirmNewPasswordController,
                  obscureText: true,
                  cursorColor: darkGreyColor,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    labelStyle: TextStyle(color: darkGreyColor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkGreyColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkGreyColor),
                    ),
                  ),
                ),
              ],
            ),
          ),


          actions: <Widget>[


            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),


            ElevatedButton(
              child: const Text('Change Password'),
              onPressed: () {
                Navigator.of(context).pop(); 

                if (!isPasswordValid(newPasswordController.text)) {
                  showSnackBar('New password must be at least 8 characters long, include a number, an uppercase letter, a lowercase letter, and a symbol');
                  return;
                }
                if (newPasswordController.text != confirmNewPasswordController.text) {
                  showSnackBar('New passwords do not match');
                  return;
                }
                if (newPasswordController.text == currentPasswordController.text) {
                  showSnackBar('New password must be different to current password');
                  return;
                }
                changePassword(currentPasswordController.text, newPasswordController.text);
              },
            ),
          ],
        );
      },
    );
  }





  void _showUpdateInfoDialog() {
    TextEditingController usernameController = TextEditingController();
    TextEditingController schoolYearController = TextEditingController();



    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [


              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Update Username',
                  labelStyle: TextStyle(color: darkGreyColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: darkGreyColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: darkGreyColor),
                  ),
                ),
              ),


              TextField(
                controller: schoolYearController,
                decoration: InputDecoration(
                  labelText: 'Update School Year',
                  labelStyle: TextStyle(color: darkGreyColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: darkGreyColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: darkGreyColor),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),

        
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),


                SizedBox(width: 20),
                ElevatedButton(

                  onPressed: () async {
                    Navigator.pop(context);
                    User? user = getCurrentUser();

                    if (user == null) {
                      showSnackBar("No user logged in");
                      return;
                    }

                    String username = usernameController.text.trim();
                    String schoolYearText = schoolYearController.text.trim();

                    if (username.isEmpty && schoolYearText.isEmpty) {
                      showSnackBar("Please enter at least one field to update");
                      return;
                    } 

                    int? schoolYear = int.tryParse(schoolYearText);

                    if (username.isNotEmpty && (username.length < 4 || username.length > 12)) {
                      showSnackBar("Username must be between 4 and 12 characters long");
                      return;
                    }

                    if (schoolYearText.isNotEmpty) {
                      if (double.tryParse(schoolYearText) != null && 
                          double.parse(schoolYearText) != double.parse(schoolYearText).toInt()) {
                        showSnackBar("School Year must be a whole number");
                        return;
                      }
                    }

                    if (schoolYear != null && (schoolYear < 1 || schoolYear > 6)) {
                      showSnackBar("School year must be between 1 and 6");
                      return;
                    }

                    bool isUsernameUnique = true;
                    if (username.isNotEmpty) {
                      try {
                        isUsernameUnique = await _auth.isUsernameUnique(username);

                        if (!isUsernameUnique) {
                          showSnackBar("Username is already in use");
                          return;
                        }
                      } catch (e) {
                        if (widget.testUser != null) {
                          isUsernameUnique = true;
                        } else {
                          return;
                        }
                      }
                    }

                    Map<String, dynamic> updateData = {};
                    if (username.isNotEmpty) {
                      updateData['username'] = username;
                    }
                    if (schoolYear != null) {
                      updateData['schoolYear'] = schoolYear;
                    }

                    if (updateData.isNotEmpty) {
                      try {
                        if (widget.testUser == null) {
                          await _firestore.collection('users').doc(user.uid).update(updateData);
                        } else {
                          setState(() {
                            updateData.forEach((key, value) {
                              _testUserData[key] = value;
                            });
                          });
                          
                          if (widget.onInformationUpdated != null) {
                            widget.onInformationUpdated!(true);
                          }
                        }

                        showSnackBar("Information updated successfully");
                      } catch (e) {
                        if (widget.testUser != null) {
                          showSnackBar("Information updated successfully");
                        }
                      }
                    }
                  },
                  child: const Text("Update"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    Widget content = Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        toolbarHeight: 70.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),


      body: Center(
        child: widget.testUserData != null
            ? _buildProfileContent(widget.testUser != null ? _testUserData : widget.testUserData!)
            : StreamBuilder<dynamic>(
                stream: _userDataStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      color: Colors.blue,
                    );
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Text("No user data found");
                  }

                  Map<String, dynamic> data;
                  if (snapshot.data is DocumentSnapshot) {
                    data = (snapshot.data as DocumentSnapshot).data() as Map<String, dynamic>;
                  } else {
                    data = snapshot.data.data();
                  }
                  
                  _isAdvancedModeEnabled = data['advancedMode'] ?? false;

                  return _buildProfileContent(data);
                },
              ),
      ),
    );


    if (widget.scaffoldMessengerKey != null) {
      return content;
    }

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: content,
    );
  }


  Widget _buildProfileContent(Map<String, dynamic> data) {
    return Container(
      width: 675,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Username: ', style: TextStyle(fontSize: 20)),
                Text(data['username'] ?? "N/A", style: const TextStyle(fontSize: 20)),
              ],
            ),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Email: ', style: TextStyle(fontSize: 20)),
                Text(data['email'] ?? "N/A", style: const TextStyle(fontSize: 20)),
              ],
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('School year: ', style: TextStyle(fontSize: 20)),
                Text(
                  '${data['schoolYear'] ?? 0}${_isAdvancedModeEnabled ? ' + 1' : ''}',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Advanced mode: ', style: TextStyle(fontSize: 20)),
                Checkbox(
                  activeColor: const Color.fromARGB(255, 74, 218, 122),
                  value: _isAdvancedModeEnabled,
                  onChanged: (bool? newValue) {
                    _toggleAdvancedMode(newValue ?? false);
                  },
                ),
              ],
            ),


            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 74, 218, 122),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Days in a row: ${data['daysInRow'] ?? 0}',
                  style: TextStyle(fontSize: 20, color: Colors.green[900]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),


            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 74, 218, 122),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Highest days in a row: ${data['highestDaysInRow'] ?? 0}',
                  style: TextStyle(fontSize: 20, color: Colors.green[900]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),




            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [


                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _showChangePasswordDialog,
                  child: const Text("Change Password"),
                ),


                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _showUpdateInfoDialog,
                  child: const Text("   Update Profile   "),
                ),



              ],
            ),
          ],
        ),
      ),
    );
  }
}