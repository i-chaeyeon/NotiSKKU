// lib/tabs/screen_main_calender.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'package:notiskku/services/calendar_service.dart'; // loadAppointments()
import 'package:notiskku/data/event_data_source.dart'; // EventDataSource

// ─────────────────────────────────────────────────────────────────────────────
// 유틸: 날짜 범위 겹침/필터 공통 로직
// ─────────────────────────────────────────────────────────────────────────────

bool _isOverlap(Appointment a, DateTime start, DateTime end) {
  final eventStart = DateTime(
    a.startTime.year,
    a.startTime.month,
    a.startTime.day,
  );
  final eventEnd = DateTime(a.endTime.year, a.endTime.month, a.endTime.day);
  // [start, end] 와 [eventStart, eventEnd]의 교집합 여부 판단
  return eventStart.isBefore(end.add(const Duration(milliseconds: 1))) &&
      eventEnd.isAfter(start.subtract(const Duration(milliseconds: 1)));
}

List<Appointment> _eventsInRange(
  List<Appointment> all,
  DateTime start,
  DateTime end,
) {
  return all.where((a) => _isOverlap(a, start, end)).toList();
}

List<Appointment> _eventsOnDay(List<Appointment> all, DateTime day) {
  final dayStart = DateTime(day.year, day.month, day.day);
  final dayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);
  return _eventsInRange(all, dayStart, dayEnd);
}

// ─────────────────────────────────────────────────────────────────────────────
// 메인 화면
// ─────────────────────────────────────────────────────────────────────────────

class ScreenMainCalender extends StatefulWidget {
  const ScreenMainCalender({super.key});

  @override
  State<ScreenMainCalender> createState() => _ScreenMainCalenderState();
}

class _ScreenMainCalenderState extends State<ScreenMainCalender> {
  bool _collapsed = false;
  DateTime? _selectedDate;
  List<Appointment> _appointments = [];
  List<Appointment> _selectedDayEvents = [];

  double _sheetExtent = 0.0; // ← ✅ 시트 현재 비율 (0.0 ~ 0.8)
  // 날짜 이동: deltaDays(좌우 스와이프) 반영
  void _shiftSelectedDate(int deltaDays) {
    if (_selectedDate == null || deltaDays == 0) return;
    final newDay = _selectedDate!.add(Duration(days: deltaDays));
    final start = DateTime(newDay.year, newDay.month, newDay.day);
    final end = DateTime(newDay.year, newDay.month, newDay.day, 23, 59, 59);
    final events = _eventsInRange(_appointments, start, end);
    setState(() {
      _selectedDate = start;
      _selectedDayEvents = events;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAppointments().then((list) {
      if (!mounted) return;
      setState(() => _appointments = list);
    });
  }

  // 날짜 오픈/닫기 공통 핸들러
  void _openForDate(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59);
    final events = _eventsInRange(_appointments, start, end);
    setState(() {
      _collapsed = true;
      _selectedDate = start;
      _selectedDayEvents = events;
    });
  }

  void _closeSheet() {
    setState(() {
      _collapsed = false;
      _selectedDate = null;
      _selectedDayEvents = [];
    });
  }

  // SfCalendar onTap 대응
  void _handleTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.calendarCell &&
        details.date != null) {
      _openForDate(details.date!);
      return;
    }
    if (_collapsed) _closeSheet();
  }

  // 상/하 드래그 제스처 대응
  void _handleVerticalDrag(DragUpdateDetails details) {
    if (details.delta.dy < -5 && !_collapsed) {
      final today = DateTime.now();
      _openForDate(today);
    } else if (details.delta.dy > 5 && _collapsed) {
      _closeSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final scheme = Theme.of(context).colorScheme;

    final size = MediaQuery.of(context).size;

    final double calendarBottomInset = _collapsed ? size.height * 0.3195 : 0.0;
    return Scaffold(
      appBar: const _CalendarAppBar(),
      body:
          _appointments.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  // ① 달력 뷰 (시트 높이만큼 bottom inset 주기)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: calendarBottomInset, // ✅ 고정 50%
                    child: _CalendarMonthView(
                      appointments: _appointments,
                      collapsed: _collapsed,
                      onTap: _handleTap,
                      onVerticalDragUpdate: _handleVerticalDrag,
                      onTapAppointmentPill: (DateTime day) => _openForDate(day),
                      monthCellBuilder:
                          (ctx, details) => _MonthCell(
                            day: details.date,
                            visibleDates: details.visibleDates,
                            totalEvents:
                                _eventsOnDay(
                                  _appointments,
                                  details.date,
                                ).length,
                            collapsed: _collapsed,
                          ),
                    ),
                  ),

                  // ② 바텀시트
                  if (_collapsed)
                    Positioned.fill(
                      child: _EventBottomSheet(
                        selectedDate: _selectedDate!,
                        events: _selectedDayEvents,
                        onMinExtentClose: () {
                          setState(() {
                            _sheetExtent = 0.0; // ← ✅ 닫힐 때 캘린더 높이 원복
                          });
                          _closeSheet();
                        },
                        onExtentChanged: (extent) {
                          // ← ✅ 변화 시마다 갱신
                          if (!mounted) return;
                          setState(() => _sheetExtent = extent);
                        },
                        onSwipeDay: _shiftSelectedDate,
                      ),
                    ),
                ],
              ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 앱바
// ─────────────────────────────────────────────────────────────────────────────

class _CalendarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CalendarAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.all(10),
        child: Image(
          image: AssetImage('assets/images/greenlogo_fix.png'),
          width: 40,
          color: scheme.primary,
        ),
      ),
      title: const Text('학사일정'),
      iconTheme: IconThemeData(color: scheme.primary),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 달력 MonthView 래퍼
