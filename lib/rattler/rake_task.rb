require 'rattler/runner'
require 'rake'
require 'rake/tasklib'

module Rattler

  def self.file(files, &block)
    RakeFileTask.new(files, &block)
  end

  # The rake file task to generate parser code from a grammar
  class RakeFileTask < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)

    attr_accessor :force
    attr_accessor :optimize
    attr_accessor :verbose

    def initialize(files)
      @before = nil
      @force = true
      @optimize = true
      @verbose = true

      yield self if block_given?

      files.each { |dst, src| define_task dst, src }
    end

    def before(&block)
      @before = block
    end

    private

    def define_task(dst, src)
      file dst => src do
        RakeFileUtils.send(:verbose, verbose) do
          @before.call if @before
          args = run_args(dst, src)
          puts 'rtlr ' + args.join(' ') if verbose
          ::Rattler::Runner.run args, :verbose => verbose
        end
      end
    end

    def run_args(dst, src)
      [src, '-d', File.dirname(dst), '-o', File.basename(dst)].tap do |args|
        args << '-f' if @force
        args << '-n' unless @optimize
      end
    end
  end
end
