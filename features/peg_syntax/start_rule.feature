Feature: Start Rule
  
  The first rule defined in a grammar is the start rule.
  
  Scenario Outline: Default Start Rule
    Given a grammar with:
      """
      integer <-  @DIGIT+
      word    <-  @ALNUM+
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "42a" | "42"   |
    | "foo" | FAIL   |
