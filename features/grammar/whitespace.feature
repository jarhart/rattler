Feature: Whitespace
  
  The "%whitespace" directive allows whitespace to defined in one place and
  skipped automatically by all atomic expressions. "%whitespace" is followed by
  a parsing expression and an optional block delimited by "{" and "}". The block
  form defines whitespace for expressions in the block, otherwise it is defined
  for the rest of the grammar.
  
  In order to focus on the structure of my language
  As a language designer
  I want to specify whitespace in my grammar once and only once
  
  Scenario: Block form
    Given a grammar with:
      """
      %whitespace SPACE* {
        word <- @WORD+
      }
      """
    When I parse "  foo"
    Then the parse result should be "foo"
  
  Scenario: Shorcut form
    Given a grammar with:
      """
      %whitespace SPACE*
      word <- @WORD+
      """
    When I parse "  foo"
    Then the parse result should be "foo"
    