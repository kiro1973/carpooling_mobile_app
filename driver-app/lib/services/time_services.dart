import 'package:flutter/material.dart';
bool checkTimeBetween10AMAnd10PM() {
    TimeOfDay now = TimeOfDay.now();
    TimeOfDay startTime = TimeOfDay(hour: 10, minute: 0); // 10 AM
    TimeOfDay endTime = TimeOfDay(hour: 22, minute: 0);  // 10 PM

    return now.hour > startTime.hour ||
           (now.hour == startTime.hour && now.minute >= startTime.minute) &&
           (now.hour < endTime.hour || (now.hour == endTime.hour && now.minute <= endTime.minute));
  }
bool checkTimeBetween10AMAnd11HalfPM() {
    TimeOfDay now = TimeOfDay.now();
    TimeOfDay startTime = TimeOfDay(hour: 10, minute: 0); // 10 AM
    TimeOfDay endTime = TimeOfDay(hour: 23, minute: 30);  // 10 PM

    return now.hour > startTime.hour ||
           (now.hour == startTime.hour && now.minute >= startTime.minute) &&
           (now.hour < endTime.hour || (now.hour == endTime.hour && now.minute <= endTime.minute));
  }

  bool checkTimeBetween8PMAnd12AMOr12AMAnd1PM() {
    TimeOfDay now = TimeOfDay.now();
    TimeOfDay startTime1 = TimeOfDay(hour: 20, minute: 0);  // 8 PM
    TimeOfDay endTime1 = TimeOfDay(hour: 0, minute: 0);      // 12 AM (midnight)
    TimeOfDay startTime2 = TimeOfDay(hour: 0, minute: 0);   // 12 AM (midnight)
    TimeOfDay endTime2 = TimeOfDay(hour: 13, minute: 0);    // 1 PM

    return (now.hour > startTime1.hour || 
           (now.hour == startTime1.hour && now.minute >= startTime1.minute)) &&
           (now.hour < endTime1.hour || (now.hour == endTime1.hour && now.minute <= endTime1.minute)) ||
           (now.hour > startTime2.hour || 
           (now.hour == startTime2.hour && now.minute >= startTime2.minute)) &&
           (now.hour < endTime2.hour || (now.hour == endTime2.hour && now.minute <= endTime2.minute));
  }
  bool checkTimeBetween8PMAnd12AMOr12AMAnd4HalfPM() {
    TimeOfDay now = TimeOfDay.now();
    TimeOfDay startTime1 = TimeOfDay(hour: 20, minute: 0);  // 8 PM
    TimeOfDay endTime1 = TimeOfDay(hour: 0, minute: 0);      // 12 AM (midnight)
    TimeOfDay startTime2 = TimeOfDay(hour: 0, minute: 0);   // 12 AM (midnight)
    TimeOfDay endTime2 = TimeOfDay(hour: 16, minute: 30);    // 1 PM

    return (now.hour > startTime1.hour || 
           (now.hour == startTime1.hour && now.minute >= startTime1.minute)) &&
           (now.hour < endTime1.hour || (now.hour == endTime1.hour && now.minute <= endTime1.minute)) ||
           (now.hour > startTime2.hour || 
           (now.hour == startTime2.hour && now.minute >= startTime2.minute)) &&
           (now.hour < endTime2.hour || (now.hour == endTime2.hour && now.minute <= endTime2.minute));
  }



  
