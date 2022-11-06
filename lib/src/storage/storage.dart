/// The MIT License (MIT)
///
/// Original work Copyright (c) 2015 Jun Kimura
/// Modified work Copyright (c) 2022 Harpreet Sangar
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

library storage;

import '../cache_entry/cache_entry.dart';

part 'in_memory_storage.dart';
part 'simple_storage.dart';
part 'lfu_storage.dart';
part 'lru_storage.dart';
part 'tlru_storage.dart';

abstract class Storage<C extends CacheEntry<K, V>, K extends Comparable,
    V extends Object?> {
  Storage(
    int size,
  )   : _size = size,
        assert(size > 0);

  final int _size;

  /// Get a [CacheEntry] using [key].
  C? get(K key);

  /// Get [List] of all the [keys] present in [Storage].
  List<K> get keys;

  /// Get [List] of all the [CacheEntry]s present in [Storage].
  List<C> get entries;

  /// Count of the [CacheEntry]s present in [Storage].
  int get length;

  /// Capacity/size of the [Storage].
  int get capacity => _size;

  /// Insert a [CacheEntry] with [key] into the [Storage].
  Storage set(K key, C entry);

  /// Get a [CacheEntry] using [key].
  C? operator [](K key);

  /// Insert a [CacheEntry] with [key] into the [Storage].
  void operator []=(K key, C entry);

  /// If [Storage] contains [key].
  bool containsKey(K key);

  /// Removes the [CacheEntry] with [key].
  void remove(K key);

  /// Clears the [Storage], removing all the present [CacheEntry]s.
  void clear();
}
