Feature: Zero-Or-More
  
  The "*" operator following an expression means to match zero or more times,
  i.e. match repeatedly and succeed even if no input was matched.
  
  In order to define an expression that matches zero or more times
  As a language designer
  I want to use a "zero-or-more" postfix operator in my grammar
  
  Scenario Outline: Capturing Expression
    Given a grammar with:
      """
      letters <- ALPHA*
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
      dashes <- ~"-"*
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input | result | pos |
    | "-"   | true   | 1   |
    | "---" | true   | 3   |
    | "foo" | true   | 0   |