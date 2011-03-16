Feature: --output option

  Use the --output (or -o) option to specify a different output file name, or
  "-" for STDOUT.

  @command-line
  Scenario: Specify a different file name
    Given a file named "binary.rtlr" with:
      """
      grammar BinaryGrammar
      expr <- [01]*
      """
      And a directory named "lib"
    When I run "rtlr --output my_grammar.rb binary.rtlr"
    Then the output should contain "binary.rtlr -> my_grammar.rb"
      And the file "my_grammar.rb" should contain:
        """
        module BinaryGrammar
        """

  @command-line
  Scenario: Use "-" to write to STDOUT
    Given a file named "binary.rtlr" with:
      """
      grammar BinaryGrammar
      expr <- [01]*
      """
      And a directory named "lib"
    When I run "rtlr --output - binary.rtlr"
    Then the output should contain:
      """
      module BinaryGrammar
      """
