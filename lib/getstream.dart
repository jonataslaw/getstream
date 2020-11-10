library rx_stream;

import 'dart:async';
part 'src/get_stream.dart';
part 'src/mini_stream.dart';

typedef OnData<T> = void Function(T data);
typedef Callback = void Function();
