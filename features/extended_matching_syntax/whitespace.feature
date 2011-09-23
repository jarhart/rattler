Feature: Whitespace Skipping
  
  The "%whitespace" directive allows whitespace to defined in one place and
  skipped automatically by all atomic expressions.

  "%whitespace" is followed by a parsing expression that defines how to match
  whitespace. The directive can be optionally followed by a block delimited
  by curly braces to limit whitespace skipping to rules inside the block.
  
  Scenario: Block form
    Given a grammar with:
      """
      %whitespace SPACE* {
        word <- @WORD+
      }
      """
    When I parse "  foo"
    Then the parse result should be "foo"
  
  Scenario: Global form
    Given a grammar with:
      """
      %whitespace SPACE*
      word <- @WORD+
      """
    When I parse "  foo"
    Then the parse result should be "foo"
    