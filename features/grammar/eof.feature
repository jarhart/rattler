Feature: EOF Symbol
  
  The symbol "EOF" means to match the end of the source, i.e. match only if
  there is no more input.
  
  In order to match the end of the input
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