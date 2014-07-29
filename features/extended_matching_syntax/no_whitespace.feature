Feature: Cancel Whitespace Skipping
  
  The "%no-whitespace" directive cancels a "%whitespace" directive.
  As with the "%whitespace" directive, "%no-whitespace" can be
  optionally followed by a block delimited by curly braces to limit
  whitespace cancellation to rules inside the block.
  
  Scenario: Block form
    Given a grammar with:
      """
      %whitespace SPACE*
      %no-whitespace {
        word <- @WORD+
      }
      """
    When I parse "  foo"
    Then the parse result should be FAIL
    When I parse "foo"
    Then the parse result should be "foo"
  
  Scenario: Global form
    Given a grammar with:
      """
      %whitespace SPACE*
      %no-whitespace
      word <- @WORD+
      """
    When I parse "  foo"
    Then the parse result should be FAIL
    When I parse "foo"
    Then the parse result should be "foo"
