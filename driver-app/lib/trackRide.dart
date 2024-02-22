import 'package:flutter/material.dart';

class TrackRide extends StatefulWidget {
  const TrackRide({super.key});

  @override
  State<TrackRide> createState() => _TrackRideState();
}

class _TrackRideState extends State<TrackRide> {
  Map myreceiveddata = {};
  @override
  Widget build(BuildContext context) {
    myreceiveddata = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
children: [
  SizedBox(
                height: 150.0, 
                child: Text(".....This Ride is a ${myreceiveddata['status']}'Ride ",
            style: TextStyle(
              fontSize: 20.0, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            
            
            ),
  ),
     
            SizedBox(
                height: 150.0, 
                child:  Text(" ${myreceiveddata['state']}",
            style: TextStyle(
              fontSize: 18.0, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
            ),
            
            
            ),
            ),

            SizedBox(
                height: 150.0, 
                child:  Text('${myreceiveddata['Date']} at ${myreceiveddata['Time']}'),),

            ]),

            
      ),
    );
  }
}