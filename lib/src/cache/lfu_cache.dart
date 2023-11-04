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
  LfuCacheEntry<K, V> _getCacheElement(K key, V? value, DateTime insertTime,
          {Duration? expiration}) =>
      LfuCacheEntry<K, V>(key, value, insertTime);

  @override
  void _onCacheEntryAccessed(LfuCacheEntry<K, V>? entry) => entry?.use++;

  @override
  List<LfuCacheEntry<K, V>> get entries {
    final entries = _internalStorage.entries;
    entries.sort((a, b) {
      int i = a.use.compareTo(b.use);
      if (i != 0) {
        i = -i;
      }

      return i;
    });
    return entries;
  }
}
