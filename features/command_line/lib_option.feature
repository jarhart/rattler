Feature: --lib option

  Use the --lib (or -l) option to specify a different destination library
  directory. If not specified, the default is the current directory. Rattler
  uses the module path of the grammar to build a destination directory based
  on the library directory by converting camel-case to underscore. To specify
  an explicit destination directory use the --dest (or -d) option.

  @command-line
  Scenario: Grammar as top-level module
    Given a file named "binary.rtlr" with:
      """
      grammar BinaryGrammar
      expr <- [01]*
      """
      And a directory named "lib"
    When I run "rtlr --lib lib binary.rtlr"
    Then the output should contain "binary.rtlr -> lib/binary_grammar.rb"
      And the file "lib/binary_grammar.rb" should contain:
        """
        module BinaryGrammar
        """

  @command-line
  Scenario: Grammar as a nested module
    Given a file named "binary.rtlr" with:
      """
      grammar Examples::BinaryGrammar
      expr <- [01]*
      """
      And a directory named "lib/examples"
    When I run "rtlr --lib lib binary.rtlr"
    Then the output should contain "binary.rtlr -> lib/examples/binary_grammar.rb"
      And the file "lib/examples/binary_grammar.rb" should contain:
        """
        module Examples
          # @private
          module BinaryGrammar
        """
