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

### toArray

Converts a hex string to a byte array.

```motoko
import Hex "mo:hex";

let bytes = Hex.toArray("123456");
// bytes == #ok([0x12, 0x34, 0x56])
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

Converts a 2D byte array to a hex string with custom formatting.

```motoko
import Hex "mo:hex";

let options = { pre = "< "; post = " >"; sep = " -- "; empty = "?" };
let hex = Hex.toText2DFormat([[1,2], []], options);
// hex == "< 0102 -- ? >"
```

## License

This project is licensed under the MIT License.