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
      bindings.merge!(to_bindings args.shift) unless args.empty?
      bind_in body, bindings
    end

    def blank_binding(args)
      case args.size

      when 0
        {}

      when 1
        { /\*_\b/ => args.first,
          /\b_\b/ => args.first }

      else
        list = args.join(', ')
        { /\*_\b/ => list,
          /\b_\b/ => '[' + list + ']' }

      end
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

    def bind_in(code, bindings)
      new_code = code
      bindings.each do |k, v|
        next unless k and v
        if bindings.has_key? '*_'
          puts('-' * 70)
          p new_code
          puts "substituting #{k.inspect} -> #{v.to_s.inspect}"
          p new_code
          puts('-' * 70)
        end
        unless k.is_a? Regexp
          puts('!' * 70)
          p bindings
          puts('!' * 70)
        end
        new_code = new_code.gsub(k, v.to_s)
      end
      new_code
    end

  end
end
