import 'package:flutter/material.dart';
import 'dart:convert';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: DefaultAssetBundle.of(context).loadString('assets/history.json'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the Future is still loading, return a loading indicator.
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error loading the data, display an error message.
          return Text('Error loading data: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          // If no data is available, display a message.
          return Text('No data available');
        }

        // If the Future is complete and data is available, proceed.
        var rides = json.decode(snapshot.data!);

         
        return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: 
        ListView.builder(
          padding:EdgeInsets.all(10) ,
          itemCount: rides.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            onTap: (){
                      Navigator.pushNamed(context, '/trackRide', arguments:     {
      "name": rides[index]['name'],
      "from": rides[index]['from'],
      "to":rides[index]['to'],
      "Time":rides[index]['Time'],
      "price":rides[index]['priice'],
    "Date":rides[index]['Date'],
"status":rides[index]['status'],
"state":rides[index]['state']
});
                    },
              title: 
              Column(
            children: [
              Text(rides[index]['status'],
              style: TextStyle(
              fontSize: 14.0, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
              
              ),
              Text('${rides[index]['Date']} Time:${rides[index]['Time']}'),
            ]),
              subtitle: Text(
                  'Driver: ${rides[index]['name']} \n From: ${rides[index]['from']} - To: ${rides[index]['to']} price: ${rides[index]['price']}'),
            ));
          },
        ));
      },
    );
  }
}
