import 'package:getstream/getstream.dart';

Future<void> main() async {
  final controller = GetStream<int>();
  controller.listen((event) {
    print('change number to $event');
  }, onError: (err, s) {
    print(err);
  }, cancelOnError: true);
  controller.add(2);
  controller.add(3);
  controller.add(4);
  controller.add(5);
  controller.add(6);
  print('listeners == 1? ${controller.length}');
  final subs = controller.listen((event) {
    print('change number to $event');
  });
  controller.add(2);
  print('listeners == 2? ${controller.length}');

  await subs.cancel();

  controller.add(2);

  await controller.addError('error, A error ocurred');
  controller.add(5);
  print('listeners == 0? ${controller.length}');
  controller.close();
}
