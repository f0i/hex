import Array "mo:core/Array";
import Iter "mo:core/Iter";
import Char "mo:core/Char";
import Nat8 "mo:core/Nat8";
import Result "mo:core/Result";
import Text "mo:core/Text";
import { unreachable; trap } "mo:core/Runtime";

/// Function to convert between hex and byte arrays
module {

  type Iter<T> = Iter.Iter<T>;

  /// Access elements of an iterator two at a time
  /// Traps if `iter` contains an odd number of elements
  func pairs<T>(iter : Iter<T>) : Iter<(T, T)> {

    func next() : ?(T, T) {
      switch (iter.next(), iter.next()) {
        case (?a, ?b) { return ?(a, b) };
        case (?_, null) {
          trap("Warning: discard last (odd) element from iterator in pairs()");
          return null;
        };
        case (null, ?_) { unreachable() };
        case (null, null) return null;
      };
    };

    return { next };
  };

  /// Add a single element in front of an iterator
  /// If you need to prepend more than one element, consider using `Iter.flatten` instead
  func prepend<T>(element : T, iter : Iter<T>) : Iter<T> {
    var first = true;
    return {
      next = func() : ?T {
        if (first) {
          first := false;
          return ?element;
        } else {
          iter.next();
        };
      };
    };
  };

  /// Convert a byte array to hex Text
  public func toText(bytes : [Nat8]) : Text {
    var out = "";
    for (byte in bytes.vals()) {
      // Text.join uses a similar loop with `#=` so performance should be same or better compared to Iter.map |> Text.join
      out #= encodeByte(byte);
    };
    return out;
  };

  /// Convert an array of byte arrays to hex Text
  public func toText2D(bytess : [[Nat8]]) : Text {
    let texts = Array.map<[Nat8], Text>(bytess, func(bs) { if (bs == []) "0" else toText(bs) });
    return "[" # Text.join(", ", texts.vals()) # "]";
  };

  /// Convert an array of byte arrays to hex Text with custom separator
  /// ```motoko
  /// let options = { pre = "< "; post = " >"; sep = " ; "; empty = "?" };
  /// let hex = toText2DFormat([[1, 2], []], options)
  /// assert hex == "< 0102 ; ? >"
  /// ```
  public func toText2DFormat(
    bytess : [[Nat8]],
    options : {
      pre : Text;
      post : Text;
      sep : Text;
      empty : Text;
    },
  ) : Text {
    let texts = Array.map<[Nat8], Text>(bytess, func(bs) { if (bs == []) options.empty else toText(bs) });
    return options.pre # Text.join(options.sep, texts.vals()) # options.post;
  };

  /// Convert hex Text into a byte array
  /// The input must only contain hexadecimal chars (upper or lower case)
  /// It the hex text is of odd length, it will assume a leading 0.
  public func toArray(hex : Text) : Result.Result<[Nat8], Text> {
    let chars = hex.size();
    let charsEven = chars % 2 == 0;
    let size = if charsEven { chars / 2 } else { chars / 2 + 1 };

    let charIter : Iter<Char> = if charsEven {
      hex.chars();
    } else {
      prepend('0', hex.chars());
    };

    let hexBytes = pairs<Char>(charIter);
    var err : ?Text = null;

    func getChar(_ : Nat) : Nat8 {
      let ?(high, low) = hexBytes.next() else unreachable();

      switch (decodeNibble(high), decodeNibble(low)) {
        case (?a, ?b) return (a * 16) + b;
        case (_, _) {
          if (err == null) {
            err := ?("Invalid hex byte: " # Char.toText(high) # Char.toText(low));
          };
          return 0;
        };
      };
    };

    var arr = Array.tabulate<Nat8>(size, getChar);

    switch (err) {
      case (?err) return #err(err);
      case (null) return #ok(arr);
    };
  };

  /// Convert hex Text into a byte array
  /// Similar to `toArray` but traps if `hex` contains invalid characters
  public func toArrayUnsafe(hex : Text) : [Nat8] {
    switch (toArray(hex)) {
      case (#ok(data)) return data;
      case (#err(msg)) trap("Hex.toArrayUnsafe: " # msg);
    };
  };

  /// Decode a single hex character
  func decodeNibble(c : Char) : ?Nat8 {
    switch (c) {
      case ('0') { ?0 };
      case ('1') { ?1 };
      case ('2') { ?2 };
      case ('3') { ?3 };
      case ('4') { ?4 };
      case ('5') { ?5 };
      case ('6') { ?6 };
      case ('7') { ?7 };
      case ('8') { ?8 };
      case ('9') { ?9 };
      case ('a') { ?10 };
      case ('b') { ?11 };
      case ('c') { ?12 };
      case ('d') { ?13 };
      case ('e') { ?14 };
      case ('f') { ?15 };
      case ('A') { ?10 };
      case ('B') { ?11 };
      case ('C') { ?12 };
      case ('D') { ?13 };
      case ('E') { ?14 };
      case ('F') { ?15 };
      case (_) { null };
    };
  };

  /// Encode a byte into hex Text containing exactly two hex characters
  func encodeByte(byte : Nat8) : Text {
    return encodeNibble(byte / 16) # encodeNibble(byte % 16);
  };

  /// Encode a nibble into a single hex character
  func encodeNibble(nibble : Nat8) : Text {
    switch (nibble) {
      case (0) { "0" };
      case (1) { "1" };
      case (2) { "2" };
      case (3) { "3" };
      case (4) { "4" };
      case (5) { "5" };
      case (6) { "6" };
      case (7) { "7" };
      case (8) { "8" };
      case (9) { "9" };
      case (10) { "a" };
      case (11) { "b" };
      case (12) { "c" };
      case (13) { "d" };
      case (14) { "e" };
      case (15) { "f" };
      case (_) {
        trap("invalid value in encodeNibble: " # Nat8.toText(nibble));
      };
    };
  };

};
