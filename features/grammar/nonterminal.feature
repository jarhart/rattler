Feature: Nonterminals
  
  A nonterminal is an identifier that refers to a parse rule and means to parse
  according to the rule. Nonterminals can be used to define recursive rules.
  
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
    