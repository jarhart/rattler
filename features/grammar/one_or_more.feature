Feature: One-Or-More Operator
  In order to define an expression that matches one or more times
  As a language designer
  I want to use a "one-or-more" postfix operator in my grammar
  
  Scenario Outline: Parsing
    Given a grammar with:
    """
    start <- digit+
    """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result          |
    | "5"   | ["5"]           |
    | "234" | ["2", "3", "4"] |
    | "foo" | FAIL            |