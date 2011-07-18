Feature: Semantic side-effects

  A semantic side-effect can be defined by placing a "~" in front of a symantic
  action. The expression is evaulated for effect and always succeeds with no
  parse result.

  Scenario: Single token
    Given a grammar with:
      """
      expr <- @DIGIT+ ~{|s| $x = s.to_i }
      """
    When I parse "42 "
    Then the parse result should be "42"
      And $x should be 42

  Scenario: Sequence
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
  
  Scenario: Single token using "_"
    Given a grammar with:
      """
      expr <- @DIGIT+ ~{ $x = _.to_i }
      """
    When I parse "23"
    Then the parse result should be "23"
      And $x should be 23
  
  Scenario: Sequence using "_"
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ ~{ $x = _.reverse }
      """
    When I parse "3 16"
    Then the parse result should be ["3", "16"]
      And $x should be ["16", "3"]
  
  Scenario: Sequence using "_" as a parameter name
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ ~{|_| $x = _.to_i }
      """
    When I parse "3 16"
    Then the parse result should be ["3", "16"]
      And $x should be 3

  Scenario: Lone action
    Given a grammar with:
      """
      expr <- ~{ $x = 42 }
      """
    When I parse "anything"
    Then the parse result should be true
      And $x should be 42
      And the parse position should be 0
