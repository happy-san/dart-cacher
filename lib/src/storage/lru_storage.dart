part of 'storage.dart';

class LruStorage<K extends Comparable, V extends Object?>
    extends InMemoryStorage<LruCacheEntry<K, V>, K, V> {
  LruStorage(super.size, {super.internalMap});
}
