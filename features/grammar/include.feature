Feature: include

  A grammar can include another grammar and use or override its rules.

  Scenario Outline: Included grammar
    Given a grammar called "ExprGrammar" with:
      """
      a <- "A"
      """
    And a grammar with:
      """
      include ExprGrammar
      
      expr <- a
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input | result |
    | "A"   | "A"    |
    | "B"   | FAIL   |
  
  Scenario Outline: Overriding a rule
    Given a grammar called "ExprGrammar" with:
      """
      expr  <- a
      a     <- "A"
      """
    And a grammar with:
      """
      include ExprGrammar
      
      a <- "B"
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input | result |
    | "B"   | "B"    |
    | "A"   | FAIL   |
