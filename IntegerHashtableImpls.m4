dnl Requires OpenAddressHash.ai.m4 from the existing Rules5 package.
dnl Generate IntegerHashtables.ai with this driver.
Import{
    "IntegerHashtableAdapters.ad",
    "IntegerHashtables.ad"
}

include(`OpenAddressHash.ai.m4')dnl

OAHT_IMPL(IntIntHashtable, int, int, IntKeyAdapter, IntValueAdapter)
OAHT_IMPL(IntLonglongHashtable, int, longlong, IntKeyAdapter, LonglongValueAdapter)
OAHT_IMPL(LonglongIntHashtable, longlong, int, LonglongKeyAdapter, IntValueAdapter)
OAHT_IMPL(LonglongLonglongHashtable, longlong, longlong, LonglongKeyAdapter, LonglongValueAdapter)
