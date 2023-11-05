part of 'cache_entry.dart';

class LruCacheEntry<K extends Comparable, V extends Object?>
    extends CacheEntry<K, V> {
  LruCacheEntry(super.key, super.value, super.insertTime) {
    lastUse = insertTime;
  }

  late DateTime lastUse;

  void updateUseTime() {
    lastUse = DateTime.now();
  }
}
