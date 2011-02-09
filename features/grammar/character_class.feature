Feature: Character Classes
  In order to match specific sets of character
  As a language designer
  I want to use character classes in my grammar
  
  Scenario Outline: Parsing
    Given a grammar with:
    """
    start <- [A-Za-z_]
    """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "foo" | "f"    |
    | "BAR" | "B"    |
    | "_ba" | "_"    |
    | "42"  | FAIL   |