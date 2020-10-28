import 'package:getstream/getstream.dart';
import 'package:test/test.dart';

void main() {
  final controller = GetStream<int>();

  test('Test stream', () {
    controller.add(0);
    controller.listen((event) {
      expect(event, 0);
    });
    expect(controller.value, 0);

    final subscription = controller.listen((event) {});

    expect(controller.length, 2);

    subscription.cancel();

    expect(controller.length, 1);
  });
}
