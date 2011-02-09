require 'rattler/parsers'

module Rattler
  module Parsers
    # @private
    module MatchJoining #:nodoc:
      
      def optimized
        o = super
        if o.all? {|_| Skip === _ }
          Skip[self.class[o.map {|_| _.child }]].optimized
        else
          unwrap_if_singleton o
        end
      end
      
      def token_optimized
        unwrap_if_singleton super
      end
      
      def skip_optimized
        unwrap_if_singleton super
      end
      
      protected
      
      def join_matches(parsers)
        group_matches(parsers).map do |_|
          if Array === _
            _.size > 1 ? Match[Regexp.new(match_join(_))] : _[0]
          else
            _
          end
        end
      end
      
      private
      
      def unwrap_if_singleton(parser)
        parser.children.size == 1 ? parser.child : parser
      end
      
      def group_matches(parsers)
        parsers.map {|_| _.as_match || _ }.inject([]) do |a, _|
          if Match === _
            if Array === a.last
              a.last << _
              a
            else
              a << [_]
            end
          else
            a << _
          end
        end
      end
      
    end
  end
end
