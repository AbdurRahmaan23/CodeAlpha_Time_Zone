import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(TimeZoneConverterApp());
}

class TimeZoneConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Zone Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimeZoneConverter(),
    );
  }
}

class TimeZoneConverter extends StatefulWidget {
  @override
  _TimeZoneConverterState createState() => _TimeZoneConverterState();
}

class _TimeZoneConverterState extends State<TimeZoneConverter> {
  String? _selectedTimeZone;
  DateTime _currentTime = DateTime.now();
  String? _equivalentTime; // To store the equivalent time of the selected time zone

  // List of time zones with their respective UTC offsets in hours.
  final Map<String, Duration> _timeZoneOffsets = {
    'UTC': Duration(hours: 0),
    'America/New_York': Duration(hours: -4), // EDT
    'Europe/London': Duration(hours: 1),     // BST (GMT+1)
    'Asia/Tokyo': Duration(hours: 9),        // JST
    'Australia/Sydney': Duration(hours: 10), // AEST
    'Africa/Cairo': Duration(hours: 2),      // EET
  };

  // Function to format the time for the selected timezone
  String _formatDateTime(DateTime dateTime, String timeZone) {
    final offset = _timeZoneOffsets[timeZone] ?? Duration(hours: 0);
    final newTime = dateTime.toUtc().add(offset);
    return DateFormat('yyyy-MM-dd – hh:mm a').format(newTime); // AM/PM format
  }

  // Function to calculate the equivalent time for the selected time zone
  void _calculateEquivalentTime() {
    if (_selectedTimeZone != null) {
      setState(() {
        _equivalentTime = _formatDateTime(_currentTime, _selectedTimeZone!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Center(child: Text('Time Zone Converter')),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Time Zone',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              DropdownButton<String>(
                value: _selectedTimeZone,
                hint: Text('Choose Time Zone'),
                items: _timeZoneOffsets.keys.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedTimeZone = newValue;
                    _equivalentTime = null; // Reset equivalent time when changing timezone
                  });
                },
              ),
              SizedBox(height: 20),
              if (_selectedTimeZone != null)
                Text(
                  'Current time in $_selectedTimeZone: ${_formatDateTime(_currentTime, _selectedTimeZone!)}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              SizedBox(height: 20),
              if (_equivalentTime != null) // Show equivalent time if calculated
                Text(
                  'Equivalent time: $_equivalentTime',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              SizedBox(height: 25),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.tealAccent),
                ),
                onPressed: () {
                  _calculateEquivalentTime(); // Calculate and show equivalent time for the selected timezone
                },
                child: Text('Show Equivalent Time', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
