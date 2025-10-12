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

  Future<void> _openEventSheet() async {
    if (!mounted || _selectedDate == null) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        // 모달 내부에서 드래그 가능한 바텀시트: 초기/최소/최대 높이 지정
        return DraggableScrollableSheet(
          initialChildSize: 0.4, // ← 중간(초기) 높이
          minChildSize: 0.25, // ← 최소 높이
          maxChildSize: 0.8, // ← 최대 높이 (예전 maxChildSize와 동일)
          builder: (context, scrollCtrl) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE8E8E8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: CustomScrollView(
                controller: scrollCtrl, // 드래그 연동을 위해 반드시 사용
                slivers: [
                  // 상단 핸들 + 제목 영역
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: 8.h),
                        Container(
                          width: 40.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2.h),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            top: 6.h,
                            bottom: 8.h,
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
                      ],
                    ),
                  ),

                  // 일정 리스트
                  SliverList.separated(
                    itemCount: _selectedDayEvents.length,
                    separatorBuilder:
                        (_, __) => const Divider(
                          color: Color(0XFF979797),
                          thickness: 1.5,
                        ),
                    itemBuilder: (_, i) {
                      final ev = _selectedDayEvents[i];
                      final time =
                          ev.isAllDay
                              ? ''
                              : '${DateFormat.Hm().format(ev.startTime)} – ${DateFormat.Hm().format(ev.endTime)}';
                      return ListTile(
                        title: Text(
                          ev.subject,
                          style: const TextStyle(color: Colors.black),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          time,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    // 닫힐 때 상태 초기화
    if (mounted) {
      setState(() {
        _collapsed = false;
        _selectedDate = null;
        _selectedDayEvents = [];
      });
    }
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
      _openEventSheet(); // ← 모달 열기
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
                          _openEventSheet(); // ← 모달 열기
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
                                        _openEventSheet(); // ← 모달 열기
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
                        // 모달이 열린 상태에선 점만 표시, 닫혀 있으면 상세 표시
                        monthCellBuilder: _collapsed ? _buildCustomCell : null,
                      ),
                    ),
                  ),

                  // ✅ DraggableScrollableSheet 완전 제거
                ],
              ),
    );
  }

  Widget _buildCustomCell(BuildContext context, MonthCellDetails details) {
    final day = details.date;

    // 해당 날짜의 이벤트 수집
    final eventsOnDay =
        _appointments.where((a) {
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
            // 모달이 열린 상태면 점 하나만
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
            // 모달이 닫혀 있으면 이벤트 3개까지 미니바로 표시
            else
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...eventsOnDay.take(3).map((event) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 0),
                          child: GestureDetector(
                            onTap: () {
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
                                            const Duration(milliseconds: 1),
                                          ),
                                        ) &&
                                        eventEnd.isAfter(
                                          dayStart.subtract(
                                            const Duration(milliseconds: 1),
                                          ),
                                        );
                                  }).toList();

                              setState(() {
                                _collapsed = true;
                                _selectedDate = dayStart;
                                _selectedDayEvents = events;
                              });
                              _openEventSheet(); // ← 모달 열기
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
                        );
                      }),
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
