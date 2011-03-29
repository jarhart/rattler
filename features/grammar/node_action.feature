Feature: Node Actions
  
  A node action is written as a node type between "<" and ">" following an
  expression. A node type is an object (typically a class) that responds to
  the #parsed method. It means to pass the parse results to #parsed and use
  the value returned as the parse result. The parse results are passed as an
  Array and any attributes are included in a Hash. The action can optionally
  include a name.
  
  Scenario: Explicit node class
    Given a grammar with:
      """
      integer <- @DIGIT+ <IntegerNode>
      """
      And a class definition:
        """
        class IntegerNode < Rattler::Runtime::ParseNode; end
        """
    When I parse "42"
    Then the parse result should be IntegerNode["42"]
  
  Scenario: Default node class
    Given a grammar with:
      """
      integer <- @DIGIT+ <>
      """
    When I parse "42"
    Then the parse result should be Rattler::Runtime::ParseNode["42"]
  
  Scenario: Class and node name
    Given a grammar with:
      """
      expr <- @DIGIT+ ~'+' @DIGIT+ <Expr "sum">
      """
      And a class definition:
        """
        class Expr < Rattler::Runtime::ParseNode; end
        """
    When I parse "42+23"
    Then the parse result should be Expr[["42", "23"], {:name => "sum"}] 
