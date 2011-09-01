Feature: Skip Operator
  
  The "~" operator in front of a parsing expression causes the expression's
  parse result to be discarded.
  
  Scenario: Sequence with skipped sub-expressions
    Given a grammar with:
      """
      sum <- ~"(" @DIGIT+ ~"+" @DIGIT+ ~")"
      """
    When I parse "(23+45)"
    Then the parse result should be ["23", "45"]
  
  Scenario: Rule with entire expression skipped
    Given a grammar with:
      """
      if <- ~"if"
      """
    When I parse "if "
    Then the parse result should be true
      And the parse position should be 2
      