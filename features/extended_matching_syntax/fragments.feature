Feature: Fragments
  
  The "%fragments" directive disables whitepsace skipping and marks parse rules
  to be inlined. This is useful for factoring complex token rules.

  Scenario: Matching a number
    Given a grammar with:
      """
      %whitespace SPACE+

      number  <-  @(int frac?)

      %fragments

      int     <-  '-'? DIGIT+

      frac    <-  '.' DIGIT+
      """
    When I generate parser code
    Then the code should contain:
      """
      def match_number! #:nodoc:
        begin
          @scanner.skip(/(?>(?>[[:space:]])+)((?>(?>(?>\-)?)(?>(?>[[:digit:]])+))(?>(?>(?>\.)(?>(?>[[:digit:]])+))?))/) &&
          @scanner[1]
        end ||
        fail { :number }
      end
      """
