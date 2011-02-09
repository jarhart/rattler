Feature: Nonterminals
  In order to define context-free languages with recursive definitions
  As a language designer
  I want to use nonterminal expressions in my grammar
  
  Scenario: Simple example
    Given a grammar with:
    """
    start <-  foo* "b"
    foo   <-  "a"
    """
    When I parse "aaab"
    Then the parse result should be [["a", "a", "a"], "b"]
  
  Scenario: Recursive definition
    Given a grammar with:
    """
    start <-  foo "b"
    foo   <-  "a" foo
            | "a"
    """
    When I parse "aaab"
    Then the parse result should be [["a", ["a", "a"]], "b"]