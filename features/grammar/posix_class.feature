Feature: POSIX Character Classes
  
  The names of POSIX character classes can be used as a shortcut to using them
  in character class expressions, e.g. "digit" is equivalent to "[[:digit:]]".
  
  In order to write more consistent and readable grammars
  As a language designer
  I want to use POSIX character classes in my grammar
  
  Scenario: ALNUM
    Given a grammar with:
    """
    start <- ALNUM+
    """
    When I parse "abc123"
    Then the parse result should be ["a", "b", "c", "1", "2", "3"]
  
  Scenario: ALPHA
    Given a grammar with:
    """
    start <- ALPHA+
    """
    When I parse "abc123"
    Then the parse result should be ["a", "b", "c"]
  
  Scenario: BLANK
    Given a grammar with:
    """
    start <- BLANK+
    """
    When I parse "   abc"
    Then the parse result should be [" ", " ", " "]
  
  Scenario: DIGIT
    Given a grammar with:
    """
    start <- DIGIT+
    """
    When I parse "123abc"
    Then the parse result should be ["1", "2", "3"]
  
  Scenario: LOWER
    Given a grammar with:
    """
    start <- LOWER+
    """
    When I parse "abcDEF"
    Then the parse result should be ["a", "b", "c"]
  