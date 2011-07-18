Feature: Positive Semantic Predicates

  A positive semantic predicate can be defined by placing a "&" in front of a
  semantic action. If the action results in a true value the parse succeeds,
  otherwise the parse fails.

  Scenario Outline: Single token
    Given a grammar with:
      """
      expr <- @DIGIT+ &{|s| s.to_i > 20 }
      """
    When I parse <input>
    Then the parse result should be <result>
  
  Examples:
    | input | result |
    | "42"  | "42"   |
    | "17"  | FAIL   |

  Scenario Outline: Sequence
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ &{|a,b| a.to_i < b.to_i }
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input  | result      |
    | "3 16" | ["3", "16"] |
    | "16 3" | FAIL        |

  Scenario Outline: Sequence with non-capturing expressions
    Given a grammar with:
      """
      expr <- ~"(" @DIGIT+ ~">" @DIGIT+ ~")" &{|a,b| a.to_i > b.to_i }
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
      expr <- "(" left:@DIGIT+ "<" right:@DIGIT+ ")" &{ left.to_i < right.to_i }
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input     | result       |
    | "(17<23)" | ["(", "17", "<", "23", ")"] |
    | "(23<17)" | FAIL         |

  Scenario Outline: Single token using "_"
    Given a grammar with:
      """
      expr <- @DIGIT+ &{ _.to_i > 20 }
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input | result |
    | "42"  | "42"   |
    | "17"  | FAIL   |
  
  Scenario Outline: Sequence using "_"
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ &{ _[0].to_i < _[1].to_i }
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input  | result      |
    | "3 16" | ["3", "16"] |
    | "16 3" | FAIL        |

  Scenario Outline: Sequence using "_" as a parameter name
    Given a grammar with:
      """
      %whitespace SPACE*
      expr <- @DIGIT+ @DIGIT+ &{|_| _.to_i < 20 }
      """
    When I parse <input>
    Then the parse result should be <result>

  Examples:
    | input  | result      |
    | "3 16" | ["3", "16"] |
    | "42 7" | FAIL        |
