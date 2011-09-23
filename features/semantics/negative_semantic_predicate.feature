Feature: Negative Semantic Predicates

  Semantic predicates can be used to cause a parsing expression to either
  continue or fail based on the result of a Ruby expression.  With a negative
  semantic predicate the expression is evaluated and if the result is truthy
  the parsing expression fails at that point, otherwise it continues.

  A negative semantic predicate is written as a "!" followed by curly braces
  surrounding a Ruby expression.

  Scenario: Truthy result
    Given a grammar with:
      """
      expr <- !{ 1 }
      """
    When I parse "anything"
    Then the parse should fail

  Scenario: False result
    Given a grammar with:
      """
      expr <- !{ false }
      """
    When I parse "anything"
    Then the parse result should be true
      And the parse position should be 0

  Scenario Outline: Single-capture sequence
    Given a grammar with:
      """
      expr <- @DIGIT+ !{|s| s.to_i > 20 }
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "17"  | "17"   |
    | "42"  | FAIL   |

  Scenario Outline: Multi-capture sequence
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ !{|a,b| a.to_i < b.to_i }
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input  | result      |
    | "16 3" | ["16", "3"] |
    | "3 16" | FAIL        |

  Scenario Outline: Sequence with non-capturing expressions
    Given a grammar with:
      """
      expr <- ~"(" @DIGIT+ ~">" @DIGIT+ ~")" !{|a,b| a.to_i <= b.to_i }
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input     | result       |
    | "(23>17)" | ["23", "17"] |
    | "(17>23)" | FAIL         |

  Scenario Outline: Sequence with labeled expressions
    Given a grammar with:
      """
      expr <- "(" left:@DIGIT+ "<" right:@DIGIT+ ")" !{ left.to_i >= right.to_i }
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input     | result       |
    | "(17<23)" | ["(", "17", "<", "23", ")"] |
    | "(23<17)" | FAIL         |

  Scenario Outline: Single-capture sequence using "_"
    Given a grammar with:
      """
      expr <- @DIGIT+ !{ _.to_i > 20 }
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input | result |
    | "17"  | "17"   |
    | "42"  | FAIL   |
  
  Scenario Outline: Multi-capture sequence using "_"
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ !{ _[0].to_i < _[1].to_i }
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input  | result      |
    | "16 3" | ["16", "3"] |
    | "3 16" | FAIL        |

  Scenario Outline: Multi-capture sequence using "_" as a parameter name
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ !{|_| _.to_i < 20 }
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input  | result      |
    | "42 7" | ["42", "7"] |
    | "3 16" | FAIL        |
