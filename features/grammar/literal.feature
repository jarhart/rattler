Feature: Literal Expressions
  
  A string literal is like a normal Ruby string literal and it means to match
  if that exact text is next in the input.
  
  In order to define symbols and keywords
  As a language designer
  I want to use string literals in my grammar
  
  Scenario Outline: Parsing
    Given a grammar with:
      """
      a <- "while"
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input    | result  |
    | "while"  | "while" |
    | " while" | FAIL    |
    | "whip"   | FAIL    |