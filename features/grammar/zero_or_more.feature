Feature: Zero-Or-More
  
  The "*" operator following a parsing expression causes it to match repeatedly
  and succeed even if the expression never matches.
  
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