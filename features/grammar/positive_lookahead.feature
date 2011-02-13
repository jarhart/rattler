Feature: Positive Lookahead Operator
  
  The "&" operator before an expression means to match only if the expression
  would match here but never consume any input. This is known as zero-width
  positive lookahead.
  
  In order to define zero-width positive lookahead expressions
  As a language designer
  I want to use the positive lookahead operator in my grammar
  
  Scenario Outline: Parsing
    Given a grammar with:
      """
      expr <- "A" &"B"
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "AB"  | "A"    |
    | "A"   | FAIL   |
    | "AC"  | FAIL   |