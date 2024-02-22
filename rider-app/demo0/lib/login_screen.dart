



import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/local_database_helper.dart';
import 'services/firestore_functions.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  mydatabaseclass mydb = mydatabaseclass();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  String _errorMessage = '';

  String? _validateEmail(String? value) {
    if (value == null || !value.endsWith('@eng.asu.edu.eg')) {
      setState(() {
        _errorMessage = 'Invalid email format';
      });
      return 'Invalid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: _validateEmail,
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                
                await _login(emailController.text, passwordController.text, false);
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                String? userId = user?.uid;
                Map<String, dynamic> userData = await getUserData(userId!);
                await _login(emailController.text, passwordController.text, true);
              },
              child: Text('Login As Tester to bypass time constraints'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to registration screen
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(String email,String password, bool isTester) async {
    if (_validateEmail(email) == null) {
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        print('Sign in success: ${user.email}');

        String? userId = user?.uid;
        Map<String, dynamic> userData = await getUserData(userId!);

        await mydb.writing('''INSERT INTO 'userProfile' 
          ('username', 'email','phoneNUmber') VALUES ("${userData['username']}","${user.email}","${userData['phoneNumber']}") ''');
                      

        if (isTester) {
          Navigator.pushReplacementNamed(context, '/RideListView', arguments: {"email": email});
          
        } else {
          Navigator.pushReplacementNamed(context, '/RidesWithTime', arguments: {"email": email, "user_id": user.uid});
        }
      } else {
        print('Sign in failed');
      }
    } else {
      print('Validation failed');
    }
  }

  
}




/* ////WORKING LOGINN
import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/local_database_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  String _errorMessage = '';

  String? _validateEmail(String? value) {
    if (value == null || !value.endsWith('@eng.asu.edu.eg')) {
      setState(() {
        _errorMessage = 'Invalid email format';
      });
      return 'Invalid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: _validateEmail,
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _login(emailController.text, passwordController.text, false);
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _login(emailController.text, passwordController.text, true);
              },
              child: Text('Login As Tester to bypass time constraints'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Navigate to registration screen
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(String email, String password, bool isTester) async {
    if (_validateEmail(email) == null) {
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        print('Sign in success: ${user.email}');
        //await LocalDatabaseHelper.saveEmail(email);

        // Fetch and store ride history from Firestore
        //await _auth.fetchAndStoreRideHistory(user.uid);

        if (isTester) {
          Navigator.pushReplacementNamed(context, '/RidesWithTime', arguments: {"email": email, "user_id": user.uid});
        } else {
          Navigator.pushReplacementNamed(context, '/RideListView', arguments: {"email": email});
        }
      } else {
        print('Sign in failed');
      }
    } else {
      print('Validation failed');
    }
  }
}
*/






// import 'package:flutter/material.dart';
// import 'register_screen.dart';
// import 'services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'services/local_database_helper.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final AuthService _auth = AuthService();
//   String _errorMessage = '';

//   String? _validateEmail(String? value) {
//     if (value == null || !value.endsWith('@eng.asu.edu.eg')) {
//       setState(() {
//         _errorMessage = 'Invalid email format';
//       });
//       return 'Invalid email';
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//               validator: _validateEmail,
//             ),
//             if (_errorMessage.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   _errorMessage,
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             SizedBox(height: 20),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 await _login(emailController.text, passwordController.text, false);
//               },
//               child: Text('Login'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await _login(emailController.text, passwordController.text, true);
//               },
//               child: Text('Login As Tester to bypass time constraints'),
//             ),
//             SizedBox(height: 10),
//             TextButton(
//               onPressed: () {
//                 // Navigate to registration screen
//                 Navigator.pushNamed(context, '/register');
//               },
//               child: Text('Don\'t have an account? Sign Up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _login(String email, String password, bool isTester) async {
//     if (_validateEmail(email) == null) {
//       User? user = await _auth.signInWithEmailAndPassword(email, password);

//       if (user != null) {
//         print('Sign in success: ${user.email}');
//         // old local db
//         //await LocalDatabaseHelper.saveEmail(email);

