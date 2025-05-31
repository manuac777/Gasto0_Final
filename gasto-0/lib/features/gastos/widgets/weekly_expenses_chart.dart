import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gasto_0/Models/expense.dart';
import 'package:gasto_0/features/gastos/utils/filter_expenses.dart';
import 'package:gasto_0/features/gastos/utils/filter_time.dart';
import 'package:intl/intl.dart';

class WeeklyExpensesChart extends StatefulWidget {
  final List<Expense> expenses;

  const WeeklyExpensesChart({super.key, required this.expenses});

  @override
  State<WeeklyExpensesChart> createState() => _WeeklyExpensesChartState();
}

class _WeeklyExpensesChartState extends State<WeeklyExpensesChart> {
  DateTimeRange selectedWeek = FilterTime.getCurrentWeek();
  FilterExpenses filterExpenses = FilterExpenses();
  FilterTime filterTime = FilterTime();

  @override
  Widget build(BuildContext context) {
    final expensesOfWeekSelected = filterExpenses.filterExpensesBySelectedWeek(
        widget.expenses, selectedWeek);

    List<DateTime> datesOfWeekSelected =
        filterTime.getDatesOfSelectedWeek(selectedWeek);

    final dailyData = filterExpenses.processExpensesByDay(
        expensesOfWeekSelected, datesOfWeekSelected);

    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => _changeWeek(-1),
                  icon: const Icon(Icons.chevron_left)),
              Text('${DateFormat('dd/MM').format(selectedWeek.start)}-'
                  '${DateFormat('dd/MM').format(selectedWeek.end)}'),
              IconButton(
                  onPressed: () => _changeWeek(1),
                  icon: Icon(Icons.chevron_right)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: BarChart(BarChartData(
                maxY: _calculateMaxY(dailyData),
                barGroups: _buildBarGroups(dailyData),
                titlesData: _buildTitlesData(),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false))),
          )
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(Map<DateTime, double> dailyData) {
    final sortedDates = dailyData.keys.toList()..sort();

    return List.generate(sortedDates.length, (index) {
      final date = sortedDates[index];
      final amount = dailyData[date]!;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
            color: Colors.blue,
            width: 10,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      );
    });
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false, reservedSize: 0)),
      bottomTitles: AxisTitles(
          sideTitles: SideTitles(
              getTitlesWidget: bottomTitles,
              showTitles: true,
              reservedSize: 40)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true, getTitlesWidget: leftTitles, reservedSize: 50)),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value >= 1000) {
      return SideTitleWidget(
        meta: meta,
        space: 8,
        child: Text(
          '\$${(value / 1000).toStringAsFixed(1)}k',
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      );
    } else {
      final Widget text = Text(
        '\$${value.toInt()}',
        style: const TextStyle(
          fontSize: 14,
        ),
      );

      return SideTitleWidget(
        meta: meta,
        space: 8,
        child: text,
      );
    }
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
    return SideTitleWidget(
      meta: meta,
      space: 7,
      child: text,
    );
  }

  double _calculateMaxY(Map<DateTime, double> dailyData) {
    double maxY = 0;
    for (var value in dailyData.values) {
      if (value > maxY) {
        maxY = value;
      }
    }
    return maxY;
  }

  void _changeWeek(int delta) {
    setState(() {
      final duration = Duration(days: 7);
      if (delta < 0) {
        selectedWeek = DateTimeRange(
            start: selectedWeek.start.subtract(duration),
            end: selectedWeek.end.subtract(duration));
      } else {
        selectedWeek = DateTimeRange(
            start: selectedWeek.start.add(duration),
            end: selectedWeek.end.add(duration));
      }
    });
  }
}
