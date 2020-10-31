import 'dart:async';
import 'package:test/test.dart';
import 'package:getstream/getstream.dart';

void main() async {
  test('run benchmarks', () async {
    print(await newStream());
    print(await stream());
    print(await getStream());
  });
}

int times = 30000;
int get last => times - 1;

Future<String> getStream() {
  final c = Completer<String>();

  final value = GetStream<int>();
  final timer = Stopwatch();
  timer.start();

  value.listen((v) {
    if (last == v) {
      timer.stop();
      c.complete(
          '''$v listeners notified | [GET_STREAM] objs time: ${timer.elapsedMicroseconds}ms''');
    }
  });

  for (var i = 0; i < times; i++) {
    value.add(i);
  }

  return c.future;
}

Future<String> newStream() {
  final c = Completer<String>();
  final value = MiniStream<int>();
  final timer = Stopwatch();
  timer.start();

  value.listen((v) {
    if (last == v) {
      timer.stop();
      c.complete(
          '''$v listeners notified | [LIGHT_STREAM] objs time: ${timer.elapsedMicroseconds}ms''');
    }
  });

  for (var i = 0; i < times; i++) {
    value.add(i);
  }

  return c.future;
}

Future<String> stream() {
  final c = Completer<String>();

  final value = StreamController<int>();
  final timer = Stopwatch();
  timer.start();

  value.stream.listen((v) {
    if (last == v) {
      timer.stop();
      c.complete(
          '''$v listeners notified | [STREAM] objs time: ${timer.elapsedMicroseconds}ms''');
    }
  });

  for (var i = 0; i < times; i++) {
    value.add(i);
  }

  return c.future;
}
