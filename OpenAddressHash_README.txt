Open-addressing hash table generator for Sappeur
================================================

Use the following FIVE macro arguments, in order:
  1. Generated class name
  2. Key class
  3. Value class
  4. Key adapter class
  5. Value adapter class

Example, in a declaration driver file:
  include(`OpenAddressHash.ad.m4')
  OAHT_DECL(MyHashtable, String_16, String_16, StringKeyAdapter, StringValueAdapter)

Example, in an implementation driver file:
  include(`OpenAddressHash.ai.m4')
  OAHT_IMPL(MyHashtable, String_16, String_16, StringKeyAdapter, StringValueAdapter)

Generate both files with GNU m4, e.g.:
  m4 OpenAddressHashDecls.m4 > MyHashtable.ad
  m4 OpenAddressHashImpls.m4 > MyHashtable.ai

Place the key/value and adapter declarations earlier than MyHashtable.ad
in Sappeur's compileorder. Add required Import{...} statements to
MyHashtable.ai according to your Sappeur project structure.

Required adapter instance method signatures:

  class StringKeyAdapter
  {
  methods:
      int hash(&String_16 key);
      int equals(&String_16 a, &String_16 b);
      void copy(&String_16 dst, &String_16 src);
      void destroy(&String_16 target);
  };

  class StringValueAdapter
  {
  methods:
      void copy(&String_16 dst, &String_16 src);
      void destroy(&String_16 target);
  };

Adapter contract:
* hash() must be deterministic for the lifetime of a stored key;
  equal keys must have the same hash.
* equals() must return exactly 1 for equality, 0 otherwise.
* copy() overwrites a default-constructed or previously destroyed
  target with an independent logical copy of the source. Copies must
  remain valid when the original is destroyed.
* destroy() releases the logical content and leaves the by-value object
  valid, default-like, and safely destructible. Calling destroy() is NOT
  deallocation of the table slot itself.
* An adapter copy may not fail or throw halfway through an update.
* Key/value classes must support default construction.

The data arrays contain values, not pointers to individual keys/values.
The array buffers themselves are allocated on the heap as Sappeur
reference-counted array pointers.

API:
  int put(&Key key, &Value value): 1 new / 2 replaced / 0 failure
  int get(&Key key, &Value output): 1 found / 0 missing
  int contains(&Key key): 1 present / 0 missing
  int remove(&Key key): 1 removed / 0 missing
  void clear()
  int size()
  int capacity()

Implementation: linear probing, tombstones, 16 initial slots,
automatic doubling at 75% used load (including tombstones). Rehash
calls both adapters to copy into fresh arrays, then destroys old
logical entries. No shrink. Not multithreaded.

Limitations: This source has been expanded with GNU m4 but not compiled
by a Sappeur compiler (not available in this runtime). Allocation
failures follow the compiler/runtime's allocation behavior. The hash
table must not be modified while key comparison/hash or adapter copying
is in progress; no concurrent access is supported.
