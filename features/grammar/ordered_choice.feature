Feature: Ordered Choice Expressions
  
  An ordered choice expression is a series of sub-expressions separated by "|"
  and it means to try each sub-expression in order until one matches, and fail
  if none of the sub-expressions match.
  
  In order to define multiple alternatives for an expression
  As a language designer
  I want to use ordered choice expressions in my grammar

  Scenario Outline: Parsing
    Given a grammar with:
      """
      expr <- "A" | "B"
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