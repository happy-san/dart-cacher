part of 'storage.dart';

class SimpleStorage<K extends Comparable, V extends Object?>
    extends InMemoryStorage<SimpleCacheEntry<K, V>, K, V> {
  SimpleStorage(super.size, {super.internalMap});
}