//         // Fetch and store ride history from Firestore
//         //await _auth.fetchAndStoreRideHistory(user.uid);
//         print("isTester:$isTester");
//         if (isTester) {
//           Navigator.pushReplacementNamed(context, '/RideListView', arguments: {"email": email});
//         } else {
//         Navigator.pushReplacementNamed(context, '/RidesWithTime', arguments: {"email": email, "user_id": user.uid});

//         }
//       } else {
//         print('Sign in failed');
//       }
//     } else {
//       print('Validation failed');
//     }
//   }
// }






/*import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/local_database_helper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  String _errorMessage = '';

  String? _validateEmail(String? value) {
    if (value == null || !value.endsWith('@eng.asu.edu.eg')) {
      setState(() {
        _errorMessage = 'Invalid email format';
      });
      return 'Invalid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: _validateEmail,
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;
                if (_validateEmail(email) == null) {
                  User? user = await _auth.signInWithEmailAndPassword(
                    email,
                    password,
                  );
                  if (user != null) {
                    print('Sign in success: ${user.email}');
                    // Save email to local SQLite database upon successful login
                    await LocalDatabaseHelper.saveEmail(email);
                    // Fetch and store ride history from Firestore
                    await _auth.fetchAndStoreRideHistory(user.uid);
                    Navigator.pushReplacementNamed(context, '/RideListView',arguments:{"email":email} );
                  } else {
                    print('Sign in failed');
                  }
                } else {
                  print('Validation failed');
                }
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;
                if (_validateEmail(email) == null) {
                  User? user = await _auth.signInWithEmailAndPassword(
                    email,
                    password,
                  );
                  if (user != null) {
                    print('Sign in success: ${user.email}');
                    // Save email to local SQLite database upon successful login
                    await LocalDatabaseHelper.saveEmail(email);
                    // Fetch and store ride history from Firestore
                    await _auth.fetchAndStoreRideHistory(user.uid);
                    Navigator.pushReplacementNamed(context, '/RidesWithTime',arguments: {"email":email,"user_id":user.uid} );
                  } else {
                    print('Sign in failed');
                  }
                } else {
                  print('Validation failed');
                }
              },
              child: Text('Login As Tester to bypass time constraints'),
            ),
            
            SizedBox(height: 10
            ),
            TextButton(
              onPressed: () {
                // Navigate to registration screen
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
*/






// import 'package:flutter/material.dart';
// import 'register_screen.dart';
// import 'services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'services/user_service.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final AuthService _auth = AuthService();
//   String _errorMessage = '';

//   String? _validateEmail(String? value) {
//     if (value == null || !value.endsWith('@eng.asu.edu.eg')) {
//       setState(() {
//         _errorMessage = 'Invalid email format';
//       });
//       return 'Invalid email';
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//               validator: _validateEmail,
//             ),
//             if (_errorMessage.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   _errorMessage,
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//               SizedBox(height: 20),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final email = emailController.text;
//                 final password = passwordController.text;
//                 if (_validateEmail(email) == null) {
//                   User? user = await _auth.signInWithEmailAndPassword(
//                     email,
//                     password,
//                   );
//                   if (user != null) {
//                     print('Sign in success: ${user.email}');
//                     Navigator.pushNamed(context, '/RideListView');
//                   } else {
//                     print('Sign in failed');
//                   }
//                 } else {
//                   print('Validation failed');
//                 }
//               },
//               child: Text('Login'),
//             ),
//             SizedBox(height: 10),
//             TextButton(
//               onPressed: () {
//                 // Navigate to registration screen
//                 Navigator.pushNamed(context, '/register');
//               },
//               child: Text('Don\'t have an account? Sign Up'),
//             ),
            
//           ],
//         ),
//       ),
//     );
//   }
// }








