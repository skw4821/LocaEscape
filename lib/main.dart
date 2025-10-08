import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'widgets/calendar_widget.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initNotifications();
  runApp(MyApp());
}

Future<void> _initNotifications() async {
  const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(android: androidInit);
  await notificationsPlugin.initialize(initSettings);
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String notificationMsg = '';
  double notificationIntensity = 1; // 1: 약함, 2: 중간, 3: 강함
  Position? _lastPosition;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _startLocationStream();
    _scheduleMotivationNotification();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  void _startLocationStream() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 10),
    ).listen((Position position) {
      // 예시: 특정 위치(위도, 경도)와 비교
      double targetLat = 37.5665; // 예시: 서울
      double targetLng = 126.9780;
      double distance = Geolocator.distanceBetween(
        position.latitude, position.longitude, targetLat, targetLng,
      );
      if (distance < 100 && (_lastPosition == null || Geolocator.distanceBetween(
        _lastPosition!.latitude, _lastPosition!.longitude, targetLat, targetLng,
      ) >= 100)) {
        _showNotification('도착 알림', '목표 위치에 도착했습니다! 할일을 확인하세요.');
      }
      if (distance >= 100 && _lastPosition != null && Geolocator.distanceBetween(
        _lastPosition!.latitude, _lastPosition!.longitude, targetLat, targetLng,
      ) < 100) {
        _showNotification('이탈 알림', '위치를 떠났습니다. 할일을 잘 했나요?');
      }
      _lastPosition = position;
    });
  }

  void _scheduleMotivationNotification() async {
    // 알림 강도에 따라 반복 주기 설정
    int minutes = notificationIntensity == 1 ? 60 : (notificationIntensity == 2 ? 30 : 15);
    await notificationsPlugin.periodicallyShow(
      0,
      '동기부여 알림',
      '오늘도 화이팅! 할일을 잊지 마세요!',
      RepeatInterval.everyMinute, // 실제 앱에서는 custom interval 구현 필요
      const NotificationDetails(
        android: AndroidNotificationDetails('motivation', '동기부여', importance: Importance.max),
      ),
    );
  }

  void _showNotification(String title, String body) async {
    await notificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails('main', '메인 알림', importance: Importance.max),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '위치 기반 캘린더',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('ko', 'KR')],
      home: Scaffold(
        appBar: AppBar(title: Text('위치 기반 캘린더')),
        body: Column(
          children: [
            CalendarWidget(),

          ],
        ),
      ),
    );
  }
}
