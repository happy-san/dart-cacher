import 'package:test/test.dart';
import 'package:cacher/cacher.dart';

void main() {
  const expiry = Duration(seconds: 1, milliseconds: 500);
  const interval = Duration(milliseconds: 500);
  const halfInterval = Duration(milliseconds: 250);
  const evictionOrder = ['b', 'a'];
  var evictionCounter = 0;

  late TlruCache<int, String> cacheWithLoader, cache;
  pause({Duration? delay}) => Future<void>.delayed(delay ?? interval);

  setUp(() {
    cacheWithLoader = TlruCache<int, String>(
      storage: TlruStorage(3),
      expiration: expiry,
      onEvict: (key, value) {
        expect(value, equals(evictionOrder[evictionCounter++]));

        print('evicting {$value}');
      },
    )..loader = (k, _) {
        final s = String.fromCharCode('a'.codeUnitAt(0) + k);
        print('loading {$s}');
        return s;
      };

    cache = TlruCache<int, String>(
      storage: TlruStorage(3),
      expiration: expiry,
      onEvict: (key, value) {
        print('evicting {$value}');
      },
    );
  });

  test('Evicts expired and least recently used entries; in that order',
      () async {
    //
    //    250    250    250    250    250    250     (ms)
    //  |------|------|------|------|------|-------|
    // a,b   c,a,d         c,d,a           d       e
    //
    //  |------|------|------|------|------|-------|
    //  b(1.5) d(1.5)        a(0.75)       d(0.5)  e(1.5)
    //  a(1.5) a(1.25)       d(1)          a(0.25) d(0.25)
    //         c(1.5)        c(1)          c(0.5)  c(0.25)
    cacheWithLoader.get(0);
    cacheWithLoader.get(1);
    await pause(delay: halfInterval);

    cacheWithLoader.get(2);
    cacheWithLoader.get(0);
    cacheWithLoader.get(3); // Evict 'b' (least recently used).
    await pause();

    cacheWithLoader.get(2);
    cacheWithLoader.get(3);
    cacheWithLoader.get(0);
    await pause();

    cacheWithLoader.get(3);
    await pause(delay: halfInterval);

    cacheWithLoader.get(4); // Evict 'a' (expired).
  }, skip: true);

  test('Returns null on value expired when no _loaderFunc is provided',
      () async {
    cache.set(0, 'a');
    await pause(delay: expiry);

    final value = cache.get(0);
    expect(value, isNull);
  }, skip: true);

  test('Individual expiration duration takes precedence over common expiration',
      () async {
    cache.set(0, 'a');
    cache.set(1, 'b', expiration: Duration(seconds: 2));
    await pause(delay: expiry);

    expect(cache.get(0), isNull);
    expect(cache.get(1), 'b');
  });
}
