// lib/tabs/screen_main_calender.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'package:notiskku/services/calendar_service.dart'; // loadAppointments()
import 'package:notiskku/data/event_data_source.dart'; // EventDataSource

class ScreenMainCalender extends StatefulWidget {
  const ScreenMainCalender({super.key});

  @override
  State<ScreenMainCalender> createState() => _ScreenMainCalenderState();
}

class _ScreenMainCalenderState extends State<ScreenMainCalender> {
  bool _collapsed = false; // 달력이 축소된 상태인지
  DateTime? _selectedDate; // 탭된 날짜
  List<Appointment> _appointments = []; // 전체 일정
  List<Appointment> _selectedDayEvents = []; // 탭된 날짜의 일정들

  @override
  void initState() {
    super.initState();
    loadAppointments().then((list) {
      setState(() => _appointments = list);
    });
  }

  void _handleTap(CalendarTapDetails details) {
    // (1) 달력의 셀 클릭 → 시트 오픈 모드
    if (details.targetElement == CalendarElement.calendarCell &&
        details.date != null) {
      final day = details.date!;
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);
      
      final events = _appointments.where((a) {
        final eventStart = DateTime(a.startTime.year, a.startTime.month, a.startTime.day);
        final eventEnd = DateTime(a.endTime.year, a.endTime.month, a.endTime.day);
        
        // 이벤트가 해당 날짜와 겹치는지 확인
        return eventStart.isBefore(dayEnd.add(Duration(milliseconds: 1))) && 
               eventEnd.isAfter(dayStart.subtract(Duration(milliseconds: 1)));
          }).toList();
      setState(() {
        _collapsed = true;
        _selectedDate = day;
        _selectedDayEvents = events;
      });
      return;
    }
    // (2) 시트 열려 있을 때, 다른 영역 클릭 → 닫기
    if (_collapsed) {
      setState(() {
        _collapsed = false;
        _selectedDate = null;
        _selectedDayEvents = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset('assets/images/greenlogo_fix.png', width: 40),
        ),
        title: Text(
          '학사일정',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body:
          _appointments.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  // ① 달력 전체를 GestureDetector 로 감싸서 드래그를 감지
                  Positioned.fill(
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        // 위로 드래그
                        if (details.delta.dy < -5 && !_collapsed) {
                          final today = DateTime.now();
                          final todayStart = DateTime(today.year, today.month, today.day);
                          final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);
                          
                          final events = _appointments.where((a) {
                            final eventStart = DateTime(a.startTime.year, a.startTime.month, a.startTime.day);
                            final eventEnd = DateTime(a.endTime.year, a.endTime.month, a.endTime.day);
                            
                            // 이벤트가 오늘과 겹치는지 확인
                            return eventStart.isBefore(todayEnd.add(Duration(days: 1))) && 
                                   eventEnd.isAfter(todayStart.subtract(Duration(days: 1)));
                              }).toList();

                          setState(() {
                            _collapsed = true;
                            _selectedDate = today;
                            _selectedDayEvents = events;
                          });
                        }
                        // 아래로 드래그 → 닫기
                        else if (details.delta.dy > 5 && _collapsed) {
                          setState(() {
                            _collapsed = false;
                            _selectedDate = null;
                            _selectedDayEvents = [];
                          });
                        }
                      },

              child: SfCalendar(
  view: CalendarView.month,
  showNavigationArrow: true,
  headerHeight: 50,
  headerStyle: CalendarHeaderStyle(
    textAlign: TextAlign.center,
    backgroundColor: Colors.white,
    textStyle: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),

  dataSource: EventDataSource(_appointments),
  onTap: _handleTap,

  // ───────── MonthViewSettings ─────────
  monthViewSettings: MonthViewSettings(
    appointmentDisplayMode: _collapsed
        ? MonthAppointmentDisplayMode.none
        : MonthAppointmentDisplayMode.appointment,
        appointmentDisplayCount: 3,
  ),

  // ───────── Appointment Builder ─────────
  // collapsed 가 아닐 때만, 셀을 넘어 이어지는 멀티데이 바(bar)를 커스터마이징
  appointmentBuilder: _collapsed
      ? null
      : (BuildContext context, CalendarAppointmentDetails details) {
          final appt = details.appointments.first;
          final double barHeight = 10.h;  // 원하는 높이
          return Align(
      alignment: Alignment.topLeft,    // 셀 상단에 붙이기
      child: GestureDetector(
        onTap: () {
          final day = appt.startTime;
          final dayStart = DateTime(day.year, day.month, day.day);
          final dayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);
          
          final events = _appointments.where((a) {
            final eventStart = DateTime(a.startTime.year, a.startTime.month, a.startTime.day);
            final eventEnd = DateTime(a.endTime.year, a.endTime.month, a.endTime.day);
            
            return eventStart.isBefore(dayEnd.add(Duration(milliseconds: 1))) && 
                   eventEnd.isAfter(dayStart.subtract(Duration(milliseconds: 1)));
          }).toList();
          
          setState(() {
            _collapsed = true;
            _selectedDate = dayStart;
            _selectedDayEvents = events;
          });
        },
        child: Container(
          width: details.bounds.width,   // 셀 너비만큼
          height: barHeight,             // 고정 높이
          margin: EdgeInsets.only(bottom: details.bounds.height - barHeight),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: const Color(0xB20B5B42),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            appt.subject,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  },

  // ───────── Month Cell Builder ─────────
  // collapsed 일 때 셀 단위 커스텀 (기존 _buildCustomCell)
  monthCellBuilder: _collapsed ? _buildCustomCell : null,
)
                    ),
                  ),

                  // ② 기존 DraggableScrollableSheet (포지션 및 NotificationListener 포함)
                  if (_collapsed)
                    Positioned.fill(
                      child: NotificationListener<
                        DraggableScrollableNotification
                      >(
                        onNotification: (notification) {
                          if (notification.extent <=
                              notification.minExtent + 0.01) {
                            Future.microtask(() {
                              if (mounted) {
                                setState(() {
                                  _collapsed = false;
                                  _selectedDate = null;
                                  _selectedDayEvents = [];
                                });
                              }
                            });
                          }
                          return true;
                        },
                        child: DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.4,
                          minChildSize: 0.0, // 시트를 완전히 숨길 수 있도록 0.0으로 설정
                          maxChildSize: 0.8,
                          builder: (ctx, scrollCtrl) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8E8E8),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              // (옵션) 상단에 Drag 핸들 표시
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 8.h,
                                      bottom: 4.h,
                                    ),
                                    width: 40.w,
                                    height: 4.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2.h),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                    ),
                                    child: Text(
                                      DateFormat(
                                        'M월 d일 (EEE)',
                                        'ko',
                                      ).format(_selectedDate!),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Expanded(
                                    child: ListView.separated(
                                      controller: scrollCtrl,
                                      itemCount: _selectedDayEvents.length,
                                      separatorBuilder:
                                          (_, __) =>
                                              Divider(color: Color(0XFF979797),
                                              thickness: 1.5,),
                                                
                                      itemBuilder: (_, i) {
                                        final ev = _selectedDayEvents[i];
                                        final time = ev.isAllDay
                                            ? ''
                                            : '${DateFormat.Hm().format(ev.startTime)} – '
                                                '${DateFormat.Hm().format(ev.endTime)}';
                                        return ListTile(
                                          title: Text(
                                            ev.subject,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                            time,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
    );
  }

  Widget _buildCustomCell(
      BuildContext context, MonthCellDetails details) {
    final day = details.date;

    // // 그날의 이벤트 모두 취합
    // final eventsOnDay = _appointments.where((a) {
    //   return !a.startTime.isAfter(day) &&
    //          !a.endTime.isBefore(day.add(const Duration(seconds: 1)));
    // }).toList();
        // 그날의 이벤트 모두 취합
      final eventsOnDay = _appointments.where((a) {
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);
      final eventStart = DateTime(a.startTime.year, a.startTime.month, a.startTime.day);
      final eventEnd = DateTime(a.endTime.year, a.endTime.month, a.endTime.day);
      
      // 이벤트가 해당 날짜와 겹치는지 확인
      return eventStart.isBefore(dayEnd.add(Duration(milliseconds: 1))) && 
             eventEnd.isAfter(dayStart.subtract(Duration(milliseconds: 1)));
    }).toList();

    final totalEvents = eventsOnDay.length;
      print('⚠️ Date=$day, totalEvents=$totalEvents');  // ← 여기!
    final isThisMonth = day.month == details.visibleDates[15].month;
    final textColor = isThisMonth ? Colors.black : Colors.grey;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 날짜
          Text(
            '${day.day}',
            style: TextStyle(
              color: textColor, 
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          // 일정 표시 영역
          if (totalEvents > 0)
            // 시트가 올라온 상태면 점 하나만, 아니면 상세 표시
            if (_collapsed)
              Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text(
                  '●',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: const Color(0xB20B5B42),
                  ),
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...eventsOnDay.take(3).map((event) => Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: GestureDetector(
                          onTap: () {
                            final dayStart = DateTime(day.year, day.month, day.day);
                            final dayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);
                            
                            final events = _appointments.where((a) {
                              final eventStart = DateTime(a.startTime.year, a.startTime.month, a.startTime.day);
                              final eventEnd = DateTime(a.endTime.year, a.endTime.month, a.endTime.day);
                              
                              return eventStart.isBefore(dayEnd.add(Duration(milliseconds: 1))) && 
                                     eventEnd.isAfter(dayStart.subtract(Duration(milliseconds: 1)));
                            }).toList();
                            
                            setState(() {
                              _collapsed = true;
                              _selectedDate = dayStart;
                              _selectedDayEvents = events;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 12.h,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2.h),
                          ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Text(
                            event.subject,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                          ),
                        ),
                      )),
                      if (totalEvents > 2)
                        Container(
                          width: double.infinity,
                          height: 8.h,
                          alignment: Alignment.center,
                          child: Text(
                            '●',
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: Colors.green,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}