Feature: Custom Error Messages

  A fail expression always fails with a specified message.

  The keyword "expected" can be used as a shortcut for error messages like
  "number expected."

  Scenario: Custom Error Message
    Given a grammar with:
      """
      expr  <-  "a"
              / "b"
              / fail "'a' or 'b' expected"
      """
    When I parse ""
    Then the parse should fail
      And the failure message should be "'a' or 'b' expected"

  Scenario: "expected" keyword
    Given a grammar with:
      """
      expr  <-  "a"
              / "b"
              / expected "'a' or 'b'"
      """
    When I parse ""
    Then the parse should fail
      And the failure message should be "'a' or 'b' expected"
