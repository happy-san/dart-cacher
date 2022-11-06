part of cache_entry;

class SimpleCacheEntry<K extends Comparable, V extends Object?>
    extends CacheEntry<K, V> {
  SimpleCacheEntry(super.key, super.value, super.insertTime);
}
