import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'visa.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firestore_functions.dart';
class RideOrder {
  final String from;
  final String to;
  final String name;
  final double price;
  final String time;
  String paymentMethod;

  RideOrder({
    required this.from,
    required this.to,
    required this.name,
    required this.price,
    required this.time,
    required this.paymentMethod,
  });

  factory RideOrder.fromJson(Map<String, dynamic> json) {
    return RideOrder(
      from: json['from'],
      to: json['to'],
      name: json['name'],
      price: json['price'].toDouble(),
      time: json['time'],
      paymentMethod: json['paymentMethod'],
    );
  }
}

class PaymentAndOrderDetailsPage extends StatefulWidget {
  const PaymentAndOrderDetailsPage({Key? key}) : super(key: key);

  @override
  State<PaymentAndOrderDetailsPage> createState() =>
      _PaymentAndOrderDetailsPageState();
}

class _PaymentAndOrderDetailsPageState
    extends State<PaymentAndOrderDetailsPage> {

  //late RideOrder _rideOrder;
Map myreceiveddata={};
 String dropdownValue = 'Cash';
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // @override
  // void initState() {
  //   super.initState();

  //   _loadRideOrderData();
  // }

  // Future<void> _loadRideOrderData() async {
  //   final String jsonString = await DefaultAssetBundle.of(context)
  //       .loadString('assets/data.json');
  //   final Map<String, dynamic> jsonMap = json.decode(jsonString);
  //   final RideOrder rideOrder = RideOrder.fromJson(jsonMap);
  //   setState(() {
  //     _rideOrder = rideOrder;
  //   });
  // }
addRequest(String documentId, Map<String, dynamic> requestData) async {
  final DatabaseReference rideRef = FirebaseDatabase.instance.reference().child('rides').child(documentId);
User _user=_auth.currentUser!;

String userId= _user.uid;
  // Get the current user ID

  if (userId != null) {
    // Use the user ID as the request ID
    String requestId = userId;

    // Create a map for the new request
    Map<String, dynamic> newRequest = {
      requestId: {
        'payment_method': requestData['paymentMethod'] ?? '',
        'status': requestData['status'] ?? '',
      },
    };

    // Update the 'requests' field in the ride document
    await rideRef.child('requests').update(newRequest);
  } else {
    print('User not authenticated.'); // Handle the case where the user is not authenticated
  }
}



  @override
  Widget build(BuildContext context) {
    // if (_rideOrder == null) {
    //   return Container(child: Text('Loading order details...'));
    // }
myreceiveddata = ModalRoute.of(context)!.settings.arguments as Map; 
    return Scaffold(
      //backgroundColor: Colors.indigoAccent,
      appBar: AppBar(
        title: Text('Payment and Order Details'),
        actions: [IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
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
          ),],
      ),
      body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Order Details',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text('From:'),
                    SizedBox(width: 16.0),
                    Text(myreceiveddata['from']),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text('To:'),
                    SizedBox(width: 16.0),
                    Text(myreceiveddata['to']),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text('Driver Name:'),
                    SizedBox(width: 16.0),
                    Text(myreceiveddata['name']),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text('Price:'),
                    SizedBox(width: 16.0),
                    Text('\$${myreceiveddata['price']}'),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text('Time:'),
                    SizedBox(width: 16.0),
                    Text(myreceiveddata['time']),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 32.0),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text('Please select your payment method:'),
                SizedBox(height: 16.0),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    ElevatedButton(
                            onPressed: () {
                               Map<String, dynamic> requestData = {
                            "name": myreceiveddata['name'],
                            "from": myreceiveddata['from'],
                            "to": myreceiveddata['to'],
                            "time": myreceiveddata['time'],
                            "price": myreceiveddata['price'],
                            "paymentMethod":"credit card",
                            'status': 'pending',
};

// Call the function to add the request
                              addRequest(myreceiveddata['documentId'], requestData);
                              User _user=_auth.currentUser!;

                              String userId= _user.uid;
                              moveRideToFirestoreHistory(_user.uid, myreceiveddata['documentId'], requestData);
                              Navigator.pushReplacementNamed(context, '/payOrdTrack',arguments: requestData);
                              // Handle Cash button press
                              // ... (implement Cash logic)
                            
                              
                              // Handle credit card button press
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         CreditScreen(),
                              //   ),
                              // );
                            },
                            child: Text('Credit Card'),
                          ),
                          SizedBox(width: 16.0),

                          ElevatedButton(
                            onPressed: () {
                              Map<String, dynamic> requestData = {
                            "name": myreceiveddata['name'],
                            "from": myreceiveddata['from'],
                            "to": myreceiveddata['to'],
                            "time": myreceiveddata['time'],
                            "price": myreceiveddata['price'],
                            "paymentMethod":"cash",
                              'status': 'pending',
                              }; 
                              addRequest(myreceiveddata['documentId'], requestData);                                     
                              User _user=_auth.currentUser!;

                              String userId= _user.uid;
                              moveRideToFirestoreHistory(_user.uid, myreceiveddata['documentId'], requestData);
                              Navigator.pushNamed(context, '/payOrdTrack',arguments: requestData);
                              // Handle Cash button press
                              // ... (implement Cash logic)
                            },
                            child: Text('Cash'),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
),

// floatingActionButton: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ElevatedButton(
//             onPressed: () {
// Navigator.pushNamed(context, '/payOrdTrack');

//             },
//             child: Text('Confirm Payment and Track Ride'),
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


    );
  }
}
