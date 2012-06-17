require 'rattler/runner'
require 'rake'
require 'rake/tasklib'

module Rattler

  # The rake task to generate parser code from a grammar
  #
  class RakeTask < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)

    attr_accessor :name
    attr_accessor :grammar
    attr_accessor :rtlr_opts
    attr_accessor :verbose

    def initialize(name = :rattler)
      @name = name
      @grammar = nil
      @rtlr_opts = []
      @verbose = true

      yield self if block_given?

      define_task
    end

    private

    def define_task
      task name do
        RakeFileUtils.send(:verbose, verbose) do
          ::Rattler::Runner.run(run_args) if valid?
        end
      end
    end

    def run_args
      [grammar] + rtlr_opts
    end

    def valid?
      unless grammar
        puts "No grammar specified"
        return false
      end
      true
    end
  end
end
