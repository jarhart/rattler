Feature: Any Character Symbol
  In order to match any single character
  As a language designer
  I want to use the "any character" symbol in my grammar
  
  Scenario Outline: Parsing
    Given a grammar with:
    """
    start <- .
    """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "foo" | "f"    |
    | ""    | FAIL   |
