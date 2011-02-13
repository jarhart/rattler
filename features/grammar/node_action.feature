Feature: Node Actions
  
  A node action is written as a node type between "<" and ">" following an
  expression. A node type is an object (typically a class) that responds to
  the #parsed method. It means to pass the parse results to #parsed and use
  the value returned as the parse result. The parse results are passed as an
  Array and any attributes are included in a Hash.
  
  In order to create node objects as parse results
  As a language designer
  I want to use node actions in my grammar
  
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