# Hex

[![mops-test](https://github.com/f0i/hex/actions/workflows/mops-test.yml/badge.svg)](https://github.com/f0i/hex/actions/workflows/mops-test.yml)

A Motoko library to convert between `Nat8` values/arrays and hexadecimal string representations.

## Installation

Install the library from mops:

```bash
mops add hex
```

## API

### toText

Converts a byte array to a hex string.

```motoko
import Hex "mo:hex";

let hex = Hex.toText([0x12, 0x34, 0x56]);
// hex == "123456"
```

### toTextFormat

Converts a byte array to a hex string with custom formatting. For more details on formatting options, see [Format](#format).

```motoko
import Hex "mo:hex";

let hex = Hex.toTextFormat([1, 2], Hex.VERBOSE);
// hex == "[ 0x01, 0x02 ]"
```

### toArray

Converts a hex string to a byte array.

```motoko
import Hex "mo:hex";

let bytes = Hex.toArray("123456");
// bytes == #ok([0x12, 0x34, 0x56])
```

### toArrayFormat

Converts a hex string with custom formatting to a byte array. For more details on formatting options, see [Format](#format).

```motoko
import Hex "mo:hex";

let bytes = Hex.toArrayFormat("[ 0x01, 0x02 ]", Hex.VERBOSE);
// bytes == #ok([1, 2])
```

### toArrayUnsafe

Converts a hex string to a byte array, trapping on invalid input.

```motoko
import Hex "mo:hex";

let bytes = Hex.toArrayUnsafe("123456");
// bytes == [0x12, 0x34, 0x56]
```

### toText2D

Converts a 2D byte array to a hex string.

```motoko
import Hex "mo:hex";

let hex = Hex.toText2D([[0x12, 0x34], [0x56, 0x78]]);
// hex == "[1234, 5678]"
```

### toText2DFormat

Converts a 2D byte array to a hex string with custom formatting. For more details on formatting options, see [Format2D](#format2d).

```motoko
import Hex "mo:hex";

let hex = Hex.toText2DFormat([[1,2], []], Hex.COMPACT_2D);
// hex == "[12, 0]"
```

## Constants

### Format

`Format` is a record type used to define custom formatting options for hexadecimal strings.

```motoko
import Hex "mo:hex";

let customFormat = {
  pre = "<";
  post = ">";
  sep = "-";
  preItem = "";
  empty = "";
};
print(Hex.toTextFormat([0x12, 0x34], customFormat));
/*
<12-34>
*/
```

**COMPACT**

A `Format` constant for compact hexadecimal representation (no prefixes, postfixes, or separators).

```motoko
import Hex "mo:hex";

print(Hex.toTextFormat([0x12, 0x34, 0x56], Hex.COMPACT));
/*
123456
*/
```

**COMPACT_PREFIX**

A `Format` constant for compact hexadecimal representation with a "0x" prefix for the entire string.

```motoko
import Hex "mo:hex";

print(Hex.toTextFormat([0x12, 0x34, 0x56], Hex.COMPACT_PREFIX));
/*
0x123456
*/
```

**VERBOSE**

A `Format` constant for verbose hexadecimal representation, including brackets, "0x" prefixes for items, and comma separators.

```motoko
import Hex "mo:hex";

print(Hex.toTextFormat([0x12, 0x34, 0x56], Hex.VERBOSE));
/*
[ 0x12, 0x34, 0x56 ]
*/
```

### Format2D

`Format2D` is a record type used to define custom formatting options for two-dimensional hexadecimal strings. It contains two `Format` records: `inner` for the inner arrays and `outer` for the outer array.

```motoko
import Hex "mo:hex";

let customFormat2D = {
  inner = { pre = "("; post = ")"; sep = ","; preItem = ""; empty = "" };
  outer = { pre = "{"; post = "}"; sep = ";"; preItem = ""; empty = "" };
};
print(Hex.toText2DFormat([[0x01, 0x02], [0x03]], customFormat2D));
/*
{(01,02);(03)}
*/
```

**COMPACT_2D**

A `Format2D` constant for compact two-dimensional hexadecimal representation.

```motoko
import Hex "mo:hex";

print(Hex.toText2DFormat([[0x12, 0x34], [0x56, 0x78]], Hex.COMPACT_2D));
/*
[1234, 5678]
*/
```

**VERBOSE_2D**

A `Format2D` constant for verbose two-dimensional hexadecimal representation.

```motoko
import Hex "mo:hex";

print(Hex.toText2DFormat([[0x12, 0x34], [0x56, 0x78]], Hex.VERBOSE_2D));
/*
[ 0x12, 0x34 ], [ 0x56, 0x78 ]
*/
```

**MATRIX_2D**

A `Format2D` constant for a matrix-like representation of two-dimensional hexadecimal arrays.

```motoko
import Hex "mo:hex";

print(Hex.toText2DFormat([[0x01, 0x02], [0x03, 0x04]], Hex.MATRIX_2D));
/*
[ [ 0x01, 0x02 ],
  [ 0x03, 0x04 ] ]
*/
```

## License

This project is licensed under the MIT License.