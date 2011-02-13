Feature: Token Operator
  
  The "@" operator before an expression means match as a token, i.e the result
  is the entire matched string and whitespace within the token is never
  automatically skipped. The expression becomes atomic, so any defined
  whitespace will be automatically skipped before the token.
  
  In order to match arbitrarily complex expressions as tokens
  As a language designer
  I want to use a "token" prefix operator in my grammar
  
  Scenario: Nested sequences and repeats
    Given a grammar with:
    """
    start <- @("-"? digit+ ("." digit+)?)
    """
    When I parse "23.45"
    Then the parse result should be "23.45"
  
  Scenario: With whitespace defined
    Given a grammar with:
    """
    %whitespace space*
    start <- @("-"? digit+ ("." digit+)?)
    """
    When I parse "23 . 45"
    Then the parse result should be "23"
  
  Scenario: With non-capturing sub-expressions
    Given a grammar with:
    """
    start <- @(digit+ ~"*" digit+)
    """
    When I parse "23*45"
    Then the parse result should be "23*45"