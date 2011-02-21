Feature: Whitespace
  
  Comments start with "#" and continue to the end of the line.
  
  In order to clarify my grammars
  As a language designer
  I want to use comments
  
  Scenario: Entire line as a comment
    Given a grammar with:
      """
      # match one or more alphanumeric or underscore characters
      word <- @WORD+
      """
    When I parse "foo"
    Then the parse result should be "foo"
  
  Scenario: Comment at the end of a line
    Given a grammar with:
      """
      word <- @WORD+  # WORD matches any alphanumeric or underscore character
      """
    When I parse "foo"
    Then the parse result should be "foo"
