Feature: Character sequence

  A character sequences matches text a character at a time, exactly as
  if each character had been specified separately in a sequence.  This
  allows whitespace to be skipped between the characters of a literal,
  provided that a %whitespace directive is in effect.

  A character sequence is written like `%c"..."` or %c'...'`.  The "c"
  stands for "characters."

  The character sequence:

      %c"THEN"

  is equivalent to

      ("T" "H" "E" "N")

  Most of the time, you probably want a string literal.  Character
  sequence exists for strange languages like BASIC and Fortran, which
  permit whitespace in keywords.
  
  Scenario Outline: Normal String
    Given a grammar with:
      """
      %whitespace SPACE*
      a <- %c"IF"
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input  |   result   |
    | "IF"   | ["I", "F"] |
    | " I F" | ["I", "F"] |
