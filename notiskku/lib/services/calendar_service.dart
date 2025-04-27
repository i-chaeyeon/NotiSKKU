import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Future<List<Appointment>> loadAppointments() async {
  final String jsonString = await rootBundle.loadString(
    'assets/data/academic_calendar.json',
  );
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  final String colorDarkGreen = jsonData['colorDarkGreen']; // "#0B5B42"
  final List<dynamic> events = jsonData['events'];

  return events.map((data) {
    final String colorString = _resolveColor(data['color'], {
      'colorDarkGreen': colorDarkGreen,
    });
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

String _resolveColor(String colorKey, Map<String, String> colorMap) {
  return colorMap[colorKey] ?? '#000000'; // 기본값: 검정
}

Color _hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex';
  }
  return Color(int.parse(hex, radix: 16));
}
