Feature: Zero-Or-More
  
  The "*" operator following a parsing expression causes it to match repeatedly
  and succeed even if the expression never matches, i.e. it matches zero or
  more times.
  
  Scenario Outline: Capturing expression
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
  
  Scenario Outline: Non-Capturing expression
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

  Scenario Outline: Choice of capturing or non-capturing
    Given a grammar with:
      """
      expr  <- ("a" / ~"b")*
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input | result     | pos |
    | "aa"  | ["a", "a"] | 2   |
    | "aba" | ["a", "a"] | 3   |
    | "bbc" | []         | 2   |

  Scenario: Semantic attribute returning true
    Given a grammar with:
      """
      expr  <- (ALPHA { true })*
      """
    When I parse "foo "
    Then the parse result should be []
      And the parse position should be 3
