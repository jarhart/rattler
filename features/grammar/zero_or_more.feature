Feature: Zero-Or-More
  
  The "*" operator following an expression means to match zero or more times,
  i.e. match repeatedly and succeed even if no input was matched.
  
  In order to define an expression that matches zero or more times
  As a language designer
  I want to use a "zero-or-more" postfix operator in my grammar
  
  Scenario Outline: Capturing Expression
    Given a grammar with:
    """
    start <- alpha*
    """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input | result          | pos |
    | "A"   | ["A"]           | 1   |
    | "foo" | ["f", "o", "o"] | 3   |
    | "234" | []              | 0   |
  
  Scenario Outline: Non-Capturing Expression
    Given a grammar with:
    """
    start <- ~alpha*
    """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input | result | pos |
    | "A"   | true   | 1   |
    | "foo" | true   | 3   |
    | "234" | true   | 0   |