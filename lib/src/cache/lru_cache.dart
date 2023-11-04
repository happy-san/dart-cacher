part of cache;

class LruCache<K extends Comparable, V extends Object?>
    extends Cache<LruStorage<K, V>, LruCacheEntry<K, V>, K, V> {
  LruCache({
    required super.storage,
    super.onEvict,
  });

  @override
  List<CacheEntry<K, V>> _collectGarbage(int size) {
    final entries = _internalStorage.entries;
    entries.sort((a, b) => a.lastUse.compareTo(b.lastUse));
    return entries.take(size).toList();
  }

  @override
  LruCacheEntry<K, V> _getCacheElement(K key, V? value, DateTime insertTime,
          {Duration? expiration}) =>
      LruCacheEntry<K, V>(key, value, insertTime);

  @override
  void _onCacheEntryAccessed(LruCacheEntry<K, V>? entry) =>
      entry?.updateUseTime();

  @override
  List<LruCacheEntry<K, V>> get entries {
    final entries = _internalStorage.entries;
    entries.sort((a, b) {
      int i = a.lastUse.compareTo(b.lastUse);
      if (i != 0) {
        i = -i;
      }

      return i;
    });
    return entries;
  }
}
