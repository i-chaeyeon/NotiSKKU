// widget/notify/foreground_message_listener.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notiskku/firebase/notification_provider.dart';

class ForegroundMessageListener extends ConsumerStatefulWidget {
  const ForegroundMessageListener({
    super.key,
    this.behavior = SnackBarBehavior.floating,
    this.duration = const Duration(seconds: 3),
  });

  final SnackBarBehavior behavior;
  final Duration duration;

  @override
  ConsumerState<ForegroundMessageListener> createState() =>
      _ForegroundMessageListenerState();
}

class _ForegroundMessageListenerState
    extends ConsumerState<ForegroundMessageListener> {
  ProviderSubscription<NotificationProvider>? _sub;

  @override
  void initState() {
    super.initState();

    // initState에서의 구독은 listenManual로 관리
    _sub = ref.listenManual<NotificationProvider>(notificationProvider, (
      prev,
      next,
    ) {
      if (!mounted) return;

      // (중복 방지) 읽고 비우기 사용
      final msg = next.takeMessage(); // ← takeMessage() 추가했으니 사용 권장
      if (msg == null) return;

      final title = msg.notification?.title;
      final body = msg.notification?.body ?? '새 메시지가 도착했습니다.';

      // 프레임 이후에 SnackBar 표시(컨텍스트 안전)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              title != null ? '$title\n$body' : body,
              style: const TextStyle(color: Colors.white),
            ),
            behavior: widget.behavior,
            duration: widget.duration,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin: const EdgeInsets.all(16.0),
            backgroundColor: const Color.fromARGB(255, 75, 73, 73),
            elevation: 4.0,
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _sub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
