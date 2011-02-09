Feature: Regular Expressions
  In order to define token patterns using Ruby Regexps
  As a language designer
  I want to match using regular expressions in my grammar

  Scenario Outline: Parsing
    Given a grammar with:
    """
    start <- /\d+/
    """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "3"   | "3"    |
    | "42a" | "42"   |
    | "foo" | FAIL   |