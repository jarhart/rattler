Feature: Negative Lookahead Operator
  In order to define zero-width negative lookahead expressions
  As a language designer
  I want to use the negative lookahead operator in my grammar
  
  Scenario Outline: Parsing
    Given a grammar with:
    """
    start <- "A" !"B"
    """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "A"   | "A"    |
    | "AC"  | "A"    |
    | "AB"  | FAIL   |