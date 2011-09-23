Feature: Sequences
  
  A sequence is a series of parsing expressions that matches if all of the
  expressions match in sequence. If any of the parsing expressions fail, the
  entire sequence fails and backtracks to the starting point.

  A sequence is written as a series of parsing expressions separated by spaces.

  Scenario Outline: Parsing
    Given a grammar with:
      """
      expr <- "A" "B"
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result     |
    | "AB"  | ["A", "B"] |
    | "ABC" | ["A", "B"] |
    | "ACB" | FAIL       |
    | "A"   | FAIL       |
    | "C"   | FAIL       |