import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

final places = GoogleMapsPlaces(apiKey: "AIzaSyDqH11TsGrc4NuKl5Gml2QzkV6M7dEr868");

class ScheduleInputDialog extends StatefulWidget {
  final DateTime selectedDate;
  const ScheduleInputDialog({super.key, required this.selectedDate});

  @override
  State<ScheduleInputDialog> createState() => _ScheduleInputDialogState();
}

class _ScheduleInputDialogState extends State<ScheduleInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _pickStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => _startTime = time);
  }

  Future<void> _pickEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => _endTime = time);
  }

  Future<LatLng?> showMapPickerDialog(BuildContext context) async {
    LatLng? selectedPosition;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('지도에서 위치 선택'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.5665, 126.9780),
              zoom: 11.0,
            ),
            onTap: (LatLng position) {
              selectedPosition = position;
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
    return selectedPosition;
  }

  Future<void> _pickPlace(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: "YOUR_API_KEY",
      mode: Mode.overlay,
      language: "ko",
      components: [Component(Component.country, "kr")],
    );
    if (p != null) {
      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
      LatLng latLng = LatLng(
        detail.result.geometry!.location.lat,
        detail.result.geometry!.location.lng,
      );
      _locationController.text = p.description ?? '${latLng.latitude}, ${latLng.longitude}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일 일정 추가'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '일정 제목'),
              validator: (value) => value!.isEmpty ? '제목을 입력해주세요' : null,
            ),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: '위치',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => _pickPlace(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.map),
                      onPressed: () async {
                        final position = await showMapPickerDialog(context);
                        if (position != null) {
                          _locationController.text = '${position.latitude}, ${latLng.longitude}';
                        }
                      },
                    ),
                  ],
                ),
              ),
              validator: (value) => value!.isEmpty ? '위치를 입력해주세요' : null,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('시작 시간'),
              subtitle: Text(_startTime?.format(context) ?? '선택해주세요'),
              onTap: _pickStartTime,
            ),
            ListTile(
              title: const Text('종료 시간'),
              subtitle: Text(_endTime?.format(context) ?? '선택해주세요'),
              onTap: _pickEndTime,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate() && _startTime != null && _endTime != null) {
              // 알림 강도 설정 다이얼로그 호출
              final intensity = await showDialog<int>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('알림 강度 설정'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile(
                        title: const Text('약함 (1시간 간격)'),
                        value: 1,
                        groupValue: 1,
                        onChanged: (value) => Navigator.pop(context, value),
                      ),
                      RadioListTile(
                        title: const Text('중간 (30분 간격)'),
                        value: 2,
                        groupValue: 1,
                        onChanged: (value) => Navigator.pop(context, value),
                      ),
                      RadioListTile(
                        title: const Text('강함 (15분 간격)'),
                        value: 3,
                        groupValue: 1,
                        onChanged: (value) => Navigator.pop(context, value),
                      ),
                    ],
                  ),
                ),
              );
              if (intensity != null) {
                Navigator.pop(context, {
                  'title': _titleController.text,
                  'location': _locationController.text,
                  'start_time': _startTime!.format(context),
                  'end_time': _endTime!.format(context),
                  'intensity': intensity,
                });
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('모든 항목을 입력해주세요')),
              );
            }
          },
          child: const Text('저장'),
        ),
      ],
    );
  }
}
