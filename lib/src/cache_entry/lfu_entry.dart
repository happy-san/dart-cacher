part of cache_entry;

class LfuCacheEntry<K extends Comparable, V extends Object?>
    extends CacheEntry<K, V> {
  LfuCacheEntry(super.key, super.value, super.insertTime);

  int use = 0;
}
