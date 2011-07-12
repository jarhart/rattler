Feature: Semantic side-effects

  A semantic side-effect can be defined by placing a "~" in front of a symantic
  action. The expression is evaulated for effect and always succeeds with no
  parse result.

  Scenario: Side-effect
    Given a grammar with:
      """
      expr  <- set_i @ALPHA+ { [_, @i] }
      set_i <- @DIGIT+ ~{ @i = _.to_i }
      """
    When I parse "42foo"
    Then the parse result should be [["42", "foo"], 42]
