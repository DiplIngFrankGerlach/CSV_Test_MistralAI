dnl OAHT_IMPL(Name, KeyType, ValueType, KeyAdapter, ValueAdapter)

define(`OAHT_IMPL',`
/** Initialize an empty table with 16 by-value slots. */
$1::$1()
{
    _capacity=16;
    _size=0;
    _used=0;
    _keys=new $2[_capacity];
    _values=new $3[_capacity];
    _states=new int[_capacity];
    for(var int i=0;i<_capacity;i++)
    {
        _states[i]=0;
    }
}

/** Release logical contents using both adapters. */
$1::~$1()
{
    this.clear();
}

/** Return the number of occupied slots. */
int $1::size()
{
    return _size;
}

/** Return the allocated slot count. */
int $1::capacity()
{
    return _capacity;
}

/** Locate an existing key or the first available insertion slot.
 *  found is set to 1 only if an equal occupied key was encountered.
 *  Returns -1 when the table contains no usable slot.
 */
int $1::findSlot(&$2 key, &int found)
{
    found=0;
    var int hashValue=_keyAdapter.hash(key);
    var int pos=hashValue % _capacity;
    if(pos<0)
    {
        pos=pos+_capacity;
    }
    var int firstDeleted= -1;
    for(var int probe=0;probe<_capacity;probe++)
    {
        var int state=_states[pos];
        if(state==0)
        {
            if(firstDeleted>=0)
            {
                return firstDeleted;
            }
            return pos;
        }
        if(state==1)
        {
            var int equal=_keyAdapter.equals(_keys[pos],key);
            if(equal==1)
            {
                found=1;
                return pos;
            }
        }
        else
        {
            if(firstDeleted<0)
            {
                firstDeleted=pos;
            }
        }
        pos=pos+1;
        if(pos==_capacity)
        {
            pos=0;
        }
    }
    return firstDeleted;
}

/** Rebuild into a larger array using adapter-managed deep copies.
 *  Caller must supply a capacity greater than the current capacity.
 */
int $1::grow(int newCapacity)
{
    if(newCapacity<=_capacity)
    {
        return 0;
    }
    var *$2 oldKeys[]=_keys;
    var *$3 oldValues[]=_values;
    var *int oldStates[]=_states;
    var int oldCapacity=_capacity;

    _keys=new $2[newCapacity];
    _values=new $3[newCapacity];
    _states=new int[newCapacity];
    _capacity=newCapacity;
    _size=0;
    _used=0;
    for(var int i=0;i<_capacity;i++)
    {
        _states[i]=0;
    }
    for(var int j=0;j<oldCapacity;j++)
    {
        if(oldStates[j]==1)
        {
            var int found=0;
            var int slot=this.findSlot(oldKeys[j],found);
            if(slot<0)
            {
                return 0;
            }
            _keyAdapter.copy(_keys[slot],oldKeys[j]);
            _valueAdapter.copy(_values[slot],oldValues[j]);
            _states[slot]=1;
            _size=_size+1;
            _used=_used+1;
            _keyAdapter.destroy(oldKeys[j]);
            _valueAdapter.destroy(oldValues[j]);
            oldStates[j]=0;
        }
    }
    return 1;
}

/** Insert or replace an entry; keys and values are adapter-copied by value. */
int $1::put(&$2 key, &$3 value)
{
    if(_capacity<=0)
    {
        return 0;
    }
    var int found=0;
    var int slot=this.findSlot(key,found);
    if(found==1)
    {
        _valueAdapter.destroy(_values[slot]);
        _valueAdapter.copy(_values[slot],value);
        return 2;
    }
    var int projected=_used+1;
    var int limit=_capacity - (_capacity / 4);
    if(projected>=limit)
    {
        if(_capacity>1073741823)
        {
            return 0;
        }
        var int newCapacity=_capacity*2;
        var int ok=this.grow(newCapacity);
        if(ok==0)
        {
            return 0;
        }
        found=0;
        slot=this.findSlot(key,found);
    }
    if(slot<0)
    {
        return 0;
    }
    var int oldState=_states[slot];
    _keyAdapter.copy(_keys[slot],key);
    _valueAdapter.copy(_values[slot],value);
    _states[slot]=1;
    _size=_size+1;
    if(oldState==0)
    {
        _used=_used+1;
    }
    return 1;
}

/** Copy the matching value into the caller-provided object. */
int $1::get(&$2 key, &$3 value)
{
    var int found=0;
    var int slot=this.findSlot(key,found);
    if(found==1)
    {
        _valueAdapter.copy(value,_values[slot]);
        return 1;
    }
    return 0;
}

/** Test whether a key is present. */
int $1::contains(&$2 key)
{
    var int found=0;
    var int slot=this.findSlot(key,found);
    return found;
}

/** Remove one matching entry and leave a tombstone for probe correctness. */
int $1::remove(&$2 key)
{
    var int found=0;
    var int slot=this.findSlot(key,found);
    if(found==0)
    {
        return 0;
    }
    _keyAdapter.destroy(_keys[slot]);
    _valueAdapter.destroy(_values[slot]);
    _states[slot]=2;
    _size=_size - 1;
    return 1;
}

/** Destroy every occupied key/value pair and reset probe metadata. */
void $1::clear()
{
    for(var int i=0;i<_capacity;i++)
    {
        if(_states[i]==1)
        {
            _keyAdapter.destroy(_keys[i]);
            _valueAdapter.destroy(_values[i]);
        }
        _states[i]=0;
    }
    _size=0;
    _used=0;
}
')
