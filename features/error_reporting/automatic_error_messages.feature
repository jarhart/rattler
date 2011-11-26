Feature: Automatic Error Messages

  Rattler parsers automatically generate parse error messages for failed rules
  using the name of the failed rule.

  Rattler usually uses the name of the latest and deepest failed rule to ensure
  the message is as specific as possible. The exception is when a rule is an
  ordered choice. In that case using the name of the ordered choice rule makes
  more sense.

  Scenario: Automatic Error Message
    Given a grammar with:
      """
      expr <- DIGIT
      """
    When I parse "a"
    Then the parse should fail
      And the failure message should be "expr expected"

  Scenario: Deepest Rule Name
    Given a grammar with:
      """
      expr    <-  digits
      digits  <-  DIGIT+
      """
    When I parse "a"
    Then the parse should fail
      And the failure message should be "digits expected"

  Scenario: Ordered Choice
    Given a grammar with:
      """
      alnums  <-  alphas
                / digits
      alphas  <-  ALPHA+
      digits  <-  DIGIT+
      """
    When I parse "@"
    Then the parse should fail
      And the failure message should be "alnums expected"
