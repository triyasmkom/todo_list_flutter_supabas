import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist_app/service/calendar_service.dart';

class CalendarHolidayPage extends StatefulWidget {
  const CalendarHolidayPage({super.key});

  @override
  State<CalendarHolidayPage> createState() => _CalendarHolidayPageState();
}

class _CalendarHolidayPageState extends State<CalendarHolidayPage> {
  Map<DateTime, List<String>> holidayEvents = {};
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHolidayData();
  }

  void loadHolidayData() async {
    try {
      setState(() => loading = true);

      final int currentYear = DateTime.now().year;
      final int endYear = currentYear + 2;

      Map<DateTime, List<String>> temp = {};

      for (int year = currentYear; year <= endYear; year++) {
        final holidays = await CalendarService.fetchHolidays(year.toString());

        for (var h in holidays) {
          final dateKey = DateTime(h.date.year, h.date.month, h.date.day);

          temp.putIfAbsent(dateKey, () => []);
          temp[dateKey]!.add(h.name);
        }
      }

      setState(() {
        holidayEvents = temp;
        loading = false;
      });
    } catch (e) {
      print("Error load holiday data: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kalender & Hari Libur Indonesia")),
      body:
          loading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  TableCalendar(
                    focusedDay: focusedDay,
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    eventLoader: (day) {
                      final key = DateTime(day.year, day.month, day.day);
                      return holidayEvents[key] ?? [];
                    },
                    selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        selectedDay = selected;
                        focusedDay = focused;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      markerDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Detail event di bawah kalender
                  Expanded(
                    child: ListView(
                      children: [
                        ...?holidayEvents[DateTime(
                              selectedDay?.year ?? 0,
                              selectedDay?.month ?? 0,
                              selectedDay?.day ?? 0,
                            )]
                            ?.map(
                              (e) => Card(
                                child: ListTile(
                                  title: Text(
                                    e,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
