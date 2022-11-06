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

library cache;

import 'dart:async';

import '../cache_entry/cache_entry.dart';
import '../storage/storage.dart';

part 'simple_cache.dart';
part 'lru_cache.dart';
part 'tlru_cache.dart';
part 'lfu_cache.dart';

typedef LoaderFunc<K, V> = FutureOr<V> Function(K key, V? oldValue);
typedef OnEvict<K, V> = void Function(K k, V? v);

abstract class Cache<S extends Storage<C, K, V>, C extends CacheEntry<K, V>,
    K extends Comparable, V extends Object?> {
  /// if onEvict is set that method is called whenever an entry is removed from the queue.
  /// At the time the method is called the entry is already removed.
  final OnEvict<K, V>? _onEvict;
  S _internalStorage;
  LoaderFunc<K, V>? _loaderFunc;

  /// Set when every [CacheEntry] of [Storage] has the same expiry duration.
  Duration? _expiration;

  /// Determine if the loading function in case of "refreshing", would be waited or not
  /// In some case we are more interested by the quick answer than a accurate one
  bool _syncValueReloading;

  Cache({required S storage, OnEvict<K, V>? onEvict, Duration? expiration})
      : _internalStorage = storage,
        _syncValueReloading = true,
        _onEvict = onEvict,
        _expiration = expiration;

  /// return the element identify by [key]
  V? get(K key) {
    if (_loaderFunc != null && !containsKey(key)) {
      if (_internalStorage.length >= _internalStorage.capacity) {
        final garbage = _collectGarbage(
            _internalStorage.length - _internalStorage.capacity + 1);
        if (_onEvict != null) {
          for (final e in garbage) {
            _onEvict!(e.key, e.value);
          }
        }
        for (final e in garbage) {
          _internalStorage.remove(e.key);
        }
      }
      _loadFirstValue(key);
    }
    var entry = _get(key);
    if (entry == null) {
      return null;
    }

    // Check if the value hasn't expired
    if (_expiration != null &&
        DateTime.now().difference(entry.insertTime) >= _expiration!) {
      if (_syncValueReloading) {
        _loadValue(entry);
        entry = _get(key);
      } else {
        // Non blocking
        Future(() => _loadValue(entry!));
      }
    }

    _onCacheEntryAccessed(entry);
    return entry?.value;
  }

  void _onCacheEntryAccessed(C? entry) {}

  // Load a  value and insert in the cache
  void _loadValue(CacheEntry<K, V> entry) {
    if (_loaderFunc != null && !entry.updating) {
      entry.updating = true;
      // Prevent double calls
      _set(entry.key, _loaderFunc!(entry.key, entry.value));
    }
  }

  void _loadFirstValue(K key) {
    if (_loaderFunc != null) {
      // Prevent double calls
      _set(key, _loaderFunc!(key, null));
    }
  }

  /// internal [get]
  C? _get(K key) => _internalStorage[key];

  /// add [element] in the cache at [key]
  Cache<S, C, K, V> set(K key, V element) {
    return _set(key, element);
  }

  C _getCacheElement(K key, V? value, DateTime insertTime);

  /// internal [set]
  Cache<S, C, K, V> _set(K key, FutureOr<V> element) {
    late final C entry;
    if (element is Future<V>) {
      entry = _getCacheElement(key, null, DateTime.now());
      entry.updating = true;
      element.then((e) {
        entry.updating = false;
        entry.value = e;
      });
    } else {
      entry = _getCacheElement(key, element, DateTime.now());
    }
    _internalStorage[key] = entry;
    return this;
  }

  /// clear elements to let  element being inserted
  List<CacheEntry<K, V>> _collectGarbage(int size);

  /// return the number of element in the cache
  int get length => _internalStorage.length;

  // Check if the cache contains a specific entry
  bool containsKey(K key) => _internalStorage.containsKey(key);

  /// return the value at [key]
  V? operator [](K key) {
    return get(key);
  }

  /// assign [element] for [key]
  void operator []=(K key, V element) {
    set(key, element);
  }

  /// remove all the entry inside the cache
  void clear() => _internalStorage.clear();

  set loader(LoaderFunc<K, V> loadFunc) {
    _loaderFunc = loadFunc;
  }

  set storage(S storage) {
    _internalStorage = storage;
  }

  set expiration(Duration duration) {
    _expiration = duration;
  }

  set syncLoading(bool syncLoading) {
    _syncValueReloading = syncLoading;
  }

  V? remove(K key) {
    if (_internalStorage.containsKey(key)) {
      final value = _internalStorage[key]!.value;
      _internalStorage.remove(key);
      return value;
    }
    return null;
  }
}
