#GetStream

GetStream is the lightest and most performative way of working with events at Dart. Streams are cool, but you don't always need them. ChangeNotifier is easy, but not as powerful and makes it difficult to remove listeners. GetStream is very light, and works with simple callbacks. In this way, every event calls only one function. There is no buffering, so you have very low memory consumption.

## Usage

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

