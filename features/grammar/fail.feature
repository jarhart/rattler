Feature: Fail Expressions
  In order to define my own failure messages
  As a language designer
  I want to use fail expressions in my grammar
  
  Scenario: Fail-expression
    Given a grammar with:
    """
    start <- fail "something bad happened"
    """
    When I parse "anything"
      And the parse position is 2
    Then the parse should fail
      And the failure position should be 2
      And the failure message should be "something bad happened"
  
  Scenario: Fail-rule
    Given a grammar with:
    """
    start <-  fail_rule "something really bad happened"
            | .*
    """
    When I parse "anything"
    Then the parse should fail
      And the failure message should be "something really bad happened"
  
  Scenario: Fail-parse
    Given a grammar with:
    """
    start <- a | .*
    a     <- fail_parse "something catastrophic happened"
    """
    When I parse "anything"
    Then the parse should fail
      And the failure message should be "something catastrophic happened"
  
  Scenario: Fail-expression at the end of an ordered choice
    Given a grammar with:
    """
    start <- a | b | fail "something bad happened"
    a     <- "a"
    b     <- "b"
    """
    When I parse "foo"
    Then the parse should fail
      And the failure message should be "something bad happened"