// ─────────────────────────────────────────────────────────────────────────────

class _CalendarMonthView extends StatelessWidget {
  const _CalendarMonthView({
    required this.appointments,
    required this.collapsed,
    required this.onTap,
    required this.onVerticalDragUpdate,
    required this.onTapAppointmentPill,
    required this.monthCellBuilder,
  });

  final List<Appointment> appointments;
  final bool collapsed;
  final CalendarTapCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final void Function(DateTime day) onTapAppointmentPill;
  final Widget Function(BuildContext, MonthCellDetails) monthCellBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: SfCalendar(
        view: CalendarView.month,
        showNavigationArrow: true,
        headerHeight: 50,
        headerStyle: CalendarHeaderStyle(
          backgroundColor: scheme.surface,
          textAlign: TextAlign.center,
          textStyle: text.headlineMedium,
        ),
        dataSource: EventDataSource(appointments),
        onTap: onTap,

        // MonthViewSettings
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode:
              collapsed
                  ? MonthAppointmentDisplayMode.none
                  : MonthAppointmentDisplayMode.appointment,
          appointmentDisplayCount: 3,
        ),

        appointmentBuilder: null,
        // Month cell builder (항상 커스텀)
        monthCellBuilder: monthCellBuilder,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 월 셀 (일자 + 점 표시)
// ─────────────────────────────────────────────────────────────────────────────

class _MonthCell extends StatelessWidget {
  const _MonthCell({
    required this.day,
    required this.visibleDates,
    required this.totalEvents,
    required this.collapsed,
  });

  final DateTime day;
  final List<DateTime> visibleDates;
  final int totalEvents;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final isThisMonth = day.month == visibleDates[15].month;
    final textColor = isThisMonth ? scheme.onPrimary : scheme.secondary;

    // ⬇️ 추가: 오늘 여부 판별
    final now = DateTime.now();
    final isToday =
        day.year == now.year && day.month == now.month && day.day == now.day;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.secondary, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 일자
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child:
                isToday
                    // 오늘이면 배경 칩으로 강조
                    ? Container(
                      width: 24.w,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: scheme.primary.withAlpha(180),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: scheme.onPrimary,
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    )
                    // 일반 날짜
                    : Text(
                      '${day.day}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
          ),

          // 모달 열림 + 일정 존재 시 점 표시
          if (collapsed && totalEvents > 0)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(
                '●',
                style: TextStyle(fontSize: 8.sp, color: scheme.primary),
              ),
            ),
        ],
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// 바텀시트 (부드러운 전환 + 핸들/헤더 드래그 가능)
// ─────────────────────────────────────────────────────────────────────────────

class _EventBottomSheet extends StatefulWidget {
  const _EventBottomSheet({
    required this.selectedDate,
    required this.events,
    required this.onMinExtentClose,
    required this.onExtentChanged,
    required this.onSwipeDay,
  });

  final DateTime selectedDate;
  final List<Appointment> events;
  final VoidCallback onMinExtentClose;
  final ValueChanged<double> onExtentChanged;
  final ValueChanged<int> onSwipeDay;

