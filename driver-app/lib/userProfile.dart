import 'package:flutter/material.dart';
import 'services/local_database_helper.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? userData;
  mydatabaseclass mydb = mydatabaseclass();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userData = await mydb.getUserProfile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: userData != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Text(
                      // Display initials or a placeholder image if a profile picture is not available
                      userData!['username'].toUpperCase().substring(0, 2),
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Email:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('${userData!['email']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text(
                    'Username:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('${userData!['username']}', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text(
                    'Phone Number:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('${userData!['phoneNumber']}', style: TextStyle(fontSize: 16)),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor, // Use theme color
                ),
              ),
      ),
    );
  }
}
