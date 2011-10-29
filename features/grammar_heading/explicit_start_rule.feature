Feature: Explicit Start Rule

  The "%start" directive allows the specification of an explicit start rule.
  By default the first rule defined in a grammar is the start rule.

  Scenario Outline: Explicit Start Rule
    Given a grammar with:
      """
      %start  word
      
      integer <-  @DIGIT+
      word    <-  @ALPHA+
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "42"  | FAIL   |
    | "foo" | "foo"  |
