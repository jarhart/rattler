
# @private
module IniGrammar #:nodoc:
  
  # @private
  def start_rule #:nodoc:
    :configuration
  end
  
  # @private
  def match_configuration #:nodoc:
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
        a0
      end) &&
      begin
        p1 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*/) &&
          @scanner.eos? &&
          true
        end || begin
          @scanner.pos = p1
          false
        end
      end &&
      (@properties )
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_property #:nodoc:
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
    p0 = @scanner.pos
    begin
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)(?>\[)/) &&
      (r0_0 = match(:name)) &&
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)(?>\])/) &&
      match(:eol) &&
      (section r0_0)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_name #:nodoc:
    p0 = @scanner.pos
    begin
      @scanner.skip(/(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*/) &&
      (r0_0 = @scanner.scan(/(?>[[:alnum:]_])+/)) &&
      (r0_0.to_sym)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_value #:nodoc:
    begin
      p0 = @scanner.pos
      begin
        @scanner.skip(/(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*/) &&
        (r0_0 = @scanner.scan(/(?>")(?>(?>(?>\\)(?>.)|[^"])*)(?>")/)) &&
        (unquote r0_0)
      end || begin
        @scanner.pos = p0
        false
      end
    end ||
    begin
      p0 = @scanner.pos
      begin
        @scanner.skip(/(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*/) &&
        (r0_0 = @scanner.scan(/(?>(?>[[:digit:]])+)(?>(?>\.)(?>(?>[[:digit:]])+))/)) &&
        (r0_0.to_f)
      end || begin
        @scanner.pos = p0
        false
      end
    end ||
    begin
      p0 = @scanner.pos
      begin
        @scanner.skip(/(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*/) &&
        (r0_0 = @scanner.scan(/(?>[[:digit:]])+/)) &&
        (r0_0.to_i)
      end || begin
        @scanner.pos = p0
        false
      end
    end ||
    begin
      p0 = @scanner.pos
      begin
        @scanner.skip(/(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*/) &&
        (r0_0 = begin
          a0 = []
          while r = begin
            p1 = @scanner.pos
            begin
              begin
                p1 = @scanner.pos
                r = !match(:eol)
                @scanner.pos = p1
                r
              end &&
              @scanner.skip(/./) &&
              @scanner.string[p1...(@scanner.pos)]
            end || begin
              @scanner.pos = p1
              false
            end
          end
            a0 << r
          end
          a0.join
        end) &&
        (r0_0.strip)
      end || begin
        @scanner.pos = p0
        false
      end
    end
  end
  
  # @private
  def match_eol #:nodoc:
    p0 = @scanner.pos
    begin
      @scanner.skip(/(?>[[:blank:]])*/) &&
      begin
        @scanner.eos? ||
        @scanner.skip(/(?>(?>\r)?)(?>\n)|(?>;)(?>(?>[^\n])*)/)
      end &&
      true
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
end
