Feature: include

  Any "include" statements in the grammar heading get placed at the top of the
  class or module definition in the generated code.

  Scenario:
    Given a grammar with:
      """
      grammar MyGrammar

      include MyHelper
      """
    When I generate parser code
    Then the code should contain:
      """
      module MyGrammar #:nodoc:
        
        include MyHelper
      """
