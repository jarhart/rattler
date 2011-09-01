Feature: Character Classes

  A character class defines a set of characters and matches any single
  character in the set.

  A character class is written as square brackets surrounding a set of
  characters.

  Character classes are identical in syntax and semantics to character classes
  in Ruby's regular expressions.
  
  Scenario Outline: Parsing
    Given a grammar with:
      """
      word_char <- [A-Za-z_]
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "foo" | "f"    |
    | "BAR" | "B"    |
    | "_ba" | "_"    |
    | "42"  | FAIL   |