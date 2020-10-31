typedef OnData<T> = void Function(T data);
typedef OnDone = void Function();

class MiniSubscription<T> {
  const MiniSubscription(
      this.data, this.onError, this.onDone, this.cancelOnError);
  final OnData<T> data;
  final Function onError;
  final OnDone onDone;
  final bool cancelOnError;
}

class MiniStream<T> {
  List<MiniSubscription<T>> listenable = <MiniSubscription<T>>[];

  T _value;

  T get value => _value;

  void add(T event) {
    _value = event;
    _notifyData(event);
  }

  void addError(Object error, [StackTrace stackTrace]) {
    assert(listenable != null);
    _notifyError(error, stackTrace);
  }

  int get length => listenable.length;

  bool get hasListeners => listenable.isNotEmpty;

  bool get isClosed => listenable == null;

  MiniSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError = false}) {
    final subs = MiniSubscription(onData, onError, onDone, cancelOnError);
    listenable.add(subs);
    return subs;
  }

  void close() {
    if (listenable == null) {
      throw 'You can not close a closed Stream';
    }
    _notifyDone();
    listenable = null;
    _value = null;
  }

  void _notifyData(T data) {
    assert(listenable != null);
    for (final item in listenable) {
      item.data.call(data);
    }
  }

  void _notifyDone() {
    assert(listenable != null);
    for (final item in listenable) {
      item.onDone?.call();
    }
  }

  void _notifyError(Object error, [StackTrace stackTrace]) {
    assert(listenable != null);
    var removeKeys = <MiniSubscription>[];
    for (final item in listenable) {
      item.onError?.call(error, stackTrace);
      if (item.cancelOnError) {
        removeKeys.add(item);
      }
    }
    if (removeKeys.isNotEmpty) {
      for (final item in listenable) {
        item.onDone();
        listenable.remove(item);
      }
    }
    removeKeys = null;
  }
}
