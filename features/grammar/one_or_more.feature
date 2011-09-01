Feature: One-Or-More
  
  The "+" operator following a parsing expression causes it to match repeatedly
  and succeed if the expression matches at least once.
  
  Scenario Outline: Capturing Expression
    Given a grammar with:
      """
      digits <- DIGIT+
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input | result          | pos |
    | "5"   | ["5"]           | 1   |
    | "234" | ["2", "3", "4"] | 3   |
    | "foo" | FAIL            | 0   |
  
  Scenario Outline: Non-Capturing Expression
    Given a grammar with:
      """
      dashes <- ~"-"+
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input | result | pos |
    | "-"   | true   | 1   |
    | "---" | true   | 3   |
    | "foo" | false  | 0   |