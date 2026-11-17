dnl Rule 23: imports must precede generated method implementations.
Import{
    "Strings.ad",
    "StringHashtableAdapters.ad",
    "MyHashtable.ad"
}

include(`OpenAddressHash.ai.m4')
OAHT_IMPL(MyHashtable, String_16, String_16, StringKeyAdapter, StringValueAdapter)
