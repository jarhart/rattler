Feature: Positive Semantic Predicates

  A positive semantic predicate can be defined by placing a "&" in front of a
  semantic action. If the action results in a true value the parse succeeds
  with no parse result, otherwise the parse fails.

  Background: Positive symantic predicate
    Given a grammar with:
      """
      integer <- @DIGIT+ &{ _.to_i > 20 }
      """

  Scenario: true
    When I parse "42"
    Then the parse result should be true
  
  Scenario: false
    When I parse "17"
    Then the parse should fail
