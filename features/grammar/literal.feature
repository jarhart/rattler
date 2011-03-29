Feature: Literal Expressions
  
  A string literal has the same syntax as a Ruby string literal and it means to
  match if that exact text is next in the input.
  
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
