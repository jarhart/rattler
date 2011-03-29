Feature: Skip Operator
  
  The "~" operator before an expression means to match but ignore the result.
  
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
      