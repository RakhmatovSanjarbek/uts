import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'uts_cargo_global_channel',
  'Muhim bildirishnomalar',
  description: 'UTS Cargo yuk holati haqida bildirishnomalar',
  importance: Importance.high,
);

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static String? _cachedToken;
  static String? get cachedToken => _cachedToken;

  Future<void> initialize() async {
    await _initLocalNotifications();

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _messaging.getAPNSToken().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          debugPrint('APNs token timeout — simulator bo\'lishi mumkin');
          return null;
        },
      );
    }

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('FCM ruxsat berildi.');

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _fetchAndCacheToken();

      _messaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token yangilandi: $newToken');
        _cachedToken = newToken;
      });

      _setupNotificationListeners();
    } else {
      debugPrint('FCM ruxsat berilmadi: ${settings.authorizationStatus}');
    }
  }

  Future<void> _initLocalNotifications() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // ✅ v20+ — initialize() named parameter: settings
    await flutterLocalNotificationsPlugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Bildirishnoma bosildi: ${response.payload}');
      },
    );
  }

  Future<void> _fetchAndCacheToken() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          debugPrint('APNs token yo\'q — iOS simulator');
          return;
        }
      }
      _cachedToken = await _messaging.getToken();
      debugPrint('FCM Token cache ga saqlandi: $_cachedToken');
    } catch (e) {
      debugPrint('FCM Token olishda xatolik: $e');
    }
  }

  Future<String?> getDeviceToken() async {
    if (_cachedToken != null) return _cachedToken;
    await _fetchAndCacheToken();
    return _cachedToken;
  }

  void _setupNotificationListeners() {
    // ✅ Ilova OCHIQ (foreground) — local notification ko'rsatamiz
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground xabar: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleRouting(message.data);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    // ✅ v20+ — show() named parameters: id, title, body, notificationDetails
    await flutterLocalNotificationsPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'uts_cargo_global_channel',
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }

  Future<void> checkInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleRouting(initialMessage.data);
    }
  }

  void _handleRouting(Map<String, dynamic> data) {
    if (data.containsKey('cargo_id')) {
      debugPrint('Cargo sahifasiga o\'tish: ${data['cargo_id']}');
    }
  }
}