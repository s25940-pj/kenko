import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Reminder extends Equatable {
  final String id;
  final String medicationId;
  final TimeOfDay time;
  final DateTimeRange dateTimeRange;
  final int dosage;
  final String userId;

  const Reminder(
      {required this.id,
      required this.medicationId,
      required this.time,
      required this.dateTimeRange,
      required this.dosage,
      required this.userId});

  @override
  List<Object> get props => [id, medicationId, time];

  static Reminder fromSnapshot(DocumentSnapshot snap) {
    return Reminder(
      id: snap.id,
      medicationId: snap['medicationId'],
      time: _createTimeOfDayFromString(snap['time']),
      dateTimeRange: DateTimeRange(
          start: _createDateFromString(snap['dateTimeRange']['start']),
          end: _createDateFromString(snap['dateTimeRange']['end'])),
      dosage: snap['dosage'],
      userId: snap['userId'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'medicationId': medicationId,
      'time': _createTimeStringFromTimeOfDay(time),
      'dateTimeRange': {
        'start': _createDateStringFromDateTime(dateTimeRange.start),
        'end': _createDateStringFromDateTime(dateTimeRange.end),
      },
      'dosage': dosage,
      'userId': userId,
    };
  }

  static TimeOfDay _createTimeOfDayFromString(String timeString) {
    try {
      List<String> parts = timeString.split(':');
      if (parts.length == 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);

        if (hour >= 0 && hour < 24 && minute >= 0 && minute < 60) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
    } catch (e) {
      // Handle parsing errors
      print('Error parsing time string: $e');
    }

    // Return a default time if parsing fails
    return const TimeOfDay(hour: 10, minute: 59);
  }

  static String _createTimeStringFromTimeOfDay(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

  static String _createDateStringFromDateTime(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  static DateTime _createDateFromString(String dateString) {
    try {
      List<String> parts = dateString.split('-');
      if (parts.length == 3) {
        int year = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int day = int.parse(parts[2]);

        if (year >= 0 && month >= 0 && month <= 12 && day >= 0 && day <= 31) {
          return DateTime(year, month, day);
        }
      }
    } catch (e) {
      // Handle parsing errors
      print('Error parsing date string: $e');
    }

    // Return a default date if parsing fails
    return DateTime.now();
  }
}
