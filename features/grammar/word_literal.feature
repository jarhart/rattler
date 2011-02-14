Feature: Word Literal Expressions
  
  A word literal is like a string literal but delimited with backquotes (`) and
  it means to match the literal only if it is not followed by a word character.
  It is useful for matching whole words only. What is considered a word
  character can be defined using the %word_character directive. By default a
  word charactacter is an alphanumeric character or the underscore character.
  
  In order to define keywords
  As a language designer
  I want to use word literals in my grammar
  
  Scenario Outline: Default word character definition
    Given a grammar with:
      """
      for <- `for`
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input      | result |
    | "for "     | "for"  |
    | "form"     | FAIL   |
    | "for-each" | "for"  |
    | "for_each" | FAIL   |
  
  Scenario Outline: Custom word character definition to include "-"
    Given a grammar with:
      """
      %word_character [[:alnum:]\-]
      for <- `for`
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input      | result |
    | "for "     | "for"  |
    | "for-each" | FAIL   |