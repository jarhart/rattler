Feature: EOF Symbol
  
  The symbol "EOF" matches the end of the source, i.e. it matches only if there
  is no more input.  This can be used to ensure that a parse fails unless the
  entire input is matched.
  
  Background: A grammar with the EOF symbol
    Given a grammar with:
      """
      end <- EOF
      """
  
  Scenario: At end-of-input
    When I parse "foo"
      And the parse position is 3
    Then the parse result should be true
  
  Scenario: Before end-of-input
    When I parse "foo"
      And the parse position is 2
    Then the parse should fail
