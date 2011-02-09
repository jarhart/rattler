Feature: Whitespace
  In order to focus on the structure of my language
  As a language designer
  I want to specify whitespace in my grammar once and only once
  
  Scenario: Block form
    Given a grammar with:
    """
    %whitespace space* {
      start <- /\w+/
    }
    """
    When I parse "  foo"
    Then the parse result should be "foo"
  
  Scenario: Shorcut form
    Given a grammar with:
    """
    %whitespace space*
    start <- /\w+/
    """
    When I parse "  foo"
    Then the parse result should be "foo"
    