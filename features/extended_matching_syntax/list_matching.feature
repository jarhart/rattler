Feature: List Matching

  A list matching expression defines a term expression and a separator and
  matches a list of terms.

  A list matching expression is written by following a parsing expression for
  the term with "*," or "+," followed by a parsing expression for the separator.
  Repetition counts or ranges can also be used for generalized list matching
  expressions.  With a count by itself the expression matches a exactly that
  many terms.  A range is written as a lower bound followed by "..", optionally
  followed by an upper bound.

  Scenario Outline: Zero or more terms
    Given a grammar with:
      """
      words <-  @WORD+ *, ','
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input         | result                | pos |
    | "foo"         | ["foo"]               | 3   |
    | "foo,bar,baz" | ["foo", "bar", "baz"] | 11  |
    | "foo,bar,"    | ["foo", "bar"]        | 7   |
    | "   "         | []                    | 0   |

  Scenario Outline: One or more terms
    Given a grammar with:
      """
      words <-  @WORD+ +, ','
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input         | result                | pos |
    | "foo"         | ["foo"]               | 3   |
    | "foo,bar,baz" | ["foo", "bar", "baz"] | 11  |
    | "foo,bar,"    | ["foo", "bar"]        | 7   |
    | "   "         | FAIL                  | 0   |

  Scenario Outline: Range
    Given a grammar with:
      """
      words <-  @WORD+ 2..4, ','
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input         | result                | pos |
    | "foo,bar"     | ["foo", "bar"]        | 7   |
    | "foo,bar,"    | ["foo", "bar"]        | 7   |
    | "a,b,c,d,e"   | ["a", "b", "c", "d"]  | 7   |
    | "foo"         | FAIL                  | 0   |

  Scenario Outline: Lower bound only
    Given a grammar with:
      """
      words <-  @WORD+ 2.., ','
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input         | result                | pos |
    | "foo,bar"     | ["foo", "bar"]        | 7   |
    | "foo,bar,"    | ["foo", "bar"]        | 7   |
    | "a,b,c,d,e"   | ["a","b","c","d","e"] | 9   |
    | "foo"         | FAIL                  | 0   |

  Scenario Outline: Specific count
    Given a grammar with:
      """
      words <-  @WORD+ 2, ','
      """
    When I parse <input>
    Then the parse result should be <result>
      And the parse position should be <pos>
  
  Examples:
    | input         | result          | pos |
    | "foo,bar"     | ["foo", "bar"]  | 7   |
    | "foo,bar,"    | ["foo", "bar"]  | 7   |
    | "a,b,c,d,e"   | ["a","b"]       | 3   |
    | "foo"         | FAIL            | 0   |

  Scenario: Using whitespace
    Given a grammar with:
      """
      %whitespace SPACE*
      words <-  @WORD+ *, ','
      """
    When I parse "foo, bar ,baz"
    Then the parse result should be ["foo", "bar", "baz"]
