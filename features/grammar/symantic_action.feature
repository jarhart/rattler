Feature: Symantic Actions
  
  A symantic action can be added between "{" and "}" following an expression.
  It means to evaluate the action as a Ruby expression if the match succeeds
  and use the result of the action as the final parse result. Parameters can be
  specified like Ruby block parameters and are bound to the parse results from
  the match. If there are fewer parameters than parse results the extra results
  are simply ignored. Labeled parse results can be refered to as identifiers in
  the action. The special identifier "_" refers to the entire parse results.
  
  In order to add simple symantics to parse results
  As a language designer
  I want to use symantic actions in my grammar
  
  Scenario: Single token
    Given a grammar with:
      """
      integer <- @DIGIT+ {|s| s.to_i }
      """
    When I parse "42"
    Then the parse result should be 42
  
  Scenario: Sequence
    Given a grammar with:
      """
      %whitespace SPACE*
      product <- @DIGIT+ @DIGIT+ {|a,b| a.to_i * b.to_i }
      """
    When I parse "3 16"
    Then the parse result should be 48
  
  Scenario: Sequence with non-capturing expressions
    Given a grammar with:
      """
      sum <- ~"(" @DIGIT+ ~"+" @DIGIT+ ~")" {|a,b| a.to_i + b.to_i }
      """
    When I parse "(23+17)"
    Then the parse result should be 40
  
  Scenario: Sequence with labeled expressions
    Given a grammar with:
      """
      sum <- "(" left:@DIGIT+ "+" right:@DIGIT+ ")" { left.to_i + right.to_i }
      """
    When I parse "(17+29)"
    Then the parse result should be 46
  
  Scenario: Single token using "_"
    Given a grammar with:
      """
      integer <- @DIGIT+ { _.to_i }
      """
    When I parse "23"
    Then the parse result should be 23
  
  Scenario: Sequence using "_"
    Given a grammar with:
      """
      %whitespace SPACE*
      ints <- @DIGIT+ @DIGIT+ { _.reverse }
      """
    When I parse "3 16"
    Then the parse result should be ["16", "3"]
  
  Scenario: Sequence using "_" as a parameter name
    Given a grammar with:
      """
      %whitespace SPACE*
      ints <- @DIGIT+ @DIGIT+ {|_| _.to_i }
      """
    When I parse "3 16"
    Then the parse result should be 3
