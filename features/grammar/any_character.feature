Feature: "Any Character" Symbol

  A "." (period) matches any single character.

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
