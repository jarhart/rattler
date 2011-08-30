Feature: Semantic side-effects

  Semantic side effects can be used to set or change some state during a parse
  using a Ruby expression without directly affecting the parse.  The expression
  is evaluated for effect and its result is discarded.

  A semantic side-effect is written as a "~" followed by curly braces
  surrounding a Ruby expression.

  Scenario: Lone action
    Given a grammar with:
      """
      expr <- ~{ $x = 42 }
      """
    When I parse "anything"
    Then the parse result should be true
      And $x should be 42
      And the parse position should be 0
  
  Scenario: False result
    Given a grammar with:
      """
      expr <- ~{ false }
      """
    When I parse "anything"
    Then the parse result should be true
      And the parse position should be 0

  Scenario: Single-capture sequence
    Given a grammar with:
      """
      expr <- @DIGIT+ ~{|a| $x = a.to_i }
      """
    When I parse "23"
    Then the parse result should be "23"
      And $x should be 23
  
  Scenario: Multi-capture sequence
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ ~{|a,b| $x = a.to_i * b.to_i }
      """
    When I parse "3 16"
    Then the parse result should be ["3", "16"]
      And $x should be 48

  Scenario: Sequence with non-capturing expressions
    Given a grammar with:
      """
      expr <- ~"(" @DIGIT+ ~"+" @DIGIT+ ~")" ~{|a,b| $x = a.to_i + b.to_i }
      """
    When I parse "(23+17)"
    Then the parse result should be ["23", "17"]
      And $x should be 40

  Scenario: Sequence with labeled expressions
    Given a grammar with:
      """
      expr <- "(" l:@DIGIT+ "+" r:@DIGIT+ ")" ~{ $x = l.to_i + r.to_i }
      """
    When I parse "(17+29)"
    Then the parse result should be ["(", "17", "+", "29", ")"]
      And $x should be 46
  
  Scenario: Single-capture sequence using "_"
    Given a grammar with:
      """
      expr <- @DIGIT+ ~{ $x = _.to_i }
      """
    When I parse "23"
    Then the parse result should be "23"
      And $x should be 23
  
  Scenario: Multi-capture sequence using "_"
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ ~{ $x = _.reverse }
      """
    When I parse "3 16"
    Then the parse result should be ["3", "16"]
      And $x should be ["16", "3"]
  
  Scenario: Multi-capture sequence using "_" as a parameter name
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ ~{|_| $x = _.to_i }
      """
    When I parse "3 16"
    Then the parse result should be ["3", "16"]
      And $x should be 3
