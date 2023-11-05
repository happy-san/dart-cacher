part of 'cache_entry.dart';

class TlruCacheEntry<K extends Comparable, V extends Object?>
    extends LruCacheEntry<K, V> {
  TlruCacheEntry(super.key, super.value, super.insertTime, this._expiration);

  final Duration _expiration;

  bool hasExpired() => DateTime.now().difference(insertTime) > _expiration;

  int compareExpirationTo(TlruCacheEntry other) {
    final thisExpired = this.hasExpired();
    final otherExpired = other.hasExpired();

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
