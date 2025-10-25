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
  bool _collapsed = false; // 달력이 축소된 상태인지 (모달이 열렸을 때 true)
  DateTime? _selectedDate; // 탭된 날짜
  List<Appointment> _appointments = []; // 전체 일정
  List<Appointment> _selectedDayEvents = []; // 탭된 날짜의 일정들

  @override
  void initState() {
    super.initState();
    loadAppointments().then((list) {
      if (!mounted) return;
      setState(() => _appointments = list);
    });
  }

  void _handleTap(CalendarTapDetails details) {
    // 달력 셀 클릭 → 해당 날짜의 이벤트 수집 후 모달 오픈
    if (details.targetElement == CalendarElement.calendarCell &&
        details.date != null) {
      final day = details.date!;
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);

      final events =
          _appointments.where((a) {
            final eventStart = DateTime(
              a.startTime.year,
              a.startTime.month,
              a.startTime.day,
            );
            final eventEnd = DateTime(
              a.endTime.year,
              a.endTime.month,
              a.endTime.day,
            );
            return eventStart.isBefore(
                  dayEnd.add(const Duration(milliseconds: 1)),
                ) &&
                eventEnd.isAfter(
                  dayStart.subtract(const Duration(milliseconds: 1)),
                );
          }).toList();

      setState(() {
        _collapsed = true;
        _selectedDate = dayStart;
        _selectedDayEvents = events;
      });
      return;
    }

    // 다른 영역 클릭 시: 모달형으로 바뀌었으므로 즉시 닫기만 처리
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
        leading: const Padding(
          padding: EdgeInsets.all(10),
          child: Image(
            image: AssetImage('assets/images/greenlogo_fix.png'),
            width: 40,
          ),
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
                  // 달력 영역 제스처(위/아래 드래그)
                  Positioned.fill(
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        // 위로 드래그 → 오늘 일정으로 모달 열기
                        if (details.delta.dy < -5 && !_collapsed) {
                          final today = DateTime.now();
                          final todayStart = DateTime(
                            today.year,
                            today.month,
                            today.day,
                          );
                          final todayEnd = DateTime(
                            today.year,
                            today.month,
                            today.day,
                            23,
                            59,
                            59,
                          );

                          final events =
                              _appointments.where((a) {
                                final eventStart = DateTime(
                                  a.startTime.year,
                                  a.startTime.month,
                                  a.startTime.day,
                                );
                                final eventEnd = DateTime(
                                  a.endTime.year,
                                  a.endTime.month,
                                  a.endTime.day,
                                );
                                return eventStart.isBefore(
                                      todayEnd.add(
                                        const Duration(milliseconds: 1),
                                      ),
                                    ) &&
                                    eventEnd.isAfter(
                                      todayStart.subtract(
                                        const Duration(milliseconds: 1),
                                      ),
                                    );
                              }).toList();

                          setState(() {
                            _collapsed = true;
                            _selectedDate = todayStart;
                            _selectedDayEvents = events;
                          });
                        }
                        // 아래로 드래그 → (모달은 스와이프로 닫힘) 내부 상태만 정리
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
                          appointmentDisplayMode:
                              _collapsed
                                  ? MonthAppointmentDisplayMode.none
                                  : MonthAppointmentDisplayMode.appointment,
                          appointmentDisplayCount: 3,
                        ),

                        // ───────── Appointment Builder ─────────
                        // 모달이 닫혀 있을 때만 셀 위 바(멀티데이) 보여주기
                        appointmentBuilder:
                            _collapsed
                                ? null
                                : (
                                  BuildContext context,
                                  CalendarAppointmentDetails details,
                                ) {
                                  final appt =
                                      details.appointments.first as Appointment;
                                  final double barHeight = 10.h; // 원하는 높이
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        final day = appt.startTime;
                                        final dayStart = DateTime(
                                          day.year,
                                          day.month,
                                          day.day,
                                        );
                                        final dayEnd = DateTime(
                                          day.year,
                                          day.month,
                                          day.day,
                                          23,
                                          59,
                                          59,
                                        );

                                        final events =
                                            _appointments.where((a) {
                                              final eventStart = DateTime(
                                                a.startTime.year,
                                                a.startTime.month,
                                                a.startTime.day,
                                              );
                                              final eventEnd = DateTime(
                                                a.endTime.year,
                                                a.endTime.month,
                                                a.endTime.day,
                                              );
                                              return eventStart.isBefore(
                                                    dayEnd.add(
                                                      const Duration(
                                                        milliseconds: 1,
                                                      ),
                                                    ),
                                                  ) &&
                                                  eventEnd.isAfter(
                                                    dayStart.subtract(
                                                      const Duration(
                                                        milliseconds: 1,
                                                      ),
                                                    ),
                                                  );
                                            }).toList();

                                        setState(() {
                                          _collapsed = true;
                                          _selectedDate = dayStart;
                                          _selectedDayEvents = events;
                                        });
                                      },
                                      child: Container(
                                        width: details.bounds.width,
                                        height: barHeight,
                                        margin: EdgeInsets.only(
                                          bottom:
                                              details.bounds.height - barHeight,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xB20B5B42),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
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
                        // 일관된 스타일 적용을 위해 항상 커스텀 셀 사용
                        monthCellBuilder: _buildCustomCell,
                      ),
                    ),
                  ),

                  // ② 바텀시트 (Stack 내부에서 부드럽게 애니메이션)
                  if (_collapsed)
                    Positioned.fill(
                      child: NotificationListener<DraggableScrollableNotification>(
                        onNotification: (notification) {
                          if (notification.extent <= notification.minExtent + 0.01) {
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
                          minChildSize: 0.0,
                          maxChildSize: 0.8,
                          builder: (ctx, scrollCtrl) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8E8E8),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
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
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      child: Text(
                                        DateFormat(
                                          'M월 d일 EEE요일',
                                          'ko',
                                        ).format(_selectedDate!),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Divider(
                                    color: Color(0XFF979797),
                                    thickness: 1.5,
                                    height: 1,
                                  ),
                                  SizedBox(height: 8.h),
                                  Expanded(
                                    child: ListView.separated(
                                      controller: scrollCtrl,
                                      itemCount: _selectedDayEvents.length,
                                      separatorBuilder:
                                          (_, __) =>
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                                child: Divider(
                                                  color: Color(0xFFD9D9D9),
                                                  thickness: 0.5,
                                                ),
                                              ),
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

  Widget _buildCustomCell(BuildContext context, MonthCellDetails details) {
    final day = details.date;

    // 해당 날짜의 이벤트 수집
    final eventsOnDay = _appointments.where((a) {
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);
      final eventStart = DateTime(
        a.startTime.year,
        a.startTime.month,
        a.startTime.day,
      );
      final eventEnd = DateTime(
        a.endTime.year,
        a.endTime.month,
        a.endTime.day,
      );

      return eventStart.isBefore(
            dayEnd.add(const Duration(milliseconds: 1)),
          ) &&
          eventEnd.isAfter(
            dayStart.subtract(const Duration(milliseconds: 1)),
          );
    }).toList();

    final totalEvents = eventsOnDay.length;
    final isThisMonth = day.month == details.visibleDates[15].month;
    final textColor = isThisMonth ? Colors.black : Colors.grey;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 일자 표시 영역
          Padding( // ← ✅ 상단 여백을 위해 Padding 추가
            padding: EdgeInsets.only(top: 6.h), // 기본 셀과 비슷하게
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: textColor,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),

          // 바텀시트가 열려있을 때만 일정 있으면 점 표시
          if (_collapsed && totalEvents > 0)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(
                '●',
                style: TextStyle(
                  fontSize: 8.sp,
                  color: const Color(0xB20B5B42),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
