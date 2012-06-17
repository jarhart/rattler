require 'rattler/parsers'

module Rattler::Parsers

  # +ActionCode+ defines abstract ruby code with variables that can be bound
  # to captured parse results to produce concrete ruby code for semantic
  # actions.
  class ActionCode #:nodoc:

    # @param [String] code ruby code with optional block parameters and free
    #   variables and block parameters that can bound to captured parse results
    def initialize(code)
      if md = /\A\s*\|([^|]*)\|(.*)\Z/.match(code)
        @param_names = md[1].split(',').map {|_| _.strip }
        @body = md[2].strip
      else
        @param_names = []
        @body = code.strip
      end
    end

    attr_reader :param_names, :body

    # Bind parameters and variables in the code to parse results in +scope+
    #
    # @param [ParserScope] scope the scope of captured parse results
    # @return [String] concrete ruby code with the parameters and variables
    #   bound to the captured parse results
    def bind(scope)
      bind_in body, scope
    end

    # @param [ParserScope] scope the scope of captured parse results
    # @return [Hash] matchers for variables in the ruby code associated with
    #   replacement values
    def scoped_bindings(scope)
      to_bindings(scope.bindings).merge(arg_bindings(scope.captures))
    end

    # @param [Array] args captured parse results as arguments to the ruby code
    # @return [Hash] matchers for parameters in the ruby code associated with
    #   +args+ as replacements values
    def arg_bindings(args)
      if param_names.count > args.count
        raise ArgumentError, 'more parameter names than arguments'
      end
      to_bindings param_names.zip(args)
    end

    private

    def to_bindings(map)
      bindings = {}
      map.each {|name, arg| bindings[/\b#{name}\b/] = arg if name }
      bindings
    end

    def bind_in(code, scope)
      new_code = code.dup
      unless param_names.include? '_' or scope.has_name? '_'
        bind_blanks!(new_code, scope.captures)
      end
      scoped_bindings(scope).each do |k, v|
        next unless k and v
        new_code.gsub!(k, v.to_s)
      end
      new_code
    end

    def bind_blanks!(code, bind_args)
      if bind_args.size > 1
        list = bind_args.join(', ')
        code.gsub!(/\*_\b/, list)
        code.gsub!(/\b_\b/, "[#{list}]")
      elsif bind_args.size == 1
        code.gsub!(/\*_\b/, bind_args.first)
        code.gsub!(/\b_\b/, bind_args.first)
      end
    end

  end
end