  @override
  State<_EventBottomSheet> createState() => _EventBottomSheetState();
}

class _EventBottomSheetState extends State<_EventBottomSheet> {
  final DraggableScrollableController _dragCtrl =
      DraggableScrollableController();
  bool _isAnimating = false; // 중복 애니메이션 방지

  double _accumDx = 0; // ✅ 수평 이동 누적

  @override
  void initState() {
    super.initState();
    // 처음 등장 시 0.0 → 0.4로 부드럽게 열림

    // 컨트롤러 변화 → 부모에 extent 전달
    _dragCtrl.addListener(() {
      if (!mounted) return;
      widget.onExtentChanged(_dragCtrl.size); // ← ✅ 실시간 전달
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _isAnimating = true;
        await _dragCtrl.animateTo(
          0.4,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
        );
        if (mounted) widget.onExtentChanged(_dragCtrl.size);
      } finally {
        if (mounted) _isAnimating = false;
      }
    });
  }

  Future<void> _animateCloseAndNotify() async {
    if (_isAnimating) return;
    _isAnimating = true;
    try {
      // 0.0까지 스르륵
      await _dragCtrl.animateTo(
        0.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
      );
      if (mounted) widget.onExtentChanged(0.0);
    } finally {
      if (!mounted) return;
      _isAnimating = false;
      // 부모에게 닫힘 알림
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onMinExtentClose(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final scheme = Theme.of(context).colorScheme;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        widget.onExtentChanged(notification.extent);
        // 40% 이하로 내려가면 부드럽게 닫힘
        if (notification.extent <= 0.40 && !_isAnimating) {
          _animateCloseAndNotify();
        }
        return true;
      },
      child: DraggableScrollableSheet(
        controller: _dragCtrl,
        expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.0,
        maxChildSize: 0.8,
        builder: (ctx, scrollCtrl) {
          final scheme = Theme.of(ctx).colorScheme;
          return Container(
            decoration: BoxDecoration(
              color: scheme.secondary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              top: false,
              child: ListView(
                controller: scrollCtrl, // ← ✅ 시트 전체(핸들/헤더/콘텐츠) 스크롤/드래그
                padding: EdgeInsets.zero,
                children: [
                  // 핸들
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: scheme.outline,
                        borderRadius: BorderRadius.circular(2.h),
                      ),
                    ),
                  ),

                  // 헤더
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      DateFormat(
                        'M월 d일 EEE요일',
                        'ko',
                      ).format(widget.selectedDate),
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),
                  Divider(color: scheme.outline, thickness: 1.5, height: 1),
                  SizedBox(height: 8.h),

                  // 일정 리스트(바깥 ListView가 스크롤 담당)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragStart: (_) => _accumDx = 0,
                    onHorizontalDragUpdate: (d) => _accumDx += d.delta.dx,
                    onHorizontalDragEnd: (_) {
                      // 80px 당 하루 이동, 반올림. 왼쪽(음수 dx) ⇒ +일
                      final steps = -(_accumDx / 80.0).round();
                      if (steps != 0) widget.onSwipeDay(steps);
                      _accumDx = 0;
                    },
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.events.length,
                      separatorBuilder:
                          (_, __) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Divider(
                              color: scheme.surface,
                              thickness: 0.5,
                            ),
                          ),
                      itemBuilder:
                          (_, i) => _EventListTile(event: widget.events[i]),
                    ),
                  ),

                  SizedBox(height: 8.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 일정 타일
// ─────────────────────────────────────────────────────────────────────────────

class _EventListTile extends StatelessWidget {
  const _EventListTile({required this.event});

  final Appointment event;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // 날짜 범위 포맷
    final startDate = DateTime(
      event.startTime.year,
      event.startTime.month,
      event.startTime.day,
    );
    final endDate = DateTime(
      event.endTime.year,
      event.endTime.month,
      event.endTime.day,
    );

    final isSameDay =
        startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day;

    final String dateRange =
        isSameDay
            ? DateFormat('M.d E', 'ko').format(startDate)
            : '${DateFormat('M.d E', 'ko').format(startDate)} - ${DateFormat('M.d E', 'ko').format(endDate)}';

    return ListTile(
      title: Text(
        event.subject,
        style: TextStyle(color: scheme.onSurface),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(dateRange, style: TextStyle(color: scheme.outline)),
    );
  }
}
