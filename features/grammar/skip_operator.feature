Feature: Skip Operator
  In order to match syntax without it being included in the parse results
  As a language designer
  I want to use a "skip" prefix operator in my grammar
  
  Scenario: Sequence with skipped sub-expressions
    Given a grammar with:
    """
    start <- ~"(" /\d+/ ~"+" /\d+/ ~")"
    """
    When I parse "(23+45)"
    Then the parse result should be ["23", "45"]
  
  Scenario: Rule with entire expression skipped
    Given a grammar with:
    """
    start <- ~"foo"
    """
    When I parse "foo"
    Then the parse result should be true
      And the parse position should be 3