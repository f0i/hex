import Hex "../src";
import { print } "mo:core/Debug";

print("# Hex");
print("- toText");
assert Hex.toText([0x12, 0x34, 0x56]) == "123456";
assert Hex.toText([0xab, 0xcd, 0xef]) == "abcdef";
assert Hex.toText([]) == "";
assert Hex.toText([0, 1, 2, 255]) == "000102ff";

print("- toText2D");
assert Hex.toText2D([]) == "[]";
assert Hex.toText2D([[]]) == "[0]";
assert Hex.toText2D([[], []]) == "[0, 0]";
assert Hex.toText2D([[0x12, 0x34], [0x56, 0x78]]) == "[1234, 5678]";
assert Hex.toText2D([[0xab, 0xcd], [0xef, 0x00]]) == "[abcd, ef00]";

print("- toArray");
assert Hex.toArray("123456") == #ok([0x12, 0x34, 0x56]);
assert Hex.toArray("abcdef") == #ok([0xab, 0xcd, 0xef]);
assert Hex.toArray("AbCdEf") == #ok([0xab, 0xcd, 0xef]);
assert Hex.toArray("") == #ok([]);
assert Hex.toArray("0") == #ok([0]);
assert Hex.toArray("a") == #ok([10]);
assert Hex.toArray("123") == #ok([0x01, 0x23]);
assert Hex.toArray("12345") == #ok([0x01, 0x23, 0x45]);

assert Hex.toArray("12345g") == #err("Invalid hex byte: 5g");

print("- toArrayUnsafe");
assert Hex.toArrayUnsafe("123456") == [0x12, 0x34, 0x56];
assert Hex.toArrayUnsafe("abcdef") == [0xab, 0xcd, 0xef];
assert Hex.toArrayUnsafe("AbCdEf") == [0xab, 0xcd, 0xef];
assert Hex.toArrayUnsafe("") == [];
assert Hex.toArrayUnsafe("0") == [0];
assert Hex.toArrayUnsafe("a") == [10];
assert Hex.toArrayUnsafe("123") == [0x01, 0x23];
assert Hex.toArrayUnsafe("12345") == [0x01, 0x23, 0x45];

print("- toTextFormat");
let options : Hex.Format = {
  pre = "[ ";
  post = " ]";
  sep = ", ";
  preItem = "0x";
  empty = "[]";
  upper = false;
};
assert Hex.toTextFormat([1, 2], options) == "[ 0x01, 0x02 ]";
assert Hex.toTextFormat([], options) == "[]";
assert Hex.toTextFormat([1, 2], Hex.VERBOSE) == "[ 0x01, 0x02 ]";
assert Hex.toTextFormat([], Hex.VERBOSE) == "[]";
assert Hex.toTextFormat([0xab, 0xcd, 0xef], Hex.COMPACT_UPPER) == "ABCDEF";
assert Hex.toTextFormat([], Hex.COMPACT_UPPER) == "";
assert Hex.toTextFormat([171, 205], Hex.VERBOSE_UPPER) == "[ 0xAB, 0xCD ]";
assert Hex.toTextFormat([], Hex.VERBOSE_UPPER) == "[]";

print("- toArrayFormat");
assert Hex.toArrayFormat("[ 0x01, 0x02 ]", options) == #ok([1, 2]);
assert Hex.toArrayFormat("[]", options) == #ok([]);
assert Hex.toArrayFormat("123456", Hex.COMPACT) == #ok([0x12, 0x34, 0x56]);
assert Hex.toArrayFormat("[ 0x01, 0x02 ]", Hex.VERBOSE) == #ok([1, 2]);
assert Hex.toArrayFormat("[]", Hex.VERBOSE) == #ok([]);
assert Hex.toArrayFormat("[ 0x01, 0x02", options) == #err("Hex value does not end with  ]: [ 0x01, 0x02");
assert Hex.toArrayFormat(" 0x01, 0x02 ]", options) == #err("Hex value does not start with [ 0x:  0x01, 0x02 ]");
assert Hex.toArrayFormat("0x01, 0x02 ]", options) == #err("Hex value does not start with [ 0x: 0x01, 0x02 ]");
assert Hex.toArrayFormat("[ 01, 02 ]", options) == #err("Hex value does not start with [ 0x: [ 01, 02 ]");
assert Hex.toArrayFormat("[ 0x01, 0x02", options) == #err("Hex value does not end with  ]: [ 0x01, 0x02");
assert Hex.toArrayFormat("[ 0x01 0x02 ]", options) == #err("Invalid hex byte: 1 ");

let options2D : Hex.Format2D = {
  inner = {
    pre = "";
    post = "";
    sep = " ";
    preItem = "0x";
    empty = "?";
    upper = false;
  };
  outer = {
    pre = "< ";
    post = " >";
    preItem = "";
    sep = " ; ";
    empty = "< >";
    upper = false;
  };
};

print("- toArrayFormatUnsafe");
assert Hex.toArrayFormatUnsafe("[ 0x01, 0x02 ]", Hex.VERBOSE) == [1, 2];
assert Hex.toArrayFormatUnsafe("[]", Hex.VERBOSE) == [];
assert Hex.toArrayFormatUnsafe("123456", Hex.COMPACT) == [0x12, 0x34, 0x56];

print("- toText2DFormat");
assert Hex.toText2DFormat([[1, 2], []], options2D) == "< 0x01 0x02 ; ? >";
assert Hex.toText2DFormat([], options2D) == "< >";
assert Hex.toText2DFormat([[]], options2D) == "< ? >";
assert Hex.toText2DFormat([[1, 2], [3, 4]], Hex.MATRIX_2D) == "[ [ 0x01, 0x02 ],\n  [ 0x03, 0x04 ] ]";

print("- Helper Functions");
// decodeNibble
assert Hex.decodeNibble('0') == ?0;
assert Hex.decodeNibble('9') == ?9;
assert Hex.decodeNibble('a') == ?10;
assert Hex.decodeNibble('f') == ?15;
assert Hex.decodeNibble('A') == ?10;
assert Hex.decodeNibble('F') == ?15;
assert Hex.decodeNibble('g') == null;

// encodeNibble
assert Hex.encodeNibble(0) == "0";
assert Hex.encodeNibble(9) == "9";
assert Hex.encodeNibble(10) == "a";
assert Hex.encodeNibble(15) == "f";

// encodeNibbleUpper
assert Hex.encodeNibbleUpper(0) == "0";
assert Hex.encodeNibbleUpper(9) == "9";
assert Hex.encodeNibbleUpper(10) == "A";
assert Hex.encodeNibbleUpper(15) == "F";

// encodeByte
assert Hex.encodeByte(0x00) == "00";
assert Hex.encodeByte(0x01) == "01";
assert Hex.encodeByte(0x0a) == "0a";
assert Hex.encodeByte(0xff) == "ff";

// encodeByteUpper
assert Hex.encodeByteUpper(0x00) == "00";
assert Hex.encodeByteUpper(0x01) == "01";
assert Hex.encodeByteUpper(0x0a) == "0A";
assert Hex.encodeByteUpper(0xff) == "FF";