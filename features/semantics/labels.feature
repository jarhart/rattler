Feature: Labels
  
  Labels can be attached to parse results by putting a name followed by ":"
  before an expression. Labels are meaningful in actions: they can be used as
  identifiers in normal symantic actions, and in node actions the mappings are
  passed as a :labeled attribute.
  
  Scenario: Normal symantic action
    Given a grammar with:
      """
      fraction <- numer:@DIGIT+ "/" denom:@DIGIT+ { numer.to_i / denom.to_i }
      """
    When I parse "6/2"
    Then the parse result should be 3
  
  Scenario: Node action
    Given a grammar with:
      """
      fraction <- numer:@DIGIT+ "/" denom:@DIGIT+ <Fraction>
      """
      And a class definition:
        """
        class Fraction < Rattler::Runtime::ParseNode; end
        """
    When I parse "6/2"
    Then the parse result should be Fraction[["6", "/", "2"], {:labeled => {:numer => "6", :denom => "2"}}]

  Scenario: Nested scope
    Given a grammar with:
      """
      a <- word:@ALPHA+ (@DIGIT+ {|num| "#{num} #{word}" })
      """
    When I parse "abc123"
    Then the parse result should be ["abc", "123 abc"]
