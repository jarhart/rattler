Feature: Positive Lookahead Operator
  In order to define zero-width positive lookahead expressions
  As a language designer
  I want to use the positive lookahead operator in my grammar
  
  Scenario Outline: Parsing
    Given a grammar with:
    """
    start <- "A" &"B"
    """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "AB"  | "A"    |
    | "A"   | FAIL   |
    | "AC"  | FAIL   |