String_16 -> String_16 test for the generated MyHashtable
==========================================================

Files:
  StringHashtableAdapters.ad / .ai
  StringHashtableTest.ad / .ai

Dependencies:
  String_16 declaration and implementation (Sappeur standard library)
  PrintfClass (Sappeur standard library)
  MyHashtable.ad / MyHashtable.ai (previously generated OAHT sources)

Declaration compile order (adapt the names to your project):
  Strings.ad, System.ad, StringHashtableAdapters.ad, MyHashtable.ad,
  StringHashtableTest.ad

Implementation imports (adapt to the actual source layout):
  Import{
      "Strings.ad",
      "System.ad",
      "StringHashtableAdapters.ad",
      "MyHashtable.ad",
      "StringHashtableTest.ad"
  }

Insert these imports at the start of each .ai file, as needed by your
build system (the test files deliberately leave imports out because
actual standard-library declaration filenames may differ).

To run, call from an existing instance method (e.g. Main::main):

  var StringHashtableTest test;
  var int result=0;
  test.run(result);
  if(result==0)
  {
      return -1;
  }
  return 1;

The test adapters use hash() = 7 for all keys. This is intentional: it
forces collisions and is NOT a suitable hash for production workloads.

Tests: empty lookups, insertion, by-value copy behavior, overwrite,
retrieved-value independence, 80-key rehash/growth, deletion, tombstone
probe preservation, reinsertion, clear, and reuse.

IMPORTANT: GNU m4 expansion of the table was checked previously, but
these Sappeur sources have not been compiled with a Sappeur compiler.
