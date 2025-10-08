import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationTracker(),
    );
  }
}

class LocationTracker extends StatefulWidget {
  @override
  _LocationTrackerState createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  Position? _currentPosition;
  final double targetLatitude = 37.7749; // 예시 장소 (위도)
  final double targetLongitude = -122.4194; // 예시 장소 (경도)

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    // 특정 장소 도착 여부 확인
    double distance = Geolocator.distanceBetween(
        _currentPosition!.latitude, _currentPosition!.longitude,
        targetLatitude, targetLongitude);

    if (distance < 50) { // 50m 이내 도착 시 출력
      _showEventPopup();
    }
  }

  void _showEventPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("도착 알림"),
        content: const Text("해당 장소의 일정: 회의 @ 15:00"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("닫기"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GPS 기반 일정 알림")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_currentPosition != null
                ? "현재 위치: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}"
                : "위치 정보를 가져오는 중..."),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text("현재 위치 확인"),
            ),
          ],
        ),
      ),
    );
  }
}