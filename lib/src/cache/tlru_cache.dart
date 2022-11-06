part of cache;

class TlruCache<K extends Comparable, V extends Object?>
    extends Cache<TlruStorage<K, V>, TlruCacheEntry<K, V>, K, V> {
  TlruCache({
    required super.storage,
    super.onEvict,
    required super.expiration,
  });

  @override
  List<TlruCacheEntry<K, V>> _collectGarbage(int size) {
    final entries = _internalStorage.entries;
    entries.sort((a, b) => a.lastUse.compareTo(b.lastUse));
    entries.sort((a, b) => a.compareExpirationTo(b));
    return entries.take(size).toList();
  }

  @override
  TlruCacheEntry<K, V> _getCacheElement(K key, V? value, DateTime insertTime) =>
      TlruCacheEntry<K, V>(key, value, insertTime, _expiration!);

  @override
  void _onCacheEntryAccessed(LruCacheEntry<K, V>? entry) =>
      entry?.updateUseTime();

  @override
  List<TlruCacheEntry<K, V>> get entries {
    final entries = _internalStorage.entries;
    entries.sort((a, b) {
      int i = a.lastUse.compareTo(b.lastUse);
      if (i != 0) {
        i = -i;
      }

      return i;
    });
    entries.sort((a, b) {
      int i = a.compareExpirationTo(b);
      if (i != 0) {
        i = -i;
      }

      return i;
    });

    return entries;
  }
}
