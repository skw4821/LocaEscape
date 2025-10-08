import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calender_project/main.dart'; // 프로젝트 이름에 맞게 수정하세요

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 앱을 빌드하고 실행
    await tester.pumpWidget(MyApp());

    // '0'을 표시하는 텍스트를 찾음
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // '+' 버튼을 탭
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // 이제 '1'을 표시하는 텍스트가 있어야 함
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}