Feature: Whitespace Skipping
  
  The "%whitespace" directive allows whitespace to defined in one place and
  skipped automatically by all atomic expressions.

  "%whitespace" is followed by a parsing expression that defines how to match
  whitespace. The directive can be optionally followed by a block delimited
  by curly braces to limit whitespace skipping to rules inside the block.

  Note: If the "%whitespace" directive refers to a rule, and that rule
  is itself subject to the whitespace skipping" directive, the grammar
  may act in a confounding manner.  To avoid that, exclude any such
  rules from whitespace skipping by, e.g., defining them before the
  "%whitespace" directive.

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
    