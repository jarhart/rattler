Feature: Positive Lookahead Operator
  
  A positive lookahead predicate matches if a parsing expression would match
  but the predicate consumes no input.

  Positive lookahead is written by placing a "&" in front of a parsing
  expression.
  
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
