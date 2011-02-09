require 'rubygems'
require 'rattler'

class Calculator < Rattler::Runtime::WDMParser
  grammar %{
    %whitespace space*
    
    start   <-  expr EOF
    
    expr    <-  expr ~'+' term                  {|a,b| a + b }
              | expr ~'-' term                  {|a,b| a - b }
              | term
    
    term    <-  term ~'*' primary               {|a,b| a * b }
              | term ~'/' primary               {|a,b| a / b }
              | primary
    
    primary <-  ~'(' expr ~')'
              | @('-'? digit+ ('.' digit+)?)    <.to_f>
  }
end

loop do
  begin
    puts
    print "> "
    puts Calculator.parse!(gets)
  rescue Rattler::Runtime::SyntaxError => e
    puts e
  end
end