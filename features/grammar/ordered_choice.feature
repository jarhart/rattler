Feature: Ordered Choice Expressions
  In order to define multiple alternatives for an expression
  As a language designer
  I want to use ordered choice expressions in my grammar

  Scenario Outline: Parsing
    Given a grammar with:
    """
    start <- "A" | "B"
    """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "A"   | "A"    |
    | "AB"  | "A"    |
    | "B"   | "B"    |
    | "BA"  | "B"    |
    | "C"   | FAIL   |