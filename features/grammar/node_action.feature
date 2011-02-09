Feature: Node Actions
  In order to create node objects as parse results
  As a language designer
  I want to use node actions in my grammar
  
  Scenario: Explicit node class
    Given a grammar with:
      """
      start <- /\d+/ <IntegerNode>
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
    start <- /\d+/ <>
    """
    When I parse "42"
    Then the parse result should be Rattler::Runtime::ParseNode["42"]