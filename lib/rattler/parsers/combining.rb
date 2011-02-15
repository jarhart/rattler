#
# = rattler/parsers/combining.rb
#
# Author:: Jason Arhart
# Documentation:: Author
#

module Rattler::Parsers
  # @private
  module Combining #:nodoc:
    
    def capturing?
      @capturing ||= any? {|child| child.capturing? }
    end
    
    def with_ws(ws)
      self.class.new(children.map {|_| _.with_ws(ws) }, attrs)
    end
    
    def optimized
      self.class.new(optimized_children, attrs)
    end
    
    def token_optimized
      self.class.new(token_optimized_children, attrs)
    end
    
    def skip_optimized
      self.class.new(skip_optimized_children, attrs)
    end
    
    protected
    
    def optimized_children
      children.map {|_| _.optimized }
    end
    
    def token_optimized_children
      children.map {|_| _.token_optimized }
    end
    
    def skip_optimized_children
      children.map {|_| _.skip_optimized }
    end
    
  end
end
