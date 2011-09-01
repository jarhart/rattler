Feature: String Literals

  A string literal matches exact text.  The expression matches if the exact
  text is next in the input.
  
  A string literal is written exactly like a Ruby string literal.
  
  Scenario Outline: Normal String
    Given a grammar with:
      """
      a <- "while"
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input    | result  |
    | "while"  | "while" |
    | " while" | FAIL    |
    | "whip"   | FAIL    |
  
  Scenario Outline: General delimited String with brackets
    Given a grammar with:
      """
      a <- %{while}
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input    | result  |
    | "while"  | "while" |
    | "whip"   | FAIL    |
  
  Scenario Outline: General delimited String with arbitrary delimiters
    Given a grammar with:
      """
      a <- %!while!
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input    | result  |
    | "while"  | "while" |
    | "whip"   | FAIL    |
