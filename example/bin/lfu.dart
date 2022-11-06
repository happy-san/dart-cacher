part of example;

void lfuExample() {
  final cache = LfuCache<int, int>(
    storage: LfuStorage(3),
    onEvict: (key, value) => print('$value evicted.'),
  )..loader = (key, _) => key;

  const insertions = [0, 1, 2, 2, 1, 0, 1, 0, 3, 4, 1];

  print('\nLfuCache size 3');

  for (final insertion in insertions) {
    cache.get(insertion);
    print('get $insertion.');
    printCache(cache);
  }
}
