part of 'storage.dart';

class LfuStorage<K extends Comparable, V extends Object?>
    extends InMemoryStorage<LfuCacheEntry<K, V>, K, V> {
  LfuStorage(super.size, {super.internalMap});
}
