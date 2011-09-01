Feature: Optional Operator
  
  The "?" operator following a parsing expression makes it optional, so that it
  succeeds even if the expression does not match.
  
  Scenario Outline: Capturing Expression
    Given a grammar with:
      """
      expr <- ALPHA?
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input | result | pos |
    | "A"   | ["A"]  | 1   |
    | "foo" | ["f"]  | 1   |
    | "234" | []     | 0   |
  
  Scenario Outline: Non-Capturing Expression
    Given a grammar with:
      """
      expr <- ~"_"?
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input | result | pos |
    | "_"   | true   | 1   |
    | "___" | true   | 1   |
    | "foo" | true   | 0   |