Feature: Token Operator
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