dnl Open-addressing hash table with keys and values stored by value.
dnl OAHT_DECL(Name, KeyType, ValueType, KeyAdapter, ValueAdapter)
dnl Adapter interfaces:
dnl   KeyAdapter: int hash(&KeyType key);
dnl               int equals(&KeyType a, &KeyType b);
dnl               void copy(&KeyType dst, &KeyType src);
dnl               void destroy(&KeyType target);
dnl   ValueAdapter: void copy(&ValueType dst, &ValueType src);
dnl                 void destroy(&ValueType target);
dnl hash must be stable and equals must be consistent with hash.

define(`OAHT_DECL',`
class $1
{
    *$2 _keys[];
    *$3 _values[];
    *int _states[];   // 0 empty, 1 occupied, 2 tombstone
    int _capacity;
    int _size;
    int _used;       // occupied + tombstones
    $4 _keyAdapter;
    $5 _valueAdapter;
methods:
    $1();
    ~$1();
    int put(&$2 key, &$3 value);  // 1 inserted, 2 updated, 0 failure
    int get(&$2 key, &$3 value);  // copies the value; 1 found, 0 absent
    int contains(&$2 key);       // 1 found, 0 absent
    int remove(&$2 key);         // 1 removed, 0 absent
    void clear();
    int size();
    int capacity();
    int findSlot(&$2 key, &int found);
    int grow(int newCapacity);
};
')
