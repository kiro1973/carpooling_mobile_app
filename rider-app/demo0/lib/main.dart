// main.dart
import 'package:flutter/material.dart';
import 'RidesWithTime.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '/RideListView.dart';
import 'pay-review_screen.dart';
import 'History.dart';
import 'trackRide.dart';
import 'payOrdTrack.dart';
import 'payOrdTrack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'userProfile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/RideListView': (context) => RideListView(),
        '/pay-review': (context) => PaymentAndOrderDetailsPage(),
        '/history': (context) => History(),
        '/trackRide': (context) => TrackRide(),
        '/payOrdTrack': (context) => PayOrdTrack(),
        '/RidesWithTime': (context) => RidesWithTime(),
        '/userProfile': (context) => UserProfileScreen(),
        
      },
    );
  }
}


// // main.dart
// import 'package:flutter/material.dart';
// import 'login_screen.dart';
// import 'register_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Login Demo',
//       initialRoute: '/',
//       routes: {
//         '/': (context) => LoginScreen(),
//         '/register': (context) => RegisterScreen(),
//       },
//     );
//   }
// }











// // import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import '/RideListView.dart';

// // void main() {
// //   runApp(MaterialApp(
// //     title: 'Time App',
// //     initialRoute: '/main',
// //     routes: {'/main':(context)=> MyApp()},
// //   ));
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Ride List View',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: Text('Ride List View'),
// //         ),
// //         body: RideListView(),
// //       ),
// //     );
// //   }
// // }

