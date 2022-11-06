library example;

import 'package:cacher/cacher.dart';
part 'simple_cache.dart';
part 'lru.dart';
part 'tlru.dart';
part 'lfu.dart';

void printCache(Cache cache) =>
    print('{${cache.entries.map((e) => e.value).join(', ')}}');

void main() async {
  simpleCacheExample();
  lruExample();
  await tlruExample();
  lfuExample();
}
