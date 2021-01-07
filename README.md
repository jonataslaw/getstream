# GetStream

   <a href="https://pub.dartlang.org/packages/getstream">  
    <img src="https://img.shields.io/pub/v/getstream.svg"  
      alt="Pub Package" />  
  </a> 
   <a href="https://github.com/jonataslaw/getstream/issues">  
    <img src="https://img.shields.io/github/issues/jonataslaw/getstream"  
      alt="Issue" />  
  </a> 
   <a href="https://github.com/jonataslaw/getstream/network">  
    <img src="https://img.shields.io/github/forks/jonataslaw/getstream"  
      alt="Forks" />  
  </a> 
   <a href="https://github.com/jonataslaw/getstream/stargazers">  
    <img src="https://img.shields.io/github/stars/jonataslaw/getstream"  
      alt="Stars" />  
  </a>
  <br>
  <br>

GetStream is the lightest and most performative way of working with events at Dart. Streams are cool, but you don't always need them. ChangeNotifier is easy, but not as powerful, is slow and makes it difficult to remove listeners. GetStream is very light, and works with simple callbacks. In this way, every event calls only one function. There is no buffering, and you have very low memory consumption.

# Lets Get Started

### 1. Depend on it
Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  getstream:
```

### 2. Install it

You can install packages from the command line:

with `pub`:

```css
$  pub get
```

with `Flutter`:

```css
$  flutter packages get
```

### 3. Import it

Now in your `Dart` code, you can use: 

````dart
import 'package:getstream/getstream.dart';
````

# Usage

A simple usage example:

```dart
import 'package:getstream/getstream.dart';

void main() {
  final controller = GetStream<int>();
  
  controller.listen((event) {
    print('change number to $event');
  });
  
  controller.add(2);
  controller.add(3);
  controller.add(4);
 
  final subs = controller.listen((event) {
    print('change number to $event');
  });
  
  controller.add(5);
  controller.add(6);
  controller.add(2);

  subs.cancel();
  controller.add(1);

  controller.close();
}


```
# How more fast? 
In tests on the VM dart, **```GetStream is 2650% faster```** than the conventional Stream. If you want to run this test yourself, you can run this sample code:

```dart
import 'dart:async';
import 'package:test/test.dart';
import 'package:getstream/getstream.dart';

void main() async {
  test('run benchmarks', () async {
    print(await stream());
    print(await getStream());
  });
}

int times = 30000;
int get last => times - 1;

/// GET_STREAM
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

/// Conventional Stream
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

```
