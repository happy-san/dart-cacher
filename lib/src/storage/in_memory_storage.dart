part of 'storage.dart';

class InMemoryStorage<C extends CacheEntry<K, V>, K extends Comparable,
    V extends Object?> extends Storage<C, K, V> {
  InMemoryStorage(
    super.size, {
    Map<K, C>? internalMap,
  }) : _internalMap = internalMap ?? {};

  final Map<K, C> _internalMap;

  @override
  C? get(K key) => _internalMap[key];

  @override
  List<K> get keys => _internalMap.keys.toList();

  @override
  List<C> get entries => _internalMap.values.toList();

  @override
  int get length => _internalMap.length;

  @override
  InMemoryStorage set(K key, C entry) {
    _internalMap[key] = entry;
    return this;
  }

  @override
  C? operator [](K key) => _internalMap[key];

  @override
  void operator []=(K key, C entry) => _internalMap[key] = entry;

  @override
  bool containsKey(K key) => _internalMap.containsKey(key);

  @override
  void remove(K key) => _internalMap.remove(key);

  @override
  void clear() => _internalMap.clear();
}
