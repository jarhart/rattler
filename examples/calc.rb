#! /usr/bin/env ruby

require 'rubygems'
require 'rattler'

class Calculator < Rattler::Runtime::ExtendedPackratParser
  grammar %{
    %whitespace SPACE*

    start   <-  (expr / quit) EOF

    expr    <-  expr ~'+' term                  {|a,b| a + b }
              / expr ~'-' term                  {|a,b| a - b }
              / term

    term    <-  term ~'*' primary               {|a,b| a * b }
              / term ~'/' primary               {|a,b| a / b }
              / primary

    primary <-  ~'(' expr ~')'
              / @('-'? DIGIT+ ('.' DIGIT+)?)    { _.to_f }

    quit    <-  'quit'                          { abort "\\n" }
  }
end

loop do
  begin
    puts
    print "> "
    break unless (s = gets)
    puts Calculator.parse!(s)
  rescue Rattler::Runtime::SyntaxError => e
    puts e
  end
end
puts
