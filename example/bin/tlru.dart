part of example;

Future<void> tlruExample() async {
  final cache = TlruCache<int, int>(
    storage: TlruStorage(3),
    expiration: const Duration(milliseconds: 500),
    onEvict: (key, value) => print('$value evicted.'),
  )..loader = (key, _) => key;

  const insertions = [1, 2, 1, 0, 3, 1, 4];
  const delays = [false, false, true, true, false, true, false];

  print('\nTlruCache size 3, expiry 500ms');

  for (int i = 0; i < insertions.length; i++) {
    final insertion = insertions[i];

    print('get $insertion.');
    cache.get(insertion);
    printCache(cache);

    if (delays[i]) {
      print('Delay 200ms');
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
}
