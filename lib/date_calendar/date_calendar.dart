import 'dart:collection';

import 'package:diary/util/schedule_utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DateCalendar extends StatefulWidget {
  const DateCalendar({Key? key}) : super(key: key);

  @override
  State<DateCalendar> createState() => _DateCalendarState();
}

class _DateCalendarState extends State<DateCalendar> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final user = FirebaseAuth.instance.currentUser;

  LinkedHashMap<DateTime, List<Event>> map =
      LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
  @override
  void initState() {
    super.initState();
    getMemoData();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return map[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _createEvent(DateTime selectedDay, DateTime focusedDay, String memo) {
    List<Event> setEvent = [];
    setState(() {
      //setEvent.clear();
      setEvent.add(Event(memo));
      print(setEvent);
      map.addAll({selectedDay: setEvent});
    });
  }

  getMemoData() {
    FirebaseFirestore.instance
        .collection('schedule')
        .get()
        .then((QuerySnapshot snapshot) {
      print(snapshot.docs[0]['memo']);
      for (int i = 0; i < snapshot.docs.length; i++) {
        Timestamp time = snapshot.docs[i]['data'];
        var date = DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000);
        String memo = snapshot.docs[i]['memo'] ?? '';
        print(map);
        if (map.containsKey(date)) {
          map[date]?.add(Event(memo));
        } else {
          List<Event> memoList = [];
          memoList.add(Event(memo));
          map.addAll({date: memoList});
        }

        print(map);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('TableCalendar - Events'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            onFormatChanged: null,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            onDayLongPressed: (selectedDay, focusedDay) {
              String memo = '';
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: AlertDialog(
                        alignment: Alignment.center,
                        title: const Text('메모'),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                _createEvent(selectedDay, focusedDay, memo);
                                try {
                                  FirebaseFirestore.instance
                                      .collection('schedule')
                                      .add({
                                    'time': DateTime.now(),
                                    'userId': user!.uid,
                                    'data': selectedDay,
                                    'memo': memo
                                  });
                                  map.clear();
                                  getMemoData();
                                  Get.snackbar('저장', '스케줄 저장 완료!');
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('에러나옴'),
                                      backgroundColor: Colors.blue,
                                    ));
                                  }
                                }
                                Navigator.pop(context);
                              },
                              child: const Text('작성'))
                        ],
                        actionsAlignment: MainAxisAlignment.center,
                        content: SizedBox(
                          width: 200,
                          height: 150,
                          child: TextFormField(
                            minLines: 4,
                            maxLines: 10,
                            style: const TextStyle(fontSize: 20),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '내용(10줄까지만)'),
                            onChanged: (value) {
                              setState(() {
                                memo = value;
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
