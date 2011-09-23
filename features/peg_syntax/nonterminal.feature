Feature: Nonterminals

  A nonterminal is a reference to another parse rule that matches according to
  that rule.  Nonterminals can be used to factor the grammar or to define
  recursive rules.
  
  A nonterminal is simply the name of the other rule.
  
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
      expr  <-  xs "y"
      xs    <-  "x" xs
              / "x"
      """
    When I parse "xxxy"
    Then the parse result should be [["x", ["x", "x"]], "y"]

  Scenario: Direct left-recursion
    Given a grammar with:
      """
      xs  <-  xs "x"
            / "x"
      """
    When I parse "xxxx"
    Then the parse result should be [[["x", "x"], "x"], "x"]

  Scenario: Indirect left-recursion
    Given a grammar with:
      """
      a   <-  b "x"
            / "y"
      b   <-  a "y"
            / "x"
      """
    When I parse "xxyx"
    Then the parse result should be [[["x", "x"], "y"], "x"]
