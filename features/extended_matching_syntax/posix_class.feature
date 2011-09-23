Feature: POSIX Character Classes
  
  The uppercase names of POSIX character classes can be used as a shortcut to
  using them in character class expressions, e.g. "DIGIT" and "[[:digit:]]" are
  equivalent.
  
  The POSIX character classes are:
    ALNUM - Alphanumeric characters
    ALPHA - Alphabetic characters
    ASCII - ASCII characters
    BLANK - Space and tab
    CNTRL - Control characters
    DIGIT - Digits
    GRAPH - Visible characters
    LOWER - Lowercase characters
    PRINT - Visible characters and spaces
    PUNCT - Punctuation characters
    SPACE - Whitespace characters
    UPPER - Uppercase characters
    XDIGIT - Hexadecimal digits
    WORD - Alphanumeric characters plus "_"
  
  Scenario: ALNUM
    Given a grammar with:
      """
      expr <- ALNUM+
      """
    When I parse "abc123"
    Then the parse result should be ["a", "b", "c", "1", "2", "3"]
  
  Scenario: ALPHA
    Given a grammar with:
      """
      expr <- ALPHA+
      """
    When I parse "abc123"
    Then the parse result should be ["a", "b", "c"]
  
  Scenario: BLANK
    Given a grammar with:
      """
      expr <- BLANK+
      """
    When I parse "   abc"
    Then the parse result should be [" ", " ", " "]
  
  Scenario: DIGIT
    Given a grammar with:
      """
      expr <- DIGIT+
      """
    When I parse "123abc"
    Then the parse result should be ["1", "2", "3"]
  
  Scenario: LOWER
    Given a grammar with:
      """
      expr <- LOWER+
      """
    When I parse "abcDEF"
    Then the parse result should be ["a", "b", "c"]
  
  Scenario: UPPER
    Given a grammar with:
      """
      expr <- UPPER+
      """
    When I parse "ABCdef"
    Then the parse result should be ["A", "B", "C"]
    