The following is an example of a complete JSON parser. It parses JSON syntax
into Ruby hashes, arrays, and values.

`json.rtlr`:

    # JSON parser based on the grammar at http://www.json.org

    require 'rattler'
    require_relative 'json_helper'

    parser JsonParser < Rattler::Runtime::PackratParser

    include JsonHelper

    %whitespace (SPACE+ / comment)* {

      json_text <-  (object / array) EOF

      object    <-  ~'{' members ~'}'                       { object _ }

      members   <-  pair *, ','

      pair      <-  string ~':' value

      array     <-  ~'[' elements ~']'                      { array _ }

      elements  <-  value *, ','

      value     <-  object
                  / array
                  / number
                  / string
                  / `true`                                  { :true }
                  / `false`                                 { :false }
                  / `null`                                  { :null }
                  / fail "value expected"

      string    <-  @('"' char* '"')                        { string _ }

      number    <-  @(int frac? exp?)                       { number _ }
    }

    %inline {

      char      <-  !('"' / '\\' / CNTRL) .
                  / '\\' (["\\/bfnrt] / 'u' XDIGIT XDIGIT XDIGIT XDIGIT)

      int       <-  '-'? ('0' !DIGIT / [1-9] DIGIT*)

      frac      <-  '.' DIGIT+

      exp       <-  [eE] [+-]? DIGIT+

      comment   <-  '/*' (! '*/' .)* '*/'
                  / '//' [^\n]*
    }

Because `true`, `false`, and `nil` all have special meaning to Rattler's
parsers, we encode these as symbols, then decode the symbols when we match
objects and arrays.

`json_helper`:

    module JsonHelper

      def object(members)
        Hash[*members.map {|k, v| [k, decode(v)] }.flatten(1)]
      end

      def array(a)
        a.map {|_| decode _ }
      end

      def string(expr)
        eval "%q#{expr}", TOPLEVEL_BINDING
      end

      def number(expr)
        eval expr, TOPLEVEL_BINDING
      end

      def decode(v)
        case v
        when :true then true
        when :false then false
        when :null then nil
        else v
        end
      end

    end
