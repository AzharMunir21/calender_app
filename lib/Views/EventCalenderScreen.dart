import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalenderScreen extends StatefulWidget {
  const EventCalenderScreen({Key? key}) : super(key: key);

  @override
  State<EventCalenderScreen> createState() => _EventCalenderScreenState();
}

class _EventCalenderScreenState extends State<EventCalenderScreen> {
  Map<String, List> mySelectedEvent = {};
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selecteddate;
  @override
  void initState() {
    super.initState();
    loadPreviousEvents();
    _selecteddate = _focusedDay;
  }

  loadPreviousEvents() {
    mySelectedEvent = {
      "2023-05-01": [
        {"eventTitle": "Azhar", "eventDescp": "InputConnection"},
        {"eventTitle": "Azhar", "eventDescp": "InputConnection"},
        {"eventTitle": "Azhar", "eventDescp": "InputConnection"},
      ],
      "2023-05-05": [
        {"eventTitle": "Azhar", "eventDescp": "InputConnection"},
        {"eventTitle": "Azhar", "eventDescp": "InputConnection"},
        {"eventTitle": "Azhar", "eventDescp": "InputConnection"},
      ],
      "2023-05-03": [
        {"eventTitle": "Azhar", "eventDescp": "InputConnection"}
      ],
      "2023-05-07": [
        {"eventTitle": "Azhar", "eventDescp": "InputConnection"}
      ],
    };
  }

  List _ListOffDatEvents(DateTime dateTime) {
    if (mySelectedEvent[DateFormat("yyyy-MM-dd").format(dateTime)] != null) {
      return mySelectedEvent[DateFormat("yyyy-MM-dd").format(dateTime)]!;
    } else {
      return [];
    }
  }

  _showAddEventDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Add New Event",
                textAlign: TextAlign.center,
              ),
              content: Container(
                  height: 150,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: titleController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          label: Text("Title"),
                        ),
                      ),
                      TextField(
                        controller: descriptionController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          label: Text("Description"),
                        ),
                      ),
                    ],
                  )),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      if (titleController.text.isEmpty &&
                          descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Required Tilte and description"),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        setState(() {
                          if (mySelectedEvent[DateFormat("yyyy-MM-dd")
                                  .format(_selecteddate!)] !=
                              null) {
                            mySelectedEvent[DateFormat("yyyy-MM-dd")
                                    .format(_selecteddate!)]
                                ?.add({
                              "eventTitle": titleController.text,
                              "eventDescp": descriptionController.text,
                            });
                          } else {
                            mySelectedEvent[DateFormat("yyyy-MM-dd")
                                .format(_selecteddate!)] = [
                              {
                                "eventTitle": titleController.text,
                                "eventDescp": descriptionController.text,
                              }
                            ];
                          }
                        });
                      }
                      print(titleController);
                      print(descriptionController);
                      print("new Event ${json.encode(mySelectedEvent)}");
                      titleController.clear();
                      descriptionController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text("Add Event")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEventDialog(),
          label: const Text("Add Event")),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Event Calender Example"),
      ),
      body: ListView(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2022),
            lastDay: DateTime(2024),
            startingDayOfWeek: StartingDayOfWeek.monday,
            rowHeight: 70,
            daysOfWeekHeight: 50,
            calendarStyle: const CalendarStyle(
                markerDecoration:
                    BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                selectedDecoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                weekendTextStyle: TextStyle(color: Colors.red),
                todayDecoration:
                    BoxDecoration(color: Colors.amber, shape: BoxShape.circle)),
            daysOfWeekStyle: const DaysOfWeekStyle(
                decoration: BoxDecoration(color: Colors.white),
                weekendStyle: TextStyle(color: Colors.red),
                weekdayStyle: TextStyle(color: Colors.teal)),
            headerStyle: HeaderStyle(
                // formatButtonVisible: true,
                leftChevronIcon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.teal,
                ),
                rightChevronIcon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.teal,
                ),
                titleTextStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                formatButtonTextStyle: const TextStyle(color: Colors.teal),
                formatButtonDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.red),
                    borderRadius: const BorderRadius.all(Radius.circular(5)))),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selecteddate, selectedDay)) {
                setState(() {
                  _selecteddate = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            calendarFormat: _calendarFormat,
            eventLoader: _ListOffDatEvents,
            selectedDayPredicate: (day) {
              return isSameDay(_selecteddate, day);
            },
            onFormatChanged: (CalendarFormat format) {
              print("object");
              if (_calendarFormat != format) {
                print("Azhar");
                setState(() {
                  // _calendarFormat = CalendarFormat.week;
                  _calendarFormat = format;
                });/////
              } else {
                // setState(() {});
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
          ..._ListOffDatEvents(_selecteddate!).map((myEvents) => ListTile(
                leading: const Icon(Icons.done),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text("Event Tilte ${myEvents["eventTitle"]}"),
                ),
                subtitle: Text("Description ${myEvents["eventDescp"]}"),
              ))
        ],
      ),
    );
  }
}
