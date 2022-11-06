part of example;

void lruExample() {
  final cache = LruCache<int, int>(
    storage: LruStorage(3),
    onEvict: (key, value) => print('$value evicted.'),
  )..loader = (key, _) => key;

  const insertions = [1, 2, 1, 0, 3, 0, 4, 2];

  print('\nLruCache size 3');

  for (final insertion in insertions) {
    cache.get(insertion);
    print('get $insertion.');
    printCache(cache);
  }
}
