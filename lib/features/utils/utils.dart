import 'dart:async';

Stream<String> countToNumber({
  required int targetNumber,
  required Duration totalDuration,
  int steps = 60,
}) async* {
  if (targetNumber <= 0 || steps <= 0) return;

  final stepTime = totalDuration.inMilliseconds ~/ steps;

  for (int i = 0; i <= steps; i++) {
    final value = (targetNumber * i / steps).round();
    yield value.toString();
    await Future.delayed(Duration(milliseconds: stepTime));
  }
}