// login_screen.dart
// import 'package:flutter/material.dart';
// import 'register_screen.dart';
// import 'services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'services/user_service.dart';
// //import 'user.dart';
// class LoginScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final AuthService _auth = AuthService();
//   String _errorMessage = '';
// String? _validateEmail(String? value) {
//     if (value == null ||!value.endsWith('@eng.asu.edu.eg')) {
//        setState(() {
//         _errorMessage = 'Invalid email format. Please use @eng.asu.edu.eg';
//       });
//       return 'Invalid email format. Please use an email belonging to eng.asu.edu.eg';
//     }
//     return null;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextFormField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//               validator: _validateEmail,
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final email = emailController.text;
//                 final password = passwordController.text;
//                 if (_validateEmail(email) == null) {
//                   User? user = await _auth.signInWithEmailAndPassword(
//                     email,
//                     password,
//                   );
//                   if (user != null) {
//                     print('Sign in success: ${user.email}');
//                     Navigator.pushNamed(context, '/RideListView');
//                   } else {
//                     print('Sign in failed');
//                   }
//                 } else {
//                   print('Validation failed');
//                 }
                
// /*              WORKING WITH SHARED PREFERENCES
//                 // Validate login credentials
//                 // if (await validateCredentials(email, password)) {
//                 //   // Navigate to home screen or perform other actions on successful login
//                 //   print('Login Successful');
//                 //   Navigator.pushNamed(context, '/RideListView');
//                 // } else {
//                 //   // Display error message for invalid credentials
//                 //   print('Invalid Credentials');
//                 // }
//                 */
                
//               },
//               child: Text('Login'),
//             ),
//             SizedBox(height: 10),
//             TextButton(
//               onPressed: () {
//                 // Navigate to registration screen
//                 Navigator.pushNamed(context, '/register');
//               },
//               child: Text('Don\'t have an account? Sign Up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// /* USED with SHARED preferences
//   // Future<bool> validateCredentials(String email, String password) async {
//   //   final List<User> users = await UserService().getUsers();
//   //   final user = users.firstWhere(
//   //     (user) => user.email == email && user.password == password,
//   //     orElse: () => User(email: '', password: ''),
//   //   );

//   //   return user.email.isNotEmpty;
//   // }
//   */
// }







// // login_screen.dart
// import 'package:flutter/material.dart';
// import 'user_service.dart';
// import 'user.dart';

// class LoginScreen extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'email'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final email = emailController.text;
//                 final password = passwordController.text;

//                 // Validate login credentials
//                 if (await validateCredentials(email, password)) {
//                   // Navigate to home screen or perform other actions on successful login
//                   print('Login Successful');
//                 } else {
//                   // Display error message for invalid credentials
//                   print('Invalid Credentials');
//                 }
//               },
//               child: Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<bool> validateCredentials(String email, String password) async {
//     final List<User> users = await UserService().getUsers();
//     final user = users.firstWhere(
//       (user) => user.email == email && user.password == password,
//       orElse: () => User(email: '', password: ''),
//     );

//     return user.email.isNotEmpty;
//   }
// }





// // login_screen.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'register_screen.dart';
// import 'user.dart';

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'email'),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final email = emailController.text;
//                 final password = passwordController.text;

//                 // Check login credentials
//                 final bool isValid = await _validateCredentials(email, password);

//                 if (isValid) {
//                   // Navigate to the home screen or perform other actions
//                   // when the login is successful
//                   print('Login successful');
//                 } else {
//                   // Show an error message or perform other actions
//                   // when the login fails
//                   print('Login failed');
//                 }
//               },
//               child: Text('Login'),
//             ),
//             SizedBox(height: 20),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/register');
//               },
//               child: Text('Create an account'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<bool> _validateCredentials(String email, String password) async {
//     // Load user data from the JSON file
//     final List<User> users = await _loadUsers();

//     // Check if the user exists in the list
//     final user = users.firstWhere(
//       (user) => user.email == email && user.password == password,
//       orElse: () => null as User,
//     );

//     return user != null;
//   }

//   Future<List<User>> _loadUsers() async {
//     // Load users from the JSON file
//     final String data = await DefaultAssetBundle.of(context).loadString('assets/users.json');
//     final List<dynamic> jsonData = json.decode(data);
//     return jsonData.map((user) => User.fromJson(user)).toList();
//   }
// }