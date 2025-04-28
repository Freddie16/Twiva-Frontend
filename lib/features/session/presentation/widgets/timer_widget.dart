// lib/features/session/presentation/widgets/timer_widget.dart
import 'package:flutter/material.dart';
import 'dart:async';

class TimerWidget extends StatefulWidget {
  final Duration duration;
  final VoidCallback onTimerEnd;

  const TimerWidget({
    Key? key,
    required this.duration,
    required this.onTimerEnd,
  }) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration.inSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        widget.onTimerEnd();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Time Left: $_remainingSeconds s',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: _remainingSeconds <= 5 ? Colors.red : Colors.black, // Change color when time is low
        ),
      ),
    );
  }
}