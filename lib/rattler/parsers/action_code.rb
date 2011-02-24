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

    def bind(*args)
      bindings = {}
      if args.first.respond_to?(:to_ary)
        a = args.shift
        bindings.merge!(blank_binding(a)).merge!(arg_bindings(a))
      end
      bindings.merge!(args.shift) unless args.empty?
      bind_in body, bindings
    end

    def blank_binding(args)
      case args.size
      when 0 then {}
      when 1 then { '_' => args.first }
      else        { '_' => '[' + args.join(', ') + ']' }
      end
    end

    def arg_bindings(args)
      if param_names.count > args.count
        raise ArgumentError, 'more parameter names than arguments'
      end
      bindings = {}
      param_names.zip(args).each {|name, arg| bindings[name] = arg if name }
      bindings
    end

    private

    def bind_in(code, bindings)
      new_code = code
      bindings.each do |k, v|
        next unless k and v
        new_code = new_code.gsub(/\b#{k}\b/, v.to_s)
      end
      new_code
    end

  end
end
