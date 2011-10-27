Feature: require

  Any "require" statements in the grammar heading get placed at the top of the
  generated code. If "require_relative" is use it gets converted into an
  equivalent "require" statement compatible with Ruby 1.8.7.

  Scenario: require
    Given a grammar with:
      """
      require "logger"
      """
    When I generate parser code
    Then the code should contain:
      """
      require "logger"
      """

  Scenario: require_relative
    Given a grammar with:
      """
      require_relative "my_helper"
      """
    When I generate parser code
    Then the code should contain:
      """
      require File.expand_path("my_helper", File.dirname(__FILE__))
      """
