import 'package:mysql_client/mysql_client.dart';

class MySQLService {
  // MySQL 연결 정보 (※에뮬레이터/실기기에서는 localhost 대신 PC의 실제 IP 사용!)
  static Future<MySQLConnection> _getConnection() async {
    return await MySQLConnection.createConnection(
      host: "localhost", // 또는 "192.168.0.10" (PC의 실제 IP)
      port: 3310,
      userName: "root",
      password: "1111", // 실제 비밀번호 입력
      databaseName: "calender_db",
    );
  }

  // 일정 추가
  static Future<void> addEvent(
      String title,
      String location,
      int intensity,
      String date,
      String startTime,
      String endTime,
      ) async {
    try {
      final conn = await _getConnection();
      await conn.connect();

      await conn.execute(
        "INSERT INTO events (title, location, notification_intensity, date, start_time, end_time) VALUES (:title, :loc, :intensity, :date, :start_time, :end_time)",
        {
          "title": title,
          "loc": location,
          "intensity": intensity,
          "date": date,
          "start_time": startTime,
          "end_time": endTime,
        },
      );

      await conn.close();
    } catch (e) {
      print('MySQLService.addEvent 오류: $e');
      rethrow;
    }
  }

}
