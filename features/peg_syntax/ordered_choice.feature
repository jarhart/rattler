Feature: Ordered Choice
  
  An ordered choice tries a series of parsing expressions in order until one
  matches, and fails if none of the expressions match.  The first expression
  that matches is the one that is used.

  An ordered choice is written as a series of parsing expressions separated by
  "/".  The "/" has the lowest precedence.
  
  Scenario Outline: Parsing
    Given a grammar with:
      """
      expr <- "A" / "B"
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
