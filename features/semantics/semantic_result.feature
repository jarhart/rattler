Feature: Semantic Results

  A semantic result can be used to add a synthetic parse result using a Ruby
  expression.  The expression is evaluated and the result is inserted like a
  normal parse result.  This can be used to insert implicit syntax nodes into
  a parse tree, such as optional expression terminators.  Note that a false
  value with cause the parse to fail.

  A semantic result is written as a "^" followed by curly braces surrounding a
  Ruby expression.

  Scenario: Lone result
    Given a grammar with:
      """
      expr <- ^{ ";" }
      """
    When I parse "anything"
    Then the parse result should be ";"
      And the parse position should be 0
  
  Scenario: False result
    Given a grammar with:
      """
      expr <- ^{ false }
      """
    When I parse "anything"
    Then the parse should fail

  Scenario: Single-capture sequence
    Given a grammar with:
      """
      expr <- @DIGIT+ ^{|a| a.to_i }
      """
    When I parse "23"
    Then the parse result should be ["23", 23]
  
  Scenario: Multi-capture sequence
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ ^{|a,b| a.to_i * b.to_i }
      """
    When I parse "3 16"
    Then the parse result should be ["3", "16", 48]

  Scenario: Sequence with non-capturing expressions
    Given a grammar with:
      """
      expr <- ~"(" @DIGIT+ ~"+" @DIGIT+ ~")" ^{|a,b| a.to_i + b.to_i }
      """
    When I parse "(23+17)"
    Then the parse result should be ["23", "17", 40]

  Scenario: Sequence with labeled expressions
    Given a grammar with:
      """
      expr <- "(" l:@DIGIT+ "+" r:@DIGIT+ ")" ^{ l.to_i + r.to_i }
      """
    When I parse "(17+29)"
    Then the parse result should be ["(", "17", "+", "29", ")", 46]
  
  Scenario: Single-capture sequence using "_"
    Given a grammar with:
      """
      expr <- @DIGIT+ ^{ _.to_i }
      """
    When I parse "23"
    Then the parse result should be ["23", 23]
  
  Scenario: Multi-capture sequence using "_"
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ ^{ _.reverse }
      """
    When I parse "3 16"
    Then the parse result should be ["3", "16", ["16", "3"]]
  
  Scenario: Multi-capture sequence using "_" as a parameter name
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ ^{|_| _.to_i }
      """
    When I parse "3 16"
    Then the parse result should be ["3", "16", 3]
