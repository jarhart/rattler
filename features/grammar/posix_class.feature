Feature: POSIX Character Classes
  In order to write more consistent and readable grammars
  As a language designer
  I want to use POSIX character classes in my grammar
  
  Scenario: ALNUM
    Given a grammar with:
    """
    start <- alnum+
    """
    When I parse "abc123"
    Then the parse result should be ["a", "b", "c", "1", "2", "3"]
  
  Scenario: ALPHA
    Given a grammar with:
    """
    start <- alpha+
    """
    When I parse "abc123"
    Then the parse result should be ["a", "b", "c"]
  
  Scenario: BLANK
    Given a grammar with:
    """
    start <- blank+
    """
    When I parse "   abc"
    Then the parse result should be [" ", " ", " "]
  
  Scenario: DIGIT
    Given a grammar with:
    """
    start <- digit+
    """
    When I parse "123abc"
    Then the parse result should be ["1", "2", "3"]
  
  Scenario: LOWER
    Given a grammar with:
    """
    start <- lower+
    """
    When I parse "abcDEF"
    Then the parse result should be ["a", "b", "c"]
  