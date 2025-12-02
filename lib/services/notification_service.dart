import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const int _notificationId = 0;

  static Future<void> init() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Setting iOS: requestAlertPermission false dulu, kita minta manual nanti
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  // --- FUNGSI MINTA IZIN (UPDATE) ---
  static Future<bool> requestPermissions() async {
    bool? granted = false;

    if (Platform.isAndroid) {
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidImplementation != null) {
        granted = await androidImplementation.requestNotificationsPermission();
      }
    } else if (Platform.isIOS) {
      final iosImplementation = _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      if (iosImplementation != null) {
        granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    }

    return granted ?? false;
  }

  // --- FUNGSI MINTA IZIN EXACT ALARM (Android 13+) ---
  static Future<bool> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidImplementation != null) {
        // Cek apakah exact alarm sudah diizinkan
        final bool? canScheduleExactAlarms = await androidImplementation
            .canScheduleExactNotifications();

        if (canScheduleExactAlarms == false) {
          // Minta izin exact alarm
          return await androidImplementation.requestExactAlarmsPermission() ??
              false;
        }

        return canScheduleExactAlarms ?? false;
      }
    }

    return true; // iOS tidak perlu izin khusus
  }
  // ----------------------------------

  static Future<void> scheduleDailyNotification({
    required int hour,
    required int minute,
  }) async {
    await cancelNotification();

    // Cek dan minta izin exact alarm jika diperlukan
    if (Platform.isAndroid) {
      final hasExactAlarmPermission = await requestExactAlarmPermission();
      if (!hasExactAlarmPermission) {
        print('Exact alarm permission not granted');
        return;
      }
    }

    try {
      await _notifications.zonedSchedule(
        _notificationId,
        'Waktunya Latihan! 💪',
        'Jangan lupa target mingguanmu. Yuk bakar kalori sekarang!',
        _nextInstanceOfTime(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_workout_channel',
            'Daily Workout',
            channelDescription: 'Reminder untuk latihan harian',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  static Future<void> cancelNotification() async {
    await _notifications.cancel(_notificationId);
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
