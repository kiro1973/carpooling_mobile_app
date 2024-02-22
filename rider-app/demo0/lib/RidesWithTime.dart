import 'services/time_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'services/auth_service.dart';


  List <String> getTime(){
    if (checkTimeBetween8PMAnd12AMOr12AMAnd1PM() && !checkTimeBetween10AMAnd10PM()){
      return  [ '5:30 PM'];
    }
    else if(!checkTimeBetween8PMAnd12AMOr12AMAnd1PM() && checkTimeBetween10AMAnd10PM())
    {
      return ['7:30 AM'];
    }
    return ['7:30 AM', '5:30 PM'];
  }
class RidesWithTime extends StatefulWidget {
  @override
  _RidesWithTime createState() => _RidesWithTime();
}

class _RidesWithTime extends State<RidesWithTime> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  List<String> timeOptions = ['7:30 AM', '5:30 PM'];
  List <String> getTiime(){
    if (checkTimeBetween8PMAnd12AMOr12AMAnd1PM() && !checkTimeBetween10AMAnd10PM()){
      return  [ '5:30 PM'];
    }
    else if(!checkTimeBetween8PMAnd12AMOr12AMAnd1PM() && checkTimeBetween10AMAnd10PM())
    {
      return ['7:30 AM'];
    }
    return ['7:30 AM', '5:30 PM'];
  }

addRequest(String documentId, Map<String, dynamic> requestData) async {
  final DatabaseReference rideRef = FirebaseDatabase.instance.reference().child('rides').child(documentId);

  // Generate a random request ID
  String requestId = DateTime.now().millisecondsSinceEpoch.toString();

  // Create a map for the new request
  Map<String, dynamic> newRequest = {
    requestId: {
      'payment_method': requestData['payment_method'] ?? '',
      'status': requestData['status'] ?? '',
    },
  };

  // Update the 'requests' field in the ride document
  await rideRef.child('requests').update(newRequest);
}

  List<String> locations = ['Location 1', 'Location 2', 'Location 3','Mohandessin','Nasr City'];
  List<String> ASU = ['ASU Gate 3', 'ASU Gate 4'];
  // String selectedTime = '7:30 AM';
  String selectedTime = getTime()[0];
  
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
            icon: Icon(Icons.logout),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: getTime()[0],
              items: getTime().map((String timeOption) {
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
                print("selectedTo ${selectedTo}");
                DateTime now = DateTime.now();
                String formattedTime = DateFormat('h:mm a').format(now);
    print("formattedTime ${formattedTime}") ;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Row(mainAxisAlignment: MainAxisAlignment.center,
                    children:[CircularProgressIndicator()]);
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