part of example;

void simpleCacheExample() {
  Cache c = SimpleCache<String, int>(storage: SimpleStorage<String, int>(20));

  c.set("key", 42);
  print(c.get("key")); // 42
  print(c.containsKey("unknown_key")); // false
  print(c.get("unknown_key")); // nil

  c = SimpleCache<int, int>(storage: SimpleStorage(20))
    ..loader = (key, oldValue) => key * 10;

  print(c.get(4)); // 40
  print(c.get(5)); // 50
  print(c.containsKey(6)); // false
}
