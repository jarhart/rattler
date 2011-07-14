Feature: Negative Symantic Predicates

  A negative symantic predicate can be defined by placing a "!" in front of a
  symantic action. If the action results in a false value the parse succeeds
  with no parse result, otherwise the parse fails.

  Background: Negative predicate
    Given a grammar with:
      """
      integer <- @DIGIT+ !{ _.to_i > 20 }
      """

  Scenario: true
    When I parse "42"
    Then the parse should fail
  
  Scenario: false
    When I parse "17"
    Then the parse result should be "17"
