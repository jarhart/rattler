Feature: super keyword

  A rule that redefines a rule from an included grammar can match using the
  included grammar's version of the rule by using the "super" keyword.

  Scenario Outline: Included Grammar
    Given a grammar called "ExprGrammar" with:
      """
      expr <- "A"
      """
    And a grammar with:
      """
      include ExprGrammar
      
      expr <- super / "B"
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input | result |
    | "A"   | "A"    |
    | "B"   | "B"    |
    | "C"   | FAIL   |
