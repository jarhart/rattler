Feature: E Symbol
  
  The symbol "E" always matches without consuming any input.
  
  Background: A grammar with the E symbol
    Given a grammar with:
      """
      foo <- E
      """

  Scenario: Before end-of-input
    When I parse "foo"
    Then the parse result should be true
  
  Scenario: At end-of-input
    When I parse "foo"
      And the parse position is 3
    Then the parse result should be true
