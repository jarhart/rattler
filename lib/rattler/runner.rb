require 'rattler'

require 'optparse'
require 'pathname'

module Rattler
  # +Runner+ defines the command-line parser generator.
  class Runner

    # Invalid command line arguments
    ERRNO_USAGE = 1

    # Error reading grammar file
    ERRNO_READ_ERROR = 2

    # Error writing parser file
    ERRNO_WRITE_ERROR = 3

    # Error parsing grammar
    ERRNO_PARSE_ERROR = 4

    # Error generaing ruby code
    ERRNO_GEN_ERROR = 5

    # Run the command-line parser
    #
    # @param (see #initialize)
    def self.run(args)
      self.new(args).run
    end

    # Create a new command-line parser.
    #
    # @param [Array<String>] args the command-line arguments
    def initialize(args)
      @optimize = true
      options.parse!(args)
      if args.size == 1
        @srcfname = Pathname.new(args.shift)
      else
        puts options
        exit ERRNO_USAGE
      end
    end

    # Run the command-line parser.
    def run
      if result = analyze
        synthesize(result)
      else
        puts parser.failure
        exit ERRNO_PARSE_ERROR
      end
    end

    private

    def options
      @options ||= OptionParser.new do |opts|

        opts.banner = "Usage: #{File.basename($0)} FILENAME [options]"

        opts.separator ''

        opts.on '-l', '--lib DIRECTORY',
                'Specify the destination lib directory' do |libdir|
          @libdir = Pathname.new(libdir)
        end

        opts.on '-d', '--dest DIRECTORY',
                'Specify an explicit destination directory' do |destdir|
          @destdir = Pathname.new(destdir)
        end

        opts.on '-o', '--output FILENAME',
                'Specify a different output filename ("-" = STDOUT)' do |ofname|
          @ofname = ofname
        end

        opts.on '-f', '--force',
                'Force overwrite if the output file exists' do |f|
          @force = f
        end

        opts.on '-n', '--no-optimize',
                'Disable optimization' do |n|
          @optimize = n
        end

        opts.separator ''

        opts.on_tail '-h', '--help', 'Show this message' do
          abort "#{opts}\n"
        end
      end
    end

    def parser
      @parser ||= Rattler::Compiler::GrammarParser.new(@srcfname.read)
    end

    def analyze
      parser.parse
    rescue Exception => e
      puts e
      exit ERRNO_READ_ERROR
    end

    def synthesize(g)
      open_output(g) do |io|
        begin
          io.puts code_for(g)
        rescue Exception => e
          puts e
          exit ERRNO_GEN_ERROR
        end
      end
    rescue Exception => e
      puts e
      exit ERRNO_WRITE_ERROR
    end

    def code_for(g)
      Rattler::Compiler::ParserGenerator.code_for g, generator_options
    end

    def generator_options
      { :no_optimize => !@optimize }
    end

    def open_output(g)
      if @ofname == '-'
        yield $stdout
      else
        open_to_write(full_dest_name(g)) {|io| yield io }
      end
    end

    def report(dest)
      puts "#{relative_path @srcfname} -> #{relative_path dest}"
    end

    def open_to_write(dest)
      if dest.exist? and not @force
        raise "File exists - #{relative_path dest} (use --force to overwrite)"
      end
      dest.dirname.mkpath
      report(dest)
      dest.open('w') { |f| yield f }
    end

    def full_dest_name(g)
      names = g.name.split('::').map {|_| underscore _ }
      ofname = @ofname || (names[-1] + '.rb')
      if @destdir
        @destdir.join(ofname)
      else
        names[-1] = ofname
        libdir.join(*names)
      end
    end

    def libdir
      @libdir ||= Pathname.getwd
    end

    def relative_path(p)
      p.dirname.realpath.relative_path_from(Pathname.getwd) + p.basename
    end

    # copied shamelessly from ActiveSupport
    def underscore(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

  end
end
