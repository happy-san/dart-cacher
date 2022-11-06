part of cache;

class LfuCache<K extends Comparable, V extends Object?>
    extends Cache<LfuStorage<K, V>, LfuCacheEntry<K, V>, K, V> {
  LfuCache({
    required super.storage,
    super.onEvict,
  });

  @override
  List<CacheEntry<K, V>> _collectGarbage(int size) {
    final entries = _internalStorage.entries;
    entries.sort((a, b) => a.use.compareTo(b.use));
    return entries.take(size).toList();
  }

  @override
  LfuCacheEntry<K, V> _getCacheElement(K key, V? value, DateTime insertTime) =>
      LfuCacheEntry<K, V>(key, value, insertTime);

  @override
  void _onCacheEntryAccessed(LfuCacheEntry<K, V>? entry) => entry?.use++;
}
