part of cache_entry;

class TlruCacheEntry<K extends Comparable, V extends Object?>
    extends LruCacheEntry<K, V> {
  TlruCacheEntry(super.key, super.value, super.insertTime, Duration expiration)
      : _expiration = expiration;

  final Duration _expiration;

  static bool hasExpired(TlruCacheEntry entry) =>
      DateTime.now().difference(entry.insertTime) > entry._expiration;

  int compareExpirationTo(TlruCacheEntry other) {
    final thisExpired = hasExpired(this);
    final otherExpired = hasExpired(other);

    if (thisExpired && otherExpired) {
      return 0;
    } else if (thisExpired) {
      return -1;
    } else if (otherExpired) {
      return 1;
    } else {
      return 0;
    }
  }
}
