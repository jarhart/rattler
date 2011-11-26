Feature: Custom Error Messages

  A fail expression always fails with a specified message.

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
