import Hex "../src";

assert Hex.toText([0x12, 0x34, 0x56]) == "123456";
assert Hex.toText([0xab, 0xcd, 0xef]) == "abcdef";
assert Hex.toText([]) == "";
assert Hex.toText([0, 1, 2, 255]) == "000102ff";

assert Hex.toText2D([]) == "[]";
assert Hex.toText2D([[]]) == "[0]";
assert Hex.toText2D([[], []]) == "[0, 0]";
assert Hex.toText2D([[0x12, 0x34], [0x56, 0x78]]) == "[1234, 5678]";
assert Hex.toText2D([[0xab, 0xcd], [0xef, 0x00]]) == "[abcd, ef00]";

let options = { pre = "< "; post = " >"; sep = " ; "; empty = "?" };
assert Hex.toText2DFormat([[1, 2], []], options) == "< 0102 ; ? >";
assert Hex.toText2DFormat([], options) == "<  >";
assert Hex.toText2DFormat([[]], options) == "< ? >";

assert Hex.toArray("123456") == #ok([0x12, 0x34, 0x56]);
assert Hex.toArray("abcdef") == #ok([0xab, 0xcd, 0xef]);
assert Hex.toArray("AbCdEf") == #ok([0xab, 0xcd, 0xef]);
assert Hex.toArray("") == #ok([]);
assert Hex.toArray("0") == #ok([0]);
assert Hex.toArray("a") == #ok([10]);
assert Hex.toArray("123") == #ok([0x01, 0x23]);
assert Hex.toArray("12345") == #ok([0x01, 0x23, 0x45]);

assert Hex.toArray("12345g") == #err("Invalid hex byte: 5g");

assert Hex.toArrayUnsafe("123456") == [0x12, 0x34, 0x56];
assert Hex.toArrayUnsafe("abcdef") == [0xab, 0xcd, 0xef];
assert Hex.toArrayUnsafe("AbCdEf") == [0xab, 0xcd, 0xef];
assert Hex.toArrayUnsafe("") == [];
assert Hex.toArrayUnsafe("0") == [0];
assert Hex.toArrayUnsafe("a") == [10];
assert Hex.toArrayUnsafe("123") == [0x01, 0x23];
assert Hex.toArrayUnsafe("12345") == [0x01, 0x23, 0x45];

