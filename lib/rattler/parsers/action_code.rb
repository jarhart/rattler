#
# = rattler/parsers/action_code.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

require 'rattler/parsers'

module Rattler::Parsers
  # @private
  class ActionCode #:nodoc:

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

    def bind(scope, bind_args)
      bind_in body, scope, bind_args
    end

    def scoped_bindings(scope, bind_args)
      to_bindings(scope).merge(arg_bindings(bind_args))
    end

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

    def bind_in(code, scope, bind_args)
      new_code = code.dup
      unless param_names.include? '_' or scope.has_key? '_'
        bind_blanks!(new_code, bind_args)
      end
      scoped_bindings(scope, bind_args).each do |k, v|
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
