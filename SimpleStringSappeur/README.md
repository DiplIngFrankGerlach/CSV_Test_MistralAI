# SimpleString for Sappeur

A small **mutable, ASCII/byte-oriented** string class inspired by the common operations of Java's `String`. Written in native Sappeur; no `inline_cpp` is used.

## Files
- `SimpleString.ad` — declaration (include in `compileorder` before dependents)
- `SimpleString.ai` — implementation
- `SimpleStringTest.ad`, `SimpleStringTest.ai` — functional checks; call `SimpleStringTest::run(result)` from your application's main method.

## Example

```sappeur
var SimpleString greeting("Hello");
greeting.append(", world");
var int index=greeting.indexOf("world"); // 7
var SimpleString substring;
var int ok=greeting.substring(7,12,substring); // substring = "world"
```

## Supported operations

| Category | Methods |
|---|---|
| Construction and mutation | constructors, `assign`, `append`, `appendChar`, `clear`, `reserve`, `setCharAt` |
| Inspection | `length`, `isEmpty`, `capacity`, `charAt` |
| Comparison | `equals`, `compareTo` |
| Matching/search | `startsWith`, `endsWith`, `indexOf`, `indexOfFrom`, `lastIndexOf`, `contains` |
| Transformations | `substring`, `replace` (single characters), `trim`, `toLowerCase`, `toUpperCase` |
| Interop | `toCharArray` (NUL-terminated) |

## Behavioral notes

- Unlike Java `String`, this is **mutable**. Transformation methods write to a `SimpleString` output parameter, allowing both ordinary output and in-place output where supported. `substring` returns 1 on success, 0 on invalid indexes; it does not change the destination on failure.
- `charAt` returns `\0` for an invalid index; `setCharAt` returns 0 for invalid index/value. Java would throw an exception.
- `compareTo` returns -1, 0 or 1 for bytewise lexicographic order. Letter case conversion and `trim` are **ASCII only**, not Unicode.
- Internal `char` array is NUL-terminated; embedded NULs are unsupported. Capacity excludes that terminator.
- `indexOf` / `lastIndexOf` return -1 if absent; empty needle follows Java's conventional position behavior.
- Input text is accepted as a Sappeur char array, bounded by `.sz`, and scanned until first NUL. Sappeur's `new` may still fail at runtime on allocation exhaustion.
- Length is limited to `2147483646` bytes to avoid signed-32-bit overflow on allocation length `capacity+1`. Operations exceeding that limit return without changing the string.
- Methods are not `external`; `SimpleString` is not multithreaded. Do not share an instance across threads without redesigning its synchronization.

## Status

This is a source-based implementation aligned with the supplied manual and the latest `SappeurRules(3).txt`. The `.ad` and `.ai` files have not been compiled against the actual Sappeur compiler here. Run the compiler and tests in your Sappeur project to verify the exact toolchain syntax and behavior.

## Literal-friendly overloads

Sappeur accepts string literals with `&char[]` method parameters, as shown in
`Learning Sappeur` and the language manual. You can now call `equals`,
`compareTo`, `startsWith`, `endsWith`, `indexOf`, `indexOfFrom`,
`lastIndexOf`, `contains`, `assign`, and `append` directly with a literal:

```sappeur
var SimpleString text("Hello World");
if(text.startsWith("Hello") == 1) { /* ... */ }
var int pos=text.indexOfFrom("o",5); // 7
text.append("!");
```

The new overloads currently build a temporary `SimpleString` and delegate
to the corresponding existing method. This favors simple, consistent behavior
over allocation-free literal searches. All input is byte-oriented and
NUL-terminated; Unicode case handling is not implemented.

## Compliance with updated SappeurRules(3).txt

- Rule 19: no `cast(...)` occurs inside an `if`, `while`, or `switch` condition.
- Rule 20: ASCII trim whitespace classification uses a `switch` on the precomputed integer character code instead of a multi-OR `if`.
- Rule 21: The static test entry point uses `static void run(&int result)` and reports the outcome through the reference argument.
- Rule 22: All `.ai` method implementations now have Doxygen-style headers (`@brief`, `@param`, `@return` as applicable).
- The remaining comparisons are ordinary range, length, and loop checks; they do not naturally form switch dispatches.
- Literal overloads (`&char[]`) remain supported, with tests for both object and literal calls.
- The additional tests exercise TAB, LF, CR, all-whitespace input, and empty strings.

No Sappeur compiler was present in the execution environment, so these changes are statically reviewed but **not compiler-verified**.

## Running the tests

```sappeur
var int result=0;
SimpleStringTest::run(result);
// result == 1: success; negative values identify the first failed check.
```

The test entry point is `static void run(&int result);`.
