Feature: POSIX Character Classes
  
  The uppercase names of POSIX character classes can be used as a shortcut to
  using them in character class expressions, e.g. "DIGIT" and "[[:digit:]]" are
  equivalent.  In addition, "WORD" is a shortcut for "[[:alnum:]_]", equivalent
  to "[[:word:]]" in Ruby 1.9.
  
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
    When I parse " \t\nabc"
    Then the parse result should be [" ", "\t"]
  
  Scenario: CNTRL
    Given a grammar with:
      """
      expr <- CNTRL+
      """
    When I parse "\t\r\n abc"
    Then the parse result should be ["\t", "\r", "\n"]
  
  Scenario: DIGIT
    Given a grammar with:
      """
      expr <- DIGIT+
      """
    When I parse "123abc"
    Then the parse result should be ["1", "2", "3"]
  
  Scenario: GRAPH
    Given a grammar with:
      """
      expr <- GRAPH+
      """
    When I parse "a1;  "
    Then the parse result should be ["a", "1", ";"]
  
  Scenario: LOWER
    Given a grammar with:
      """
      expr <- LOWER+
      """
    When I parse "abcDEF"
    Then the parse result should be ["a", "b", "c"]
  
  Scenario: PRINT
    Given a grammar with:
      """
      expr <- PRINT+
      """
    When I parse " abc\tdef"
    Then the parse result should be [" ", "a", "b", "c"]
  
  Scenario: PUNCT
    Given a grammar with:
      """
      expr <- PUNCT+
      """
    When I parse ",.!;abc"
    Then the parse result should be [",", ".", "!", ";"]
  
  Scenario: SPACE
    Given a grammar with:
      """
      expr <- SPACE+
      """
    When I parse " \t\r\nabc"
    Then the parse result should be [" ", "\t", "\r", "\n"]
  
  Scenario: UPPER
    Given a grammar with:
      """
      expr <- UPPER+
      """
    When I parse "ABCdef"
    Then the parse result should be ["A", "B", "C"]
  
  Scenario: XDIGIT
    Given a grammar with:
      """
      expr <- XDIGIT+
      """
    When I parse "1aFg"
    Then the parse result should be ["1", "a", "F"]
  
  Scenario: WORD
    Given a grammar with:
      """
      expr <- WORD+
      """
    When I parse "Ab_1-d"
    Then the parse result should be ["A", "b", "_", "1"]
