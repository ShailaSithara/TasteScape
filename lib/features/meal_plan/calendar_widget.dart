import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MealPlannerCalendar extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(CalendarFormat) onFormatChanged;
  final void Function(DateTime) onPageChanged;
  final List<dynamic> Function(DateTime) eventLoader;

  const MealPlannerCalendar({
    super.key,
    required this.selectedDay,
    required this.focusedDay,
    required this.calendarFormat,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.eventLoader,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFF2045).withOpacity(0.05),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: calendarFormat,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        onFormatChanged: onFormatChanged,
        onPageChanged: onPageChanged,
        eventLoader: eventLoader,
        calendarStyle: CalendarStyle(
          markerDecoration: const BoxDecoration(
            color: Color(0xFFFF2045),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Color(0xFFFF2045),
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: const Color(0xFFFF2045).withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            color: const Color(0xFFFF2045).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          formatButtonTextStyle: const TextStyle(color: Color(0xFFFF2045)),
        ),
      ),
    );
  }
}
