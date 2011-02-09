Feature: Optional Operator
  In order to define an expression that matches optionally
  As a language designer
  I want to use an "optional" postfix operator in my grammar
  
  Scenario Outline: Parsing
    Given a grammar with:
    """
    start <- alpha?
    """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "A"   | ["A"]  |
    | "foo" | ["f"]  |
    | "234" | []     |