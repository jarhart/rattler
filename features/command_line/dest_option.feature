Feature: --dest option

  Use the --dest (or -d) option to specify an explicit destination directory.
  By default Rattler uses the module path of the grammar to build a destination
  directory by converting camel-case to underscore.

  Scenario: Overriding the destination directory
    Given a file named "binary.rtlr" with:
      """
      grammar Examples::BinaryGrammar
      expr <- [01]*
      """
      And a directory named "lib/my_examples"
    When I run "rtlr --dest lib/my_examples binary.rtlr"
    Then the output should contain "binary.rtlr -> lib/my_examples/binary_grammar.rb"
      And the file "lib/my_examples/binary_grammar.rb" should contain:
        """
        module Examples
          # @private
          module BinaryGrammar
        """
