Feature: "Any Character" Symbol

  The "." (period) means match any single character.

  In order to match any single character
  As a language designer
  I want to use the "." symbol in my grammar
  
  Scenario Outline: Parsing
    Given a grammar with:
      """
      char <- .
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "foo" | "f"    |
    | " ba" | " "    |
    | ""    | FAIL   |
