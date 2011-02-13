Feature: Optional Operator
  
  The "?" operator following an expression makes the it optional, meaning it
  succeeds even if no input is matched.
  
  In order to define an expression that matches optionally
  As a language designer
  I want to use an "optional" postfix operator in my grammar
  
  Scenario Outline: Capturing Expression
    Given a grammar with:
    """
    start <- ALPHA?
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
    start <- ~ALPHA?
    """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input | result | pos |
    | "A"   | true   | 1   |
    | "foo" | true   | 1   |
    | "234" | true   | 0   |