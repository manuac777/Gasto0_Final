import 'package:flutter/material.dart';

class FilterTime {
  static DateTimeRange getCurrentWeek() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    return DateTimeRange(
        start: DateTime(start.year, start.month, start.day),
        end: start.add(const Duration(days: 6)));
  }

  List<DateTime> getDatesOfSelectedWeek(selectedWeek) {
    List<DateTime> weeklyDates = [];
    for (int i = 0; i < 7; i++) {
      weeklyDates.add(DateTime(selectedWeek.start.year,
          selectedWeek.start.month, selectedWeek.start.day + i));
    }

    return weeklyDates;
  }
}
