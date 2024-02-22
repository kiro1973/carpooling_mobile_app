import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
AuthService _auth=AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _auth.signOut();
              Navigator.pushReplacementNamed(context, '/');

            },
          ),
                    IconButton(
            icon: Icon(Icons.man),
            onPressed: () {              
              Navigator.pushNamed(context, '/userProfile');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('history')
            .doc(user?.uid)
            .collection('user_rides')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No rides available'));
          }

          var rides = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: rides.length,
            itemBuilder: (BuildContext context, int index) {
              var rideData = rides[index].data() as Map<String, dynamic>;
              print("history rideData$rideData");
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  onTap: () {
                    // Handle the onTap action
                  },
                  title: Column(
                    children: [
                      Text(
                        rideData['status'],
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text(' Time:${rideData['time']}'),
                    ],
                  ),
                  subtitle: Text(
                    'Driver: ${rideData['name']} \n From: ${rideData['from']} - To: ${rideData['to']} price: ${rideData['price']}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('history')
            .doc(user?.uid)
            .collection('user_rides')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the Future is still loading, return a loading indicator.
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error loading the data, display an error message.
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // If no data is available, display a message.
            return Center(child: Text('No rides available'));
          }

          // If the Future is complete and data is available, proceed.
          var rides = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: rides.length,
            itemBuilder: (BuildContext context, int index) {
              var rideData = rides[index].data() as Map<String, dynamic>;
              print("history rideData$rideData");
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  onTap: () {
                    // Handle the onTap action
                  },
                  title: Column(
                    children: [
                      Text(
                        rideData['status'],
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text(' Time:${rideData['time']}'),
                    ],
                  ),
                  subtitle: Text(
                    'Driver: ${rideData['name']} \n From: ${rideData['from']} - To: ${rideData['to']} price: ${rideData['price']}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
*/



/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_service.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('history')
          .doc(AuthService().getCurrentUser()) // Replace 'uid' with the actual user's UID
          .collection('user_rides')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading data: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No data available');
        }

        var rides = snapshot.data!.docs.map((doc) => doc.data()).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('History'),
          ),
          body: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: rides.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/trackRide', arguments: {
                      "name": rides[index]['name'],
                      "from": rides[index]['from'],
                      "to": rides[index]['to'],
                      "Time": rides[index]['Time'],
                      "price": rides[index]['price'],
                      "Date": rides[index]['Date'],
                      "status": rides[index]['status'],
                    });
                  },
                  title: Column(
                    children: [
                      Text(
                        rides[index]['status'],
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text('${rides[index]['Date']} Time:${rides[index]['Time']}'),
                    ],
                  ),
                  subtitle: Text(
                    'Driver: ${rides[index]['name']} \n From: ${rides[index]['from']} - To: ${rides[index]['to']} price: ${rides[index]['price']}',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

*/