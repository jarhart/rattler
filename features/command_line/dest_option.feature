Feature: --dest option

  Use the --dest (or -d) option to specify a different (base) destination
  directory.

  Scenario: Grammar as top-level module
    Given a file named "binary.rtlr" with:
      """
      grammar BinaryGrammar
      expr <- [01]*
      """
      And a directory named "lib"
    When I run "rtlr --dest lib binary.rtlr"
    Then the output should contain "binary.rtlr -> lib/binary_grammar.rb"
      And the file "lib/binary_grammar.rb" should contain:
        """
        module BinaryGrammar
        """

  Scenario: Grammar as top-level module
    Given a file named "binary.rtlr" with:
      """
      grammar Examples::BinaryGrammar
      expr <- [01]*
      """
      And a directory named "lib/examples"
    When I run "rtlr --dest lib binary.rtlr"
    Then the output should contain "binary.rtlr -> lib/examples/binary_grammar.rb"
      And the file "lib/examples/binary_grammar.rb" should contain:
        """
        module Examples
          # @private
          module BinaryGrammar
        """
