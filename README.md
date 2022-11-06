> This is a modification of https://github.com/platelk/dcache, licensed under the MIT License.

# Cacher

Cacher is a simple library to implement application caching in `dart` inspired by [gcache](https://github.com/bluele/gcache)

## Features

* Supports expirable Cache, [Least Frequently Used](https://en.wikipedia.org/wiki/Least_frequently_used), [Least recently used](https://en.wikipedia.org/wiki/Cache_replacement_policies#LRU), [Time aware least recently used](https://en.wikipedia.org/wiki/Cache_replacement_policies#Time_aware_least_recently_used_(TLRU)).
* Supports eviction.
* Async loading of expired value.
* Automatically load cache if it doesn't exists. (Optional)
* Callback for evicted items to perform cleanup (Optional)

## Example

### Simple use case

```dart
import 'package:cacher/cacher.dart';

void main() {
  Cache c = SimpleCache(storage: SimpleStorage(20));

  c.set("key", 42);
  print(c.get("key")); // 42
  print(c.containsKey("unknown_key")); // false
  print(c.get("unknown_key")); // null
}
```

### Add logic on eviction.

```dart
import 'package:cacher/cacher.dart';

void main() {
  Cache c = SimpleCache<Key, Disposable>(
      storage: SimpleStorage(20),
      onEvict: (key, value) {
        value.dispose();
      });
}
```

### Loading function

```dart
import 'package:cacher/cacher.dart';

void main() {
  Cache c = SimpleCache<int, int>(
    storage: SimpleStorage(20),
  )..loader = (key, oldValue) => key * 10;

  print(c.get(4)); // 40
  print(c.get(5)); // 50
  print(c.containsKey(6)); // false
}
```

## Authors

*Kevin PLATEL*

* mail : <platel.kevin@gmail.com>
* github : <https://github.com/platelk>
* twitter : <https://twitter.com/kevinplatel>

*Harpreet Sangar*

* mail : <happy_san@protonmail.com>
* github : <https://github.com/happy-san>
