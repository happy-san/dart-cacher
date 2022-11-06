part of storage;

class LruStorage<K extends Comparable, V extends Object?>
    extends InMemoryStorage<LruCacheEntry<K, V>, K, V> {
  LruStorage(
    int size, {
    Map<K, LruCacheEntry<K, V>>? internalMap,
  }) : super(size, internalMap: internalMap);
}
