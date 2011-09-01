Feature: Token Operator
  
  The "@" operator in front of a parsing expression causes it to match as a
  token. The parse result is the entire string matched by the expression, and
  whitespace is never automatically skipped within the expression. The
  expression becomes atomic, so any defined whitespace will be automatically
  skipped before the token is matched.
  
  Scenario: Nested sequences and repeats
    Given a grammar with:
      """
      number <- @("-"? DIGIT+ ("." DIGIT+)?)
      """
    When I parse "23.45"
    Then the parse result should be "23.45"
  
  Scenario: With whitespace defined
    Given a grammar with:
      """
      %whitespace SPACE*
      number <- @("-"? DIGIT+ ("." DIGIT+)?)
      """
    When I parse "  23 . 45"
    Then the parse result should be "23"
  
  Scenario: With non-capturing sub-expressions
    Given a grammar with:
      """
      product <- @(DIGIT+ ~"*" DIGIT+)
      """
    When I parse "23*45"
    Then the parse result should be "23*45"