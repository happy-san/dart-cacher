part of storage;

class TlruStorage<K extends Comparable, V extends Object?>
    extends InMemoryStorage<TlruCacheEntry<K, V>, K, V> {
  TlruStorage(
    int size, {
    Map<K, TlruCacheEntry<K, V>>? internalMap,
  }) : super(size, internalMap: internalMap);
}
