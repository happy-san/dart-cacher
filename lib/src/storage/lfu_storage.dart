part of storage;

class LfuStorage<K extends Comparable, V extends Object?>
    extends InMemoryStorage<LfuCacheEntry<K, V>, K, V> {
  LfuStorage(
    int size, {
    Map<K, LfuCacheEntry<K, V>>? internalMap,
  }) : super(size, internalMap: internalMap);
}
