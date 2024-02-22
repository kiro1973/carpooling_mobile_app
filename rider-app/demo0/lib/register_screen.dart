import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final AuthService _auth = AuthService();
  String _errorMessage = '';

  String? _validateEmail(String? value) {
    if (value == null || !value.endsWith('@eng.asu.edu.eg')) {
      setState(() {
        _errorMessage = 'Invalid email format';
      });
      return 'Invalid email format. Please use an email belonging to eng.asu.edu.eg';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              
              SizedBox(height: 10),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10),
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
                  final username = usernameController.text;
                  final phoneNumber = phoneNumberController.text;

                  if (_validateEmail(email) == null) {
                    User? user = await _auth.signUpWithEmailAndPassword(
                      email,
                      password,
                      username,
                      phoneNumber,
                    );

                    if (user != null) {
                      print('Sign up success: ${user.email}');
                      Navigator.pop(context);
                    } else {

                      print('Sign up failed');
                    }
                  } else {
                      setState(() {
                      _errorMessage = 'Sign up failed. Password must be at least 6 characters(include numbers) and email must follow eng asu';

                      });

                    print('Validation failed');
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}








/*import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final AuthService _auth = AuthService();
  String _errorMessage = '';

  String? _validateEmail(String? value) {
    if (value == null || !value.endsWith('@eng.asu.edu.eg')) {
      setState(() {
        _errorMessage = 'Invalid email format';
      });
      return 'Invalid email format. Please use an email belonging to eng.asu.edu.eg';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            if (_errorMessage.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            SizedBox(height: 10),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 10),
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
                final username = usernameController.text;
                final phoneNumber = phoneNumberController.text;

                if (_validateEmail(email) == null) {
                  User? user = await _auth.signUpWithEmailAndPassword(
                    email,
                    password,
                    username,
                    phoneNumber,
                  );

                  if (user != null) {
                    print('Sign up success: ${user.email}');
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      _errorMessage='signUp Failed password must be 6 char min';
                    });
                    print('Sign up failed');
                  }
                } else {
                  print('Validation failed');
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
*/