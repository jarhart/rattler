Feature: Grammar Declaration

  The grammar declaration names the grammar and tells rattler whether to
  generate a grammar module or a parser class. In the case of the parser class,
  the declaration also specifies the base class.

  The declaration for a grammar module is "grammar" followed by a module name.

  The declaration for a parser class is "parser", then a class name, then "<",
  then the base class.
  
  Scenario: Grammar module
    Given a grammar with:
      """
      grammar MyGrammar
      """
    When I generate parser code
    Then the code should contain:
      """
      # @private
      module MyGrammar
      """

  Scenario: Parser class
    Given a grammar with:
      """
      parser MyParser < Rattler::Runtime::PackratParser
      """
    When I generate parser code
    Then the code should contain:
      """
      # @private
      class MyParser < Rattler::Runtime::PackratParser
      """

  Scenario: Grammar module in a module
    Given a grammar with:
      """
      grammar MyModule::MyGrammar
      """
    When I generate parser code
    Then the code should contain:
      """
      module MyModule
        # @private
        module MyGrammar
      """

  Scenario: Parser class in a module
    Given a grammar with:
      """
      parser MyModule::MyParser < Rattler::Runtime::PackratParser
      """
    When I generate parser code
    Then the code should contain:
      """
      module MyModule
        # @private
        class MyParser < Rattler::Runtime::PackratParser
      """
