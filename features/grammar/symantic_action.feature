Feature: Symantic Actions
  In order to add simple symantics to parse results
  As a language designer
  I want to use symantic actions in my grammar
  
  Scenario: Single token
    Given a grammar with:
    """
    start <- /\d+/ {|_| _.to_i }
    """
    When I parse "42"
    Then the parse result should be 42
  
  Scenario: Shortcut form
    Given a grammar with:
    """
    start <- /\d+/ <.to_i>
    """
    When I parse "23"
    Then the parse result should be 23
  
  Scenario: Sequence
    Given a grammar with:
    """
    %whitespace space*
    start <- /\d+/ /\d+/ {|a,b| a.to_i * b.to_i }
    """
    When I parse "3 16"
    Then the parse result should be 48
    
  Scenario: Sequence with non-capturing expressions
    Given a grammar with:
    """
    start <- ~"(" /\d+/ ~"+" /\d+/ ~")" {|a,b| a.to_i + b.to_i }
    """
    When I parse "(23+17)"
    Then the parse result should be 40
  
  Scenario: Sequence with labeled expressions
    Given a grammar with:
    """
    start <- "(" left:/\d+/ "+" right:/\d+/ ")" { left.to_i + right.to_i }
    """
    When I parse "(17+29)"
    Then the parse result should be 46