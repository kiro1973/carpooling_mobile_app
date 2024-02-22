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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  String _errorMessage = '';
  mydatabaseclass mydb = mydatabaseclass();
  String? _validateEmail(String? value) {
    if (value == null || !value.endsWith('@driver.eng.asu.edu.eg')) {
      setState(() {
        _errorMessage = 'Invalid login credentials';
      });
      return 'Invalid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Login'),
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
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
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
                    String? userId = user?.uid;
        Map<String, dynamic> userData = await getUserData(userId!);

        await mydb.writing('''INSERT INTO 'userProfile' 
          ('username', 'email','phoneNUmber') VALUES ("${userData['username']}","${user.email}","${userData['phoneNumber']}") ''');
                      
                    // Save email to local SQLite database upon successful login
                    //await LocalDatabaseHelper.saveEmail(email);
                    // Fetch and store ride history from Firestore
                    //await _auth.fetchAndStoreRideHistory(user.uid);
                    print("uid from login:${user.uid}");
                    //im-plement
                    Navigator.pushReplacementNamed(context, '/addRoute_selection',arguments: {"email":email,"driver_id":user.uid});
                  } else {
                    print('Sign in failed');
                    setState(() {
        _errorMessage = 'Invalid login credentials';
      });
                  }
                } else {
                  print('Validation failed');
                  setState(() {
        _errorMessage = 'Invalid login credentials';
      });
                }
              },
              child: Text('Driver Login '),
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
}
