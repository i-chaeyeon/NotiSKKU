import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Future<List<Appointment>> loadAppointments() async {
  final String jsonString = await rootBundle.loadString('assets/data/academic_calendar.json');
  final List<dynamic> jsonData = json.decode(jsonString);
  
  return jsonData.map((data) {
    final String colorString = data['color']; // 예: "#FF0000"
    final Color color = _hexToColor(colorString);
    return Appointment(
      startTime: DateTime.parse(data['startTime']),
      endTime: DateTime.parse(data['endTime']),
      subject: data['subject'],
      isAllDay: data['isAllDay'],
      color: color,
    );
  }).toList();
}

Color _hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF' + hex;
  }
  return Color(int.parse(hex, radix: 16));
}
