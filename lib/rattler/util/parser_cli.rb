require 'rattler/util'
require 'optparse'

module Rattler::Util
  class ParserCLI

    @@graph_formats = %w{jpg png svg pdf ps ps2 eps}

    def self.run(parser_class)
      self.new(parser_class).run
    end

    def initialize(parser_class)
      @parser_class = parser_class

      OptionParser.new do |opts|

        opts.banner = "Usage: #{File.basename($0)} [filenames] [options]"

        opts.separator ''

        opts.on '-g', '--graphviz',
                'Display the parse tree using GraphViz dotty' do |g|
          @graphviz = {:dot => '|dotty'}
        end

        @@graph_formats.each do |format|
          a = 'aefhilmnorsx'.include?(format[0]) ? 'an' : 'a'
          desc = "#{format.upcase} file"
          opts.on "--#{format} FILENAME",
                  "Output the parse tree as #{a} #{desc} using GraphViz" do |f|
            @graphviz = {format => f}
          end
        end

        opts.on '-f', '--file FILENAME',
                'Output the parse tree as a GraphViz DOT language file' do |file|
          @graphviz = {:dot => file}
        end

        opts.on '-d', '--dot',
                'Output the parse tree in the GraphViz DOT language' do |d|
          @graphviz = {:dot => nil}
        end

        opts.separator ''

        opts.on_tail '-h', '--help', 'Show this message' do
          abort "#{opts}\n"
        end
      end.parse!(ARGV)
    end

    def run
      show_result @parser_class.parse!(ARGF.read)
    rescue Rattler::Runtime::SyntaxError => e
      puts e
    end

    private

    def show_result(result)
      if @graphviz
        GraphViz.digraph(result).output(@graphviz)
      else
        require 'pp'
        pp result
      end
    end

  end
end
