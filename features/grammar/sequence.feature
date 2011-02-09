Feature: Sequence Expressions
  In order to define an expression as a sequence of sub-expressions
  As a language designer
  I want to use sequence expressions in my grammar
  
  Scenario Outline: Parsing
    Given a grammar with:
    """
    start <- "A" "B"
    """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result     |
    | "AB"  | ["A", "B"] |
    | "ABC" | ["A", "B"] |
    | "A"   | FAIL       |
    | "C"   | FAIL       |