Feature: Negative Lookahead Operator
  
  A negative lookahead predicate matches only if a parsing expression would NOT
  match and never consumes input.

  Negative lookahead is written by placing a "!" in front of a parsing
  expression.
  
  Scenario Outline: Parsing
    Given a grammar with:
      """
      a <- "A" !"B"
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "A"   | "A"    |
    | "AC"  | "A"    |
    | "AB"  | FAIL   |