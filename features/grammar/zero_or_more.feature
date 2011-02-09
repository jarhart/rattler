Feature: Zero-Or-More Operator
  In order to define an expression that matches zero or more times
  As a language designer
  I want to use a "zero-or-more" postfix operator in my grammar
  
  Scenario Outline: Parsing
    Given a grammar with:
    """
    start <- alpha*
    """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result          |
    | "A"   | ["A"]           |
    | "foo" | ["f", "o", "o"] |
    | "234" | []              |