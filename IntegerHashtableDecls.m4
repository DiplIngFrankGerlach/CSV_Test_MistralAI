dnl Requires OpenAddressHash.ad.m4 from the existing Rules5 package.
dnl Generate IntegerHashtables.ad with this driver.
include(`OpenAddressHash.ad.m4')dnl

OAHT_DECL(IntIntHashtable, int, int, IntKeyAdapter, IntValueAdapter)
OAHT_DECL(IntLonglongHashtable, int, longlong, IntKeyAdapter, LonglongValueAdapter)
OAHT_DECL(LonglongIntHashtable, longlong, int, LonglongKeyAdapter, IntValueAdapter)
OAHT_DECL(LonglongLonglongHashtable, longlong, longlong, LonglongKeyAdapter, LonglongValueAdapter)
