import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/auth_service.dart';
class PaymentAndOrderDetailsPage extends StatefulWidget {
  const PaymentAndOrderDetailsPage({Key? key}) : super(key: key);

  @override
  State<PaymentAndOrderDetailsPage> createState() =>
      _PaymentAndOrderDetailsPageState();
}

class _PaymentAndOrderDetailsPageState
    extends State<PaymentAndOrderDetailsPage> {
  Map myreceiveddata = {};
String reqId='';
 Map<String,String> stateMap={"pending":"","approved":"start ride", "started":"finish ride"};
   Map<String,String> stateTransitions={"pending":"approved","approved":"started", "started":"completed"};
    final AuthService _auth = AuthService();


  Future<Map<String, dynamic>> fetchUserData(String userId) async {
  try {
    // Replace 'users' with the name of your collection
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
       print('DocumentSnapshot ${DocumentSnapshot}');
    if (documentSnapshot.exists) {
      // Access the 'username' and 'phone number' fields from the document
      String username = documentSnapshot['username'];
      String phoneNumber = documentSnapshot['phoneNumber'];

      // Return a map with 'username' and 'phoneNumber'
        print ("username: ${username}, phoneNumber: ${phoneNumber} ");
      return {'username': username, 'phoneNumber': phoneNumber};
    
    } else {
      print('Document with userId $userId does not exist.');
      // Return null or throw an exception based on your error handling logic
      return {"username":"","phoneNumber":""};
    }
  } catch (e) {
    print('Error fetching user data for userId $userId: $e');
    // Return null or throw an exception based on your error handling logic
    return {"username":"","phoneNumber":""};
  }
}


Future<String> getRideState(String documentId) async {
  try {
    DatabaseEvent databaseEvent = await FirebaseDatabase.instance
        .reference()
        .child('rides')
        .child(documentId)
        .child('state')
        .once();

    // Check if the dataSnapshot exists
    if (databaseEvent.snapshot.value != null) {
      // Access the 'state' field from the dataSnapshot
      String rideState = databaseEvent.snapshot.value.toString();
      print('rideState: ${rideState}');
      return rideState;
    } else {
      print('No data available for ride with ID $documentId.');
      // Return null or throw an exception based on your error handling logic
      return "No data available";
    }
  } catch (e) {
    print('Error fetching ride state for ride ID $documentId: $e');
    // Return null or throw an exception based on your error handling logic
    return "Error fetching ride state";
  }
}

Future<void> confirmRequest(String documentId, String requestId,String currentState) async{
  
    try {
      FirebaseDatabase.instance
          .reference()
          .child('rides')
          .child(documentId)
          .child('requests')
          .child(requestId)
          .update({'status':'approved'});
          await moveRideToFirestoreHistory(requestId, documentId, {'status':'approved'});
          
      if (requestId=='0' || currentState=='pending'){
     FirebaseDatabase.instance
          .reference()
          .child('rides')
          .child(documentId)
          .update({'state':'approved'});

      }
      setState(() {
        // Update the local data if needed
      });

      print('Request confirmed for requestId: $requestId');
    } catch (e) {
      print('Error confirming request: $e');
    }
  }


Future<void> moveRideToFirestoreHistory(String userId, String rideId, Map<String, String> rideData) async {
  try {
    // Access Firestore collection and document references
    CollectionReference historyCollection = FirebaseFirestore.instance.collection('history');
    DocumentReference userHistoryDocument = historyCollection.doc(userId);
    CollectionReference userRidesCollection = userHistoryDocument.collection('user_rides');

    // Add ride data to user history in Firestore
    await userRidesCollection.doc(rideId).set(rideData, SetOptions(merge: true));
  } catch (e) {
    print('Error moving ride to Firestore history: $e');
  }
}



Future<void> confirmRide(String documentId, String requestId, String currentState) async {
  try {
    DatabaseReference ref = FirebaseDatabase.instance.ref("rides/$documentId/requests");

// Get a snapshot of all requests
ref.once().then((DatabaseEvent snapshot) async {
  if (snapshot.snapshot.value != null) {
    Map requestsData = snapshot.snapshot.value as Map;
    requestsData.forEach((request_Id, requestData) async {
      // Access and modify the 'status' field
Map<String, String> updatedRequestData={};

if (requestData is Map) {
  // Check if requestData is actually a Ma
  updatedRequestData = Map<String, String>.from(requestData.cast<String, String>());
  print("****updatedRequestData*****${updatedRequestData}");
} else {
  // Handle the case where requestData is not a Map
  print('requestData is not a Map');
}
if (updatedRequestData['status']!='pending'){
      updatedRequestData['status'] = stateTransitions[currentState]?? "";
      await moveRideToFirestoreHistory(request_Id, documentId, {'status':stateTransitions[currentState]?? ""});

      // Update the request in the database
      print("I am in pending");
      
      await ref.child(request_Id).update(updatedRequestData);
      }
      else {
        // Map<String, String> userHistoryData= updatedRequestData; 
        //  DatabaseReference ref2 = FirebaseDatabase.instance.ref("rides/$documentId");

// Get a snapshot of all requests
// ref2.once().then((DatabaseEvent snapshot) async {
// print("data coming from ref2${snapshot.snapshot.value}");

//   if (snapshot.snapshot.value != null) {
//     print("****snapshot value is not null******");
//     Map ridesData = snapshot.snapshot.value as Map;
//     ridesData.forEach((ride_Id, ridetData) async {
//       // Access and modify the 'status' field
// Map<String, dynamic> userRideData={};

// if (ridesData is Map) {
//   // Check if requestData is actually a Ma
//   userRideData = Map<String, dynamic>.from(ridesData.cast<String, dynamic>());
//   Map<String, dynamic> updatedUserRideData={
//     "to":userRideData['to']??"",
//     "from":userRideData['from']??"",
//     "time":userRideData['time']??"",
//     "name":userRideData['name']??"",
//     "price":userRideData['price'].toString()?? "0",
//     };
//   print("userRideData$userRideData");
//         userHistoryData['status']='cancelled';
//         userHistoryData.addAll({...updatedUserRideData});
         await moveRideToFirestoreHistory(request_Id, documentId, {'status':'cancelled'});
     
         await ref.child(request_Id).remove();
//       }
    
//   });}});
      }
    });
  }
});

    // Retrieve the list of requestIds


    if (requestId == '0' || currentState == 'pending') {
      FirebaseDatabase.instance.reference().child('rides').child(documentId).update({'state': stateTransitions[currentState]});
    }

    // Assuming you have a setState method to update the local data
    setState(() {
      // Update the local data if needed
    });

    print('Request confirmed for requestId: $requestId');
  } catch (e) {
    print('Error confirming request: $e');
  }
}




  @override
  Widget build(BuildContext context) {
    myreceiveddata = ModalRoute.of(context)!.settings.arguments as Map;
    var documentId = myreceiveddata['documentId'];
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests'),
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
              Navigator.pushReplacementNamed(context, '/userProfile');
            },
          ),
        ],
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Requests',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              // StreamBuilder to listen for requests
              StreamBuilder(
                stream: FirebaseDatabase.instance
                    .reference()
                    .child('rides')
                    .child(documentId)
                    .child('requests')
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 3, // Customize the thickness of the indicator
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                );
                } else if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                  return Text('No data available');
                }
                var requestsMap = Map<dynamic, dynamic>.from((snapshot.data!as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
               var requests =  requestsMap.values;
               var requestsuid =  requestsMap.keys.toList();
                //var filteredRides = requests[documentId]['requests'];
                print ('requests${requests}');

                  return ListView.builder(
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemCount: requests.length,
  itemBuilder: (context, index) {
    return FutureBuilder(
      future: fetchUserData(requestsuid[index]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3, // Customize the thickness of the indicator
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error loading user data');
        } else if (!snapshot.hasData) {
          return Text('No data available');
        }

        Map<String, dynamic> userInfo = snapshot.data as Map<String, dynamic>;

        var requestData = requests.toList()[index];

        return Card(
          child: ListTile(
            title: Text('Payment Method: ${requestData["payment_method"]}'),
            subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start ,
              children: [
                Text('Status: ${requestData["status"]}'),
                Text('Username: ${userInfo["username"]}'),
                Text('Phone: ${userInfo["phoneNumber"]}'),
              ],
            ),
            trailing:(requestData["status"] == "pending" )
        ? ElevatedButton(
            onPressed: () {
              reqId=requestsuid[index];
              confirmRequest(documentId, requestsuid[index],requestData["status"]);
            },
            child: Text("approve",
            // child: Text(stateTransitions[requestData["status"]]  ?? "Unknown",
          ) 
          )
          : 
          null,
        )
        );
      },
    );
  },
);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FutureBuilder<String>(
  future: getRideState(documentId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      // Show a loading indicator or return a widget
      return SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3, // Customize the thickness of the indicator
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ); // Replace with your loading indicator
    } else if (snapshot.hasError) {
      // Handle the error
      return Text('Error loading ride state');
    } else {
      String rideState = snapshot.data!;
      return (rideState != 'approved' && rideState !='started')
          ? Container() // or another widget 
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  confirmRide(documentId, '0', rideState);
                },
                child: Text(stateMap[rideState] ?? ""),
              ),
            );
    }
  },
),
      floatingActionButtonLocation : FloatingActionButtonLocation.centerDocked,
    );
  }
}

class Request {
  final String paymentMethod;
  final String status;
  Request({
    required this.paymentMethod,
    required this.status,
  });

  factory Request.fromMap(Map<dynamic, dynamic> map) {
    return Request(
      paymentMethod: map['payment_method'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
