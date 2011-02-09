Feature: EOF Symbol
  In order to
  As a language designer
  I want to use the EOF symbol in my grammar
  
  Background: A grammar with the EOF symbol
    Given a grammar with:
    """
    start <- EOF
    """
  
  Scenario: At end-of-input
    When I parse "foo"
      And the parse position is 3
    Then the parse result should be true
  
  Scenario: Before end-of-input
    When I parse "foo"
      And the parse position is 2
    Then the parse should fail