Feature: Literal Expressions
  In order to define symbols and keywords
  As a language designer
  I want to use string literals in my grammar
  
  Scenario Outline: Parsing
    Given a grammar with:
    """
    start <- "while"
    """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input   | result  |
    | "while" | "while" |
    | "whip"  | FAIL    |