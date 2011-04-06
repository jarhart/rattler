Feature: Generalized Repeat

  Repetition counts or ranges can be used for generalized repeat expressions.
  A count by itself means to match the preceding expression exactly that many
  times. A range can be written with ".." between the lower and upper bounds.
  The upper bound is optional.

  Scenario Outline: Range
    Given a grammar with:
      """
      expr <- ALPHA 2..4
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input   | result               | pos |
    | "abc"   | ["a", "b", "c"]      | 3   |
    | "abcde" | ["a", "b", "c", "d"] | 4   |
    | "a"     | FAIL                 | 0   |
  
  Scenario Outline: Lower bound only
    Given a grammar with:
      """
      expr <- ALPHA 2..
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input   | result                    | pos |
    | "abc"   | ["a", "b", "c"]           | 3   |
    | "abcde" | ["a", "b", "c", "d", "e"] | 5   |
    | "a"     | FAIL                      | 0   |

  Scenario Outline: Specific count
    Given a grammar with:
      """
      expr <- ALPHA 2
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input   | result     | pos |
    | "abc"   | ["a", "b"] | 2   |
    | "a"     | FAIL       | 0   |
