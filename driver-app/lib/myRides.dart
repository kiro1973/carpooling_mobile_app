import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'services/auth_service.dart';
import 'package:flutter/services.dart';
import 'services/time_services.dart';
import 'components/dialog.dart';

class MyRides extends StatefulWidget {
  @override
  _MyRidesState createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  // final TextEditingController fromController = TextEditingController();
  // final TextEditingController toController = TextEditingController();
  final DatabaseReference _ridesRef = FirebaseDatabase.instance.reference().child('rides');
    final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
      Map receivedData = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: Text('My rides'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.history),
          //   onPressed: () {
          //     //Navigator.pushNamed(context, '/history');
          //   },
          // ),
         
          Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: TextButton(
            child:Text('restrict Time',
            style: TextStyle(color: Colors.white),
            ),
            
            onPressed: () {
              Navigator.pushNamed(context, '/myRidesWithTime',arguments: {"email":receivedData['email'],"driver_id":receivedData['driver_id']} );
            },
          ),
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
        ],
      ),
      body: Column(
        children: [
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
              stream: _ridesRef.onValue,
              builder: (context, snapshot) {
                  Map receivedData = ModalRoute.of(context)!.settings.arguments as Map;

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(mainAxisAlignment: MainAxisAlignment.center,
                    children:[CircularProgressIndicator()]);
                } else if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                  return Text('No data available');
                }

                var rides = Map<dynamic, dynamic>.from((snapshot.data!as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>);
               var filteredRides = rides.values.where((rideData) =>
                    rideData['driverId'] == receivedData['driver_id']);
                print (filteredRides);
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
                              children:[
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