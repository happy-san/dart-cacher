part of 'storage.dart';

class TlruStorage<K extends Comparable, V extends Object?>
    extends InMemoryStorage<TlruCacheEntry<K, V>, K, V> {
  TlruStorage(super.size, {super.internalMap});
}
