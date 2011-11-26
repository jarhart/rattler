
# @private
module IniGrammar #:nodoc:
  
  # @private
  def start_rule #:nodoc:
    :configuration
  end
  
  # @private
  def match_configuration #:nodoc:
    apply :match_configuration!
  end
  
  # @private
  def match_configuration! #:nodoc:
    p0 = @scanner.pos
    begin
      (r0_0 = begin
        a0 = []
        while r = begin
          match(:property) ||
          match(:section_name)
        end
          a0 << r
        end
        select_captures(a0)
      end) &&
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)\z/) &&
      (@properties)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_property #:nodoc:
    apply :match_property!
  end
  
  # @private
  def match_property! #:nodoc:
    p0 = @scanner.pos
    begin
      (r0_0 = match(:name)) &&
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)(?>=)/) &&
      (r0_1 = match(:value)) &&
      (property r0_0, r0_1)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_section_name #:nodoc:
    apply :match_section_name!
  end
  
  # @private
  def match_section_name! #:nodoc:
    p0 = @scanner.pos
    begin
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)(?>\[)/) &&
      (r0_0 = match(:name)) &&
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)(?>\])/) &&
      @scanner.skip(/(?>(?>[[:blank:]])*)(?>\z|(?>(?>\r)?)(?>\n)|(?>;)(?>(?>[^\n])*))/) &&
      (section r0_0)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_name #:nodoc:
    apply :match_name!
  end
  
  # @private
  def match_name! #:nodoc:
    p0 = @scanner.pos
    begin
      (r0_0 = begin
        @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)((?>[[:alnum:]_])+)/) &&
        @scanner[1]
      end) &&
      (r0_0.to_sym)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_value #:nodoc:
    apply :match_value!
  end
  
  # @private
  def match_value! #:nodoc:
    begin
      p0 = @scanner.pos
      begin
        (r0_0 = begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)((?>")(?>(?>(?>\\)(?>.)|[^"])*)(?>"))/) &&
          @scanner[1]
        end) &&
        (unquote r0_0)
      end || begin
        @scanner.pos = p0
        false
      end
    end ||
    begin
      p0 = @scanner.pos
      begin
        (r0_0 = begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)((?>(?>[[:digit:]])+)(?>(?>\.)(?>(?>[[:digit:]])+)))/) &&
          @scanner[1]
        end) &&
        (r0_0.to_f)
      end || begin
        @scanner.pos = p0
        false
      end
    end ||
    begin
      p0 = @scanner.pos
      begin
        (r0_0 = begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)((?>[[:digit:]])+)/) &&
          @scanner[1]
        end) &&
        (r0_0.to_i)
      end || begin
        @scanner.pos = p0
        false
      end
    end ||
    begin
      p0 = @scanner.pos
      begin
        (r0_0 = begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)((?>(?!(?>(?>[[:blank:]])*)(?>\z|(?>(?>\r)?)(?>\n)|(?>;)(?>(?>[^\n])*)))(?>.))*)/) &&
          @scanner[1]
        end) &&
        (r0_0.strip)
      end || begin
        @scanner.pos = p0
        false
      end
    end
  end
  
end

if __FILE__ == $0
  require 'rubygems'
  require 'rattler'
  Rattler::Util::GrammarCLI.run(IniGrammar)
end
