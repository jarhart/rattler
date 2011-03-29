Feature: List Matching

  A term expression followed by "*," or "+," and a separator expression means
  to match a list of terms with separators between them. "*," matches a list of
  zero or more terms, "+," matches a list of one or more term.

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

  Scenario: Using whitespace
    Given a grammar with:
      """
      %whitespace SPACE*
      words <-  @WORD+ *, ','
      """
    When I parse "foo, bar ,baz"
    Then the parse result should be ["foo", "bar", "baz"]
