part of storage;

class SimpleStorage<K extends Comparable, V extends Object?>
    extends InMemoryStorage<SimpleCacheEntry<K, V>, K, V> {
  SimpleStorage(
    int size, {
    Map<K, SimpleCacheEntry<K, V>>? internalMap,
  }) : super(size, internalMap: internalMap);
}
