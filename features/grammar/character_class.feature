Feature: Character Classes

  Character classes are sets of characters between "[" and "]" and mean match
  any single character in the set. They are identical to character classes in
  Ruby's regular expressions.
  
  In order to match specific sets of character
  As a language designer
  I want to use character classes in my grammar
  
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