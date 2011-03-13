Feature: Nonterminals
  
  A nonterminal is an identifier that refers to a parse rule and means to parse
  according to the rule. A nonterminal can recursively refer to the rule it is
  used in.
  
  In order to define context-free languages with recursive definitions
  As a language designer
  I want to use nonterminal expressions in my grammar
  
  Scenario: Simple example
    Given a grammar with:
      """
      expr  <-  a* "b"
      a     <-  "a"
      """
    When I parse "aaab"
    Then the parse result should be [["a", "a", "a"], "b"]
  
  Scenario: Recursive definition
    Given a grammar with:
      """
      expr  <-  as "b"
      as    <-  "a" as
              / "a"
      """
    When I parse "aaab"
    Then the parse result should be [["a", ["a", "a"]], "b"]