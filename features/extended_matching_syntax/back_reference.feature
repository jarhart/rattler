Feature: Back References

  A back reference refers to a previous labelled parsing expression and matches
  the exact string matched by the referenced expression.

  A back reference is written as a "$" followed by a label defined earlier in a
  sequence.

  Scenario Outline: Parsing
    Given a grammar with:
      """
      expr <- a:ALPHA DIGIT+ $a
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input  | result                 |
    | "a12a" | ["a", ["1", "2"], "a"] |
    | "b12b" | ["b", ["1", "2"], "b"] |
    | "a12b" | FAIL                   |

  Scenario Outline: Token
    Given a grammar with:
      """
      string <- @('%' q:PUNCT (! $q .)* $q)
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input      | result   |
    | "%/a b/ c" | "%/a b/" |
    | "%!a b! c" | "%!a b!" |
    | "%/a b! c" | FAIL     |
