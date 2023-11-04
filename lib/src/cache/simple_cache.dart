part of cache;

/// SimpleCache is a basic cache implementation without any particular logic
/// than appending keys in the storage, and remove first inserted keys when storage is full
class SimpleCache<K extends Comparable, V extends Object?>
    extends Cache<SimpleStorage<K, V>, SimpleCacheEntry<K, V>, K, V> {
  SimpleCache({
    required super.storage,
    super.onEvict,
  });

  @override
  List<CacheEntry<K, V>> _collectGarbage(int size) {
    return _internalStorage.entries.take(size).toList();
  }

  @override
  SimpleCacheEntry<K, V> _getCacheElement(K key, V? value, DateTime insertTime,
          {Duration? expiration}) =>
      SimpleCacheEntry<K, V>(key, value, insertTime);

  @override
  List<SimpleCacheEntry<K, V>> get entries =>
      List.from(_internalStorage.entries);
}
