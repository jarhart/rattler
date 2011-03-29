Feature: Negative Lookahead Operator
  
  The "!" operator before an expression means to match only if the expression
  would not match here and never consume any input. This is known as zero-width
  negative lookahead.
  
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