import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'services/auth_service.dart';
class SubmitRideScreen extends StatefulWidget {
  @override
  _SubmitRideScreenState createState() => _SubmitRideScreenState();
}

class _SubmitRideScreenState extends State<SubmitRideScreen> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  final AuthService _auth = AuthService();

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
 

List<String> timeOptions = ['7:30 AM', '5:30 PM'];
  List<String> locations = ['Location 1', 'Location 2', 'Location 3','Mohandessin','Nasr City'];
  List<String> ASU = ['ASU Gate 3', 'ASU Gate 4'];
  String selectedTime = '7:30 AM';
  String selectedFrom = 'Location 1';
  String selectedTo = 'ASU Gate 3';
   String? _errorMessage;
   double? price;
  void submitRide() {
    String from = _fromController.text;
    // String name = _nameController.text;
    Map receivedData = ModalRoute.of(context)!.settings.arguments as Map;
    try {
       price = double.parse(_priceController.text);
      // Do something with the valid price
      print('Entered Price: $price');
      _errorMessage = null; // Reset error message if it was previously set
    } catch (e) {
      // Show an error message if parsing fails
      setState(() {
        _errorMessage = 'Invalid Price. Please enter a valid number.';
      });
    }
    String time = _timeController.text;
    String to = _toController.text;
    String name=receivedData['email'].split('@')[0];
    String uid= receivedData['driver_id'];
    
     print("uid:${uid}");

    Map<String, dynamic> newRide = {
      'from': selectedFrom,
      'name': name,
      'price': price,
      'time': selectedTime,
      'to': selectedTo,
      'driverId':uid,
      'cake':"myCake",
      'requests':{}
    };

    _database.child('rides').push().set(newRide);
    Navigator.pushNamed(context, '/myRides',arguments: {"email":receivedData['email'],"driver_id":receivedData['driver_id']} );
    // Optionally, you can clear the form after submission
    _fromController.clear();
    _nameController.clear();
    _priceController.clear();
    _timeController.clear();
    _toController.clear();
  }

  @override
  Widget build(BuildContext context) {
        Map receivedData = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Ride'),
        actions: [
          Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/addRoute_selection',arguments: {"email":receivedData['email'],"driver_id":receivedData['driver_id']} );
            },
            child: Text(
              'restrict time',
              style: TextStyle(color: Colors.white),
            ),
          ),
            ),
            Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: TextButton(
            child:Text('my rides',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: (value) {
                // Custom validation logic if needed
                if (value == null || value.isEmpty) {
                  return 'Please enter a value.';
                }
                return null;
              },
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitRide,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
