import 'package:test/test.dart';
import 'dart:io';

import 'package:cache/cache.dart';

void main() {
  test('Test cache initialization', () {
    final cache = SimpleCache<int, int>(storage: SimpleStorage(20));
    expect(cache, isNotNull);
  });

  test('Test simple insert/get', () {
    Cache<
        InMemoryStorage<CacheEntry<String, int>, String, int>,
        CacheEntry<String, int>,
        String,
        int> c = SimpleCache<String, int>(storage: SimpleStorage(20));

    c.set('key', 42);
    expect(c.get('key'), equals(42));
  });
  test('Test simple loader function', () {
    SimpleCache<int, int> c = SimpleCache<int, int>(storage: SimpleStorage(20))
      ..loader = (int k, _) => k * 10;
    expect(c.get(4), equals(40));
    expect(c.get(5), equals(50));
  });
  test('Test simple loader function', () {
    SimpleCache<int, int> c = SimpleCache<int, int>(storage: SimpleStorage(20))
      ..syncLoading = true
      ..expiration = const Duration(milliseconds: 200)
      ..loader = (int k, int? oldValue) {
        oldValue ??= k;
        var v = oldValue * 10;
        return v;
      };

    expect(c.get(4), equals(40));
    expect(c.get(4), equals(40));
    sleep(const Duration(seconds: 1));

    expect(c.get(4), equals(400));
  });
  test('Test simple loader function', () {
    SimpleCache<int, int> c = SimpleCache<int, int>(storage: SimpleStorage(20))
      ..syncLoading = false
      ..expiration = const Duration(milliseconds: 200)
      ..loader = (int k, int? oldValue) {
        oldValue ??= k;
        var v = oldValue * 10;
        return v;
      };

    expect(c.get(4), equals(40));
    expect(c.get(4), equals(40));
    sleep(const Duration(seconds: 1));

    expect(c.get(4), equals(40));
  });
  test('Test simple async loader function', () async {
    SimpleCache<int, int> c = SimpleCache<int, int>(storage: SimpleStorage(20))
      ..syncLoading = false
      ..expiration = const Duration(milliseconds: 200)
      ..loader = (int k, int? oldValue) async {
        oldValue ??= k;
        var v = oldValue * 10;
        return v;
      };

    expect(c.get(4), equals(null));
    await Future<dynamic>.delayed(Duration(seconds: 1));
    expect(c.get(4), equals(40));
  });
  test('Test simple eviction', () {
    SimpleCache<int, int> c = SimpleCache<int, int>(storage: SimpleStorage(3))
      ..loader = (int k, _) {
        return k * 10;
      };

    expect(c.get(4), equals(40));
    expect(c.get(5), equals(50));
    expect(c.get(6), equals(60));
    expect(c.get(7), equals(70));
    expect(c.containsKey(4), equals(false));
  });
  test('Test LRU eviction', () async {
    LruCache<int, int> c = LruCache<int, int>(storage: LruStorage(3))
      ..loader = (int k, _) {
        return k * 10;
      };

    expect(c.get(4), equals(40));
    expect(c.get(5), equals(50));
    expect(c.get(6), equals(60));
    await Future<dynamic>.delayed(Duration(seconds: 1));
    expect(c.get(4), equals(40));
    expect(c.get(6), equals(60));
    expect(c.get(7), equals(70));
    expect(c.containsKey(5), equals(false));
  });
  test('Test LFU eviction', () {
    LfuCache<int, int> c = LfuCache<int, int>(storage: LfuStorage(3))
      ..loader = (int k, _) {
        return k * 10;
      };

    expect(c.get(4), equals(40));
    expect(c.get(5), equals(50));
    expect(c.get(6), equals(60));
    expect(c.get(4), equals(40));
    expect(c.get(6), equals(60));
    expect(c.get(7), equals(70));
    expect(c.containsKey(5), equals(false));
  });
}
