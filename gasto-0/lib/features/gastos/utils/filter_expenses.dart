import 'package:flutter/material.dart';
import 'package:gasto_0/Models/expense.dart';

class FilterExpenses {
  List<Expense> filterExpensesBySelectedWeek(
      List<Expense> expenses, DateTimeRange selectedWeek) {
    final weeklyExpenses = expenses
        .where((expense) =>
            (expense.date.isAfter(selectedWeek.start) ||
                expense.date.isAtSameMomentAs(selectedWeek.start)) &&
            (expense.date.isBefore(selectedWeek.end) ||
                expense.date.isAtSameMomentAs(selectedWeek.end)))
        .toList();

    return weeklyExpenses;
  }

  Map<DateTime, double> processExpensesByDay(
      List<Expense> expenses, List<DateTime> weeklyDates) {
    final dailyExpenses = <DateTime, double>{};

    for (var expense in expenses) {
      final date = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );

      dailyExpenses.update(
        date,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    for (var date in weeklyDates) {
      dailyExpenses.putIfAbsent(date, () => 0);
    }
    return dailyExpenses;
  }
}
