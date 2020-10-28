import '../getstream.dart';

class GetStreamTransformation<T> extends Stream<T> {
  final LightSink<T> sink;

  GetStreamTransformation(this.sink);

  @override
  LightSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    final subs = LightSubscription<T>(sink.listenable)
      ..onData(onData)
      ..onError(onError)
      ..onDone(onDone);
    sink.listenable.addSubscription(subs);
    return subs;
  }
}

extension StreamExt<T> on GetStream<T> {
  Stream<T> get stream => GetStreamTransformation<T>(sink);
}
