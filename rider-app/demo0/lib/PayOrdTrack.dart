import 'package:flutter/material.dart';
import 'dart:convert';

class PayOrdTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<String>(
    //   future: DefaultAssetBundle.of(context).loadString('assets/ride.json'),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       // If the Future is still loading, return a loading indicator.
    //       return CircularProgressIndicator();
    //     } else if (snapshot.hasError) {
    //       // If there's an error loading the data, display an error message.
    //       return Text('Error loading data: ${snapshot.error}');
    //     } else if (!snapshot.hasData) {
    //       // If no data is available, display a message.
    //       return Text('No data available');
    //     }

    //     // If the Future is complete and data is available, proceed.
    //     var ride = json.decode(snapshot.data!);
         var ride = ModalRoute.of(context)!.settings.arguments as Map; 

         
        return Scaffold(
      appBar: AppBar(
        title: Text('Payment and Order Tracking'),
        actions: [IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),],
      ),
       body: 
      // Center(
      //   child: 
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
children: [

                Card(
            elevation: 5.0, // Elevation for the shadow
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 2.0), // Border color and width
              borderRadius: BorderRadius.circular(12.0), // Border radius
            ),
            child: Container(
              width: 300.0,
              height: 100.0,
              padding: EdgeInsets.all(16.0),
              child: Center(
                // child: Text(".....This Ride is a ${ride['status']}'Ride ",
                child: Text("This Ride is a new Ride ",
            style: TextStyle(
              fontSize: 16.0, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            
            
            )))),
  
Card(
            elevation: 5.0, // Elevation for the shadow
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 2.0), // Border color and width
              borderRadius: BorderRadius.circular(12.0), // Border radius
            ),
            child: Container(
              width: 300.0,
              height: 100.0,
              padding: EdgeInsets.all(16.0),
              child: Center(
                child:  Text(" Driver will arrive on Time",
            style: TextStyle(
              fontSize: 17.0, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
            ),
            
            
            ),
            ))),

           Card(
            elevation: 5.0, // Elevation for the shadow
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 2.0), // Border color and width
              borderRadius: BorderRadius.circular(12.0), // Border radius
            ),
            child: Container(
              width: 300.0,
              height: 50.0,
              padding: EdgeInsets.all(16.0),
              child: Row(
                        children:[
                          Icon(Icons.access_alarm_rounded),
                          SizedBox(width: 100,),
                          Text('${ride['time']}'),
                          
                          
                          ]),
            )),
SizedBox(
                height: 150.0, 
                child:Column(children: [
        Card(
            elevation: 5.0, // Elevation for the shadow
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 2.0), // Border color and width
              borderRadius: BorderRadius.circular(12.0), // Border radius
            ),
            child: Container(
              width: 300.0,
              height: 50.0,
              padding: EdgeInsets.all(16.0),
              child: Center( 
                child:  Text('Ammout paid in ${ride['paymentMethod']}: ${ride['price']} USD',
                style:TextStyle(
              fontSize: 14.0)
                ),
                ),
            )),
                  Card(
                    elevation: 5.0, // Elevation for the shadow
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey, width: 2.0), // Border color and width
              borderRadius: BorderRadius.circular(12.0), // Border radius
            ),
            child: Container(
              width: 300.0,
              height: 50.0,
              padding: EdgeInsets.all(16.0),
              child: Center( 
                // child:  Text('Estimated Arrive Time ${ride['ArriveBy']}',
                child:  Text('Driver will wait 5 minutes only',
                style:TextStyle(
              fontSize: 14.0),
              ),
                ),
            )

                  )
                ],)
                )
            ]),

            
      );
        
     
      // );
      }
    
  }

