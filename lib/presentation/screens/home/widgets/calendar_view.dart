import 'package:flutter/material.dart';
import 'package:srl_app/core/utils/build_context_extensions.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  static const dayNames = {
    1: "Mo",
    2: "Di",
    3: "Mi",
    4: "Do",
    5: "Fr",
    6: "Sa",
    7: "So",
  };

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime(2025, 11, 3);
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    // Show 6 days around today (1 before, today, 4 after)
    List<DateTime> weekDates = List<DateTime>.generate(6, (index) {
      return today.subtract(Duration(days: 1)).add(Duration(days: index));
    });

    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekDates
            .map(
              (DateTime e) => _calendarDay(
                context,
                dayNames[e.weekday]!,
                e.day.toString(),
                e.day == today.day,
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget _calendarDay(
  BuildContext context,
  String dayName,
  String day,
  bool isToday,
) {
  return Container(
    width: 50.0,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    decoration: BoxDecoration(
      color: isToday
          ? context.colorScheme.primary
          : context.colorScheme.tertiary,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      border: isToday
          ? Border.all(color: context.colorScheme.primary)
          : Border.all(color: context.colorScheme.onTertiary),
    ),
    child: Column(
      children: <Widget>[
        Text(
          dayName,
          style: context.textTheme.bodySmall!.copyWith(
            fontSize: 14,
            color: isToday
                ? context.colorScheme.onPrimary
                : context.colorScheme.onSurface,
          ),
        ),
        Text(
          day,
          style: context.textTheme.headlineSmall!.copyWith(
            color: isToday
                ? context.colorScheme.onPrimary
                : context.colorScheme.onTertiary,
          ),
        ),
      ],
    ),
  );
}
