// // import 'package:flutter/material.dart';
// // import 'package:firebase_database/firebase_database.dart';

// // class RideListView extends StatefulWidget {
// //   @override
// //   _RideListViewState createState() => _RideListViewState();
// // }

// // class _RideListViewState extends State<RideListView> {
// //   final TextEditingController fromController = TextEditingController();
// //   final TextEditingController toController = TextEditingController();
// //   final DatabaseReference _ridesRef = FirebaseDatabase.instance.reference().child('rides');

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Available Rides'),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.history),
// //             onPressed: () {
// //               Navigator.pushNamed(context, '/history');
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Column(
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: TextField(
// //               controller: fromController,
// //               decoration: InputDecoration(labelText: 'From'),
// //               onChanged: (value) {
// //                 setState(() {});
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: TextField(
// //               controller: toController,
// //               decoration: InputDecoration(labelText: 'To'),
// //               onChanged: (value) {
// //                 setState(() {});
// //               },
// //             ),
// //           ),
// //           Expanded(
// //             child: StreamBuilder(
// //               stream: _ridesRef.onValue,
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return CircularProgressIndicator();
// //                 } else if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
// //                   return Text('No data available');
// //                 }

// //                 var rides = Map<dynamic, dynamic>.from((snapshot.data!as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
// //                 print (rides);
// //                 return ListView.builder(
// //                   padding: EdgeInsets.all(10),
// //                   itemCount: rides.length,
// //                   itemBuilder: (BuildContext context, int index) {
// //                     var rideData = rides.values.toList()[index];
// //                     var documentId = rides.keys.toList()[index]; // Retrieve document ID
// //                     print(documentId);

// //                     return Card(
// //                       elevation: 3,
// //                       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
// //                       child: ListTile(
// //                         onTap: () {
// //                           Navigator.pushNamed(context, '/pay-review', arguments: {
// //                             "documentId": documentId, // Pass document ID
// //                             "name": rideData['name'],
// //                             "from": rideData['from'],
// //                             "to": rideData['to'],
// //                             "time": rideData['time'],
// //                             "price": rideData['price'],
// //                           });
// //                         },
// //                         title: Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             Text('${rideData['name']} '),
// //                             Row(
// //                               children:[
// //                                 Text('${rideData['time']}'),
// //                                 SizedBox(
// //                                   width: 10,
// //                                 ),
// //                                 Icon(Icons.access_alarm_rounded),
// //                               ],
// //                             ),
// //                           ],
// //                         ),
// //                         subtitle: Text(
// //                           'From: ${rideData['from']} - To: ${rideData['to']} price: ${rideData['price']}',
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }







// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class RideListView extends StatefulWidget {
//   @override
//   _RideListViewState createState() => _RideListViewState();
// }

// class _RideListViewState extends State<RideListView> {
//   final TextEditingController fromController = TextEditingController();
//   final TextEditingController toController = TextEditingController();
//   final DatabaseReference _ridesRef = FirebaseDatabase.instance.reference().child('rides');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Available Rides'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.history),
//             onPressed: () {
//               Navigator.pushNamed(context, '/history');
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: fromController,
//               decoration: InputDecoration(labelText: 'From'),
//               onChanged: (value) {
//                 setState(() {});
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: toController,
//               decoration: InputDecoration(labelText: 'To'),
//               onChanged: (value) {
//                 setState(() {});
//               },
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: _ridesRef.orderByChild('from').equalTo(fromController.text).onValue,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
//                   return Text('No data available');
//                 }

//                 var rides = Map<dynamic, dynamic>.from((snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
//                 var filteredRides = rides.values.where((rideData) =>
//                     rideData['from'] == fromController.text &&
//                     rideData['to'] == toController.text);

//                 return ListView.builder(
//                   padding: EdgeInsets.all(10),
//                   itemCount: filteredRides.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     var rideData = filteredRides.toList()[index];
//                     var documentId = rides.keys.toList()[rides.values.toList().indexOf(rideData)]; // Retrieve document ID
//                     print(documentId);

//                     return Card(
//                       elevation: 3,
//                       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       child: ListTile(
//                         onTap: () {
//                           Navigator.pushNamed(context, '/pay-review', arguments: {
                            
//                             "documentId": documentId, // Pass document ID
//                             "name": rideData['name'],
//                             "from": rideData['from'],
//                             "to": rideData['to'],
//                             "time": rideData['time'],
//                             "price": rideData['price'],
//                           });
//                         },
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('${rideData['name']} '),
//                             Row(
//                               children: [
//                                 Text('${rideData['time']}'),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Icon(Icons.access_alarm_rounded),
//                               ],
//                             ),
//                           ],
//                         ),
//                         subtitle: Text(
//                           'From: ${rideData['from']} - To: ${rideData['to']} price: ${rideData['price']}',
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// //working but error while debugging that go 3adi

// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class RideListView extends StatefulWidget {
//   @override
//   _RideListViewState createState() => _RideListViewState();
// }

// class _RideListViewState extends State<RideListView> {
//   final DatabaseReference _ridesRef = FirebaseDatabase.instance.reference().child('rides');

//   String selectedFrom = '';
//   String selectedTo = '';
//   String selectedTime = '';

//   List<String> fromOptions = [];
//   List<String> toOptions = [];
//   List<String> timeOptions = ['7:30 AM', '5:30 PM']; // Assuming you have only two time slots

//   @override
//   void initState() {
//     super.initState();
//     fetchRideOptions();
//   }

//   Future<void> fetchRideOptions() async {
//     List<String> uniqueFromOptions = [];
//     List<String> uniqueToOptions = [];

//     try {
// DatabaseEvent snapshot = await _ridesRef.once() as DatabaseEvent;
// Map<dynamic, dynamic>? rides = (snapshot.snapshot.value as Map<dynamic, dynamic>?);


//       rides!.values.forEach((rideData) {
//         uniqueFromOptions.add(rideData['from']);
//         uniqueToOptions.add(rideData['to']);
//       });

//       fromOptions = uniqueFromOptions.toSet().toList();
//       toOptions = uniqueToOptions.toSet().toList();

//       fromOptions.sort();
//       toOptions.sort();

//       if (fromOptions.isNotEmpty) {
//         selectedFrom = fromOptions[0];
//       }

//       if (toOptions.isNotEmpty) {
//         selectedTo = toOptions[0];
//       }

//       selectedTime = timeOptions[0];

//       setState(() {});
//     } catch (error) {
//       print('Error fetching ride options: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Available Rides'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.history),
//             onPressed: () {
//               Navigator.pushNamed(context, '/history');
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: DropdownButtonFormField<String>(
//               value: selectedFrom,
//               items: fromOptions.map((String fromOption) {
//                 return DropdownMenuItem<String>(
//                   value: fromOption,
//                   child: Text(fromOption),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedFrom = newValue ?? '';
//                 });
//               },
//               decoration: InputDecoration(labelText: 'From'),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: DropdownButtonFormField<String>(
//               value: selectedTo,
//               items: toOptions.map((String toOption) {
//                 return DropdownMenuItem<String>(
//                   value: toOption,
//                   child: Text(toOption),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedTo = newValue ?? '';
//                 });
//               },
//               decoration: InputDecoration(labelText: 'To'),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: DropdownButtonFormField<String>(
//               value: selectedTime,
//               items: timeOptions.map((String timeOption) {
//                 return DropdownMenuItem<String>(
//                   value: timeOption,
//                   child: Text(timeOption),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedTime = newValue ?? '';
//                 });
//               },
//               decoration: InputDecoration(labelText: 'Time'),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: _ridesRef.orderByChild('from').equalTo(selectedFrom).onValue,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
//                   return Text('No data available');
//                 }

//                 var rides = Map<dynamic, dynamic>.from((snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
//                 var filteredRides = rides.values.where((rideData) =>
//                     rideData['from'] == selectedFrom &&
//                     rideData['to'] == selectedTo);

//                 return ListView.builder(
//                   padding: EdgeInsets.all(10),
//                   itemCount: filteredRides.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     var rideData = filteredRides.toList()[index];
//                     var documentId = rides.keys.toList()[rides.values.toList().indexOf(rideData)]; // Retrieve document ID
//                     print(documentId);

//                     return Card(
//                       elevation: 3,
//                       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       child: ListTile(
//                         onTap: () {
//                           Navigator.pushNamed(context, '/pay-review', arguments: {
//                             "documentId": documentId, // Pass document ID
//                             "name": rideData['name'],
//                             "from": rideData['from'],
//                             "to": rideData['to'],
//                             "time": rideData['time'],
//                             "price": rideData['price'],
//                           });
//                         },
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('${rideData['name']} '),
//                             Row(
//                               children: [
//                                 Text('${rideData['time']}'),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Icon(Icons.access_alarm_rounded),
//                               ],
//                             ),
//                           ],
//                         ),
//                         subtitle: Text(
//                           'From: ${rideData['from']} - To: ${rideData['to']} price: ${rideData['price']}',
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';

// class RideListView extends StatefulWidget {
//   @override
//   _RideListViewState createState() => _RideListViewState();
// }

// class _RideListViewState extends State<RideListView> {
//   final DatabaseReference _ridesRef = FirebaseDatabase.instance.reference().child('rides');

//   String selectedFrom = '';
//   String selectedTo = '';
//   String selectedTime = '';

//   List<String> fromOptions = [];
//   List<String> toOptions = [];
//   List<String> timeOptions = ['7:30 AM', '5:30 PM']; // Assuming you have only two time slots

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<bool> fetchRideOptions() async {
//     List<String> uniqueFromOptions = [];
//     List<String> uniqueToOptions = [];

//     try {
//       DatabaseEvent snapshot = await _ridesRef.once() as DatabaseEvent;
//       Map<dynamic, dynamic>? rides = (snapshot.snapshot.value as Map<dynamic, dynamic>?);

//       rides!.values.forEach((rideData) {
//         uniqueFromOptions.add(rideData['from']);
//         uniqueToOptions.add(rideData['to']);
//       });

//       fromOptions = uniqueFromOptions.toSet().toList();
//       toOptions = uniqueToOptions.toSet().toList();

//       fromOptions.sort();
//       toOptions.sort();

//       if (fromOptions.isNotEmpty) {
//         selectedFrom = fromOptions[0];
//       }

//       if (toOptions.isNotEmpty) {
//         selectedTo = toOptions[0];
//       }

//       selectedTime = timeOptions[0];

//       setState(() {});

//       return true;
//     } catch (error) {
//       print('Error fetching ride options: $error');
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Available Rides'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.history),
//             onPressed: () {
//               Navigator.pushNamed(context, '/history');
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: FutureBuilder(
//               future: fetchRideOptions(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else if (snapshot.hasError || !(snapshot.data as bool)) {
//                   return Text('Error fetching data');
//                 } else {
//                   return Column(
//                     children: [
//                       DropdownButtonFormField<String>(
//                     value: selectedFrom,
//                     items: fromOptions.map((String fromOption) {
//                       return DropdownMenuItem<String>(
//                         value: fromOption,
//                         child: Text(fromOption),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         selectedFrom = newValue ?? '';
//                       });
//                     },
//                     decoration: InputDecoration(labelText: 'From'),
//                   ),

//                     DropdownButtonFormField<String>(
//               value: selectedTo,
//               items: toOptions.map((String toOption) {
//                 return DropdownMenuItem<String>(
//                   value: toOption,
//                   child: Text(toOption),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedTo = newValue ?? '';
//                 });
//               },
//               decoration: InputDecoration(labelText: 'To'),
//             ),


//             DropdownButtonFormField<String>(
//               value: selectedTime,
//               items: timeOptions.map((String timeOption) {
//                 return DropdownMenuItem<String>(
//                   value: timeOption,
//                   child: Text(timeOption),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedTime = newValue ?? '';
//                 });
//               },
//               decoration: InputDecoration(labelText: 'Time'),
//             ),


//                     ],
//                   );
//                 }
//               },
//             ),
//           ),
          
//           Expanded(
//             child: StreamBuilder(
//               stream: _ridesRef.orderByChild('from').equalTo(selectedFrom).onValue,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
//                   return Text('No data available');
//                 }

//                 var rides = Map<dynamic, dynamic>.from((snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
//                 var filteredRides = rides.values.where((rideData) =>
//                     rideData['from'] == selectedFrom &&
//                     rideData['to'] == selectedTo);

//                 return ListView.builder(
//                   padding: EdgeInsets.all(10),
//                   itemCount: filteredRides.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     var rideData = filteredRides.toList()[index];
//                     var documentId = rides.keys.toList()[rides.values.toList().indexOf(rideData)]; // Retrieve document ID
//                     print(documentId);

//                     return Card(
//                       elevation: 3,
//                       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                       child: ListTile(
//                         onTap: () {
//                           Navigator.pushNamed(context, '/pay-review', arguments: {
//                             "documentId": documentId, // Pass document ID
//                             "name": rideData['name'],
//                             "from": rideData['from'],
//                             "to": rideData['to'],
//                             "time": rideData['time'],
//                             "price": rideData['price'],
//                           });
//                         },
//                         title: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('${rideData['name']} '),
//                             Row(
//                               children: [
//                                 Text('${rideData['time']}'),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Icon(Icons.access_alarm_rounded),
//                               ],
//                             ),
//                           ],
//                         ),
//                         subtitle: Text(
//                           'From: ${rideData['from']} - To: ${rideData['to']} price: ${rideData['price']}',
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),

//  ],
//       ),
//     );
//   }
// }



//KERRA CODE
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'services/auth_service.dart';
import 'services/firestore_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class RideListView extends StatefulWidget {
  @override
  _RideListViewState createState() => _RideListViewState();
}

class _RideListViewState extends State<RideListView> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  List<String> timeOptions = ['7:30 AM', '5:30 PM'];
  List<String> locations = ['Location 1', 'Location 2', 'Location 3','Mohandessin','Nasr City'];
  List<String> ASU = ['ASU Gate 3', 'ASU Gate 4'];
  String selectedTime = '7:30 AM';
  String selectedFrom = 'Location 1';
  String selectedTo = 'ASU Gate 3';
  final DatabaseReference _ridesRef = FirebaseDatabase.instance.reference().child('rides');
  final AuthService _auth = AuthService();







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Rides'),
        actions: [
          IconButton(
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
          ),
        ]
        ,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: selectedTime,
              items: timeOptions.map((String timeOption) {
                return DropdownMenuItem<String>(
                  value: timeOption,
                  child: Text(timeOption),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTime = newValue ?? '';
                });
              },
              decoration: InputDecoration(labelText: 'Time'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: (selectedTime=="7:30 AM" ? locations.first : ASU.first),
              items: (selectedTime=="7:30 AM" ? locations : ASU).map((String location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFrom = newValue ?? '';
                });
              },
              decoration: InputDecoration(labelText: 'From'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: (selectedTime=="7:30 AM" ? ASU.first : locations.first),
              items: (selectedTime=="7:30 AM" ? ASU : locations) .map((String destination) {
                return DropdownMenuItem<String>(
                  // .where((destination) => destination != selectedFrom)
                  value: destination,
                  child: Text(destination),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTo = newValue ?? '';
                });
              },
              decoration: InputDecoration(labelText: 'To'),
            ),
          ),



          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: fromController,
          //     decoration: InputDecoration(labelText: 'From'),
          //     onChanged: (value) {
          //       setState(() {});
          //     },
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: toController,
          //     decoration: InputDecoration(labelText: 'To'),
          //     onChanged: (value) {
          //       setState(() {});
          //     },
          //   ),
          // ),




          Expanded(
            child: StreamBuilder(
              stream: _ridesRef.orderByChild('from').equalTo(selectedFrom).onValue,
              builder: (context, snapshot) {
                print("selectedFrom ${selectedFrom}");
                print("selectedFrom ${selectedTo}");
                DateTime now = DateTime.now();
                String formattedTime = DateFormat('h:mm a').format(now);
    print("formattedTime ${formattedTime}") ;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(mainAxisAlignment: MainAxisAlignment.center,
                    children:[CircularProgressIndicator()])
                  ;
                } else if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                  return Text('No data available');
                }

                var rides = Map<dynamic, dynamic>.from((snapshot.data! as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
                var filteredRides = rides.values.where((rideData) =>
                    rideData['from'] == selectedFrom &&
                    rideData['to'] == selectedTo
                    &&
                    rideData['time'] == selectedTime);

                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: filteredRides.length,
                  itemBuilder: (BuildContext context, int index) {
                    var rideData = filteredRides.toList()[index];
                    var documentId = rides.keys.toList()[rides.values.toList().indexOf(rideData)]; // Retrieve document ID
                    print(documentId);

                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/pay-review', arguments: {
                            
                            "documentId": documentId, // Pass document ID
                            "name": rideData['name'],
                            "from": rideData['from'],
                            "to": rideData['to'],
                            "time": rideData['time'],
                            "price": rideData['price'],
                          });
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${rideData['name']} '),
                            Row(
                              children: [
                                Text('${rideData['time']}'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.access_alarm_rounded),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Text(
                          'From: ${rideData['from']} - To: ${rideData['to']} price: ${rideData['price']}',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}