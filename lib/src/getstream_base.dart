import 'dart:async';

typedef OnData<T> = void Function(T data);
typedef Callback = void Function();

/// [GetStream] is a very light stream
class GetStream<T> {
  LightSink<T> sink = LightSink<T>();

  void add(T event) => sink.add(event);

  void addError(Object error, [StackTrace stackTrace]) {
    sink.addError(error, stackTrace);
  }

  T get value => sink.value;

  void close() => sink.close();

  int get length => sink.listenable.length;

  bool get hasListeners => sink.listenable.hasListeners;

  bool get isClosed => sink.listenable == null;

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

class LightSink<T> extends EventSink<T> {
  LightListenable<T> listenable = LightListenable<T>();

  T _value;

  T get value => _value;

  @override
  void add(T event) {
    _value = event;
    _checkIfDisposed();
    listenable.notifyData(event);
  }

  void _checkIfDisposed([bool isClosed = false]) {
    if (listenable == null) {
      throw '''[LightStream] Error: 
You cannot ${isClosed ? "close" : "add events to"} a closed stream.''';
    }
  }

  @override
  void addError(Object error, [StackTrace stackTrace]) {
    _checkIfDisposed();
    listenable.notifyError(error, stackTrace);
  }

  @override
  void close() {
    _checkIfDisposed(true);
    listenable.notifyDone();
    listenable.dispose();
    listenable = null;
    _value = null;
  }
}

class LightListenable<T> {
  List<LightSubscription<T>> _onData = <LightSubscription<T>>[];

  void removeSubscription(LightSubscription<T> subs) {
    _onData.remove(subs);
  }

  void addSubscription(LightSubscription<T> subs) {
    _onData.add(subs);
  }

  int get length => _onData?.length;

  bool get hasListeners => _onData.isNotEmpty;

  void notifyData(T data) {
    _checkIfDisposed();
    for (final item in _onData) {
      if (item.isPaused) {
        break;
      }
      item._data?.call(data);
    }
  }

  void _checkIfDisposed() {
    if (isDisposed) {
      throw '[LightStream] Error: You cannot add events to a closed stream.';
    }
  }

  void notifyError(Object error, [StackTrace stackTrace]) {
    _checkIfDisposed();
    for (final item in _onData) {
      if (item.isPaused) {
        break;
      }
      item._onError?.call(error, stackTrace);
      if (item.cancelOnError) {
        item.cancel?.call();
        item._onDone?.call();
      }
    }
  }

  void notifyDone() {
    _checkIfDisposed();
    for (final item in _onData) {
      if (item.isPaused) {
        break;
      }
      item._onDone?.call();
    }
  }

  void dispose() => _onData = null;

  bool get isDisposed => _onData == null;
}

class LightSubscription<T> extends StreamSubscription<T> {
  final LightListenable<T> listener;

  LightSubscription(this.listener);

  bool cancelOnError = false;

  @override
  Future<void> cancel() async => listener.removeSubscription(this);

  OnData<T> _data;

  Function _onError;

  Callback _onDone;

  bool _isPaused = false;

  @override
  void onData(OnData<T> handleData) => _data = handleData;

  @override
  void onError(Function handleError) => _onError = handleError;

  @override
  void onDone(Callback handleDone) => _onDone = handleDone;

  @override
  void pause([Future<void> resumeSignal]) => _isPaused = true;

  @override
  void resume() => _isPaused = false;

  @override
  bool get isPaused => _isPaused;

  @override
  Future<E> asFuture<E>([E futureValue]) => Future.value(futureValue);
}
