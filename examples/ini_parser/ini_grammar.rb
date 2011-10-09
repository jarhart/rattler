
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
          begin
            p1 = @scanner.pos
            begin
              (r1_0 = begin
                p2 = @scanner.pos
                begin
                  (r2_0 = begin
                    @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)((?>[[:alnum:]_])+)/) &&
                    @scanner[1]
                  end) &&
                  (r2_0.to_sym)
                end || begin
                  @scanner.pos = p2
                  false
                end
              end) &&
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)(?>=)/) &&
              (r1_1 = begin
                begin
                  p2 = @scanner.pos
                  begin
                    (r2_0 = begin
                      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)((?>")(?>(?>(?>\\)(?>.)|[^"])*)(?>"))/) &&
                      @scanner[1]
                    end) &&
                    (unquote r2_0)
                  end || begin
                    @scanner.pos = p2
                    false
                  end
                end ||
                begin
                  p2 = @scanner.pos
                  begin
                    (r2_0 = begin
                      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)((?>(?>[[:digit:]])+)(?>(?>\.)(?>(?>[[:digit:]])+)))/) &&
                      @scanner[1]
                    end) &&
                    (r2_0.to_f)
                  end || begin
                    @scanner.pos = p2
                    false
                  end
                end ||
                begin
                  p2 = @scanner.pos
                  begin
                    (r2_0 = begin
                      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)((?>[[:digit:]])+)/) &&
                      @scanner[1]
                    end) &&
                    (r2_0.to_i)
                  end || begin
                    @scanner.pos = p2
                    false
                  end
                end ||
                begin
                  p2 = @scanner.pos
                  begin
                    (r2_0 = begin
                      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)((?>(?!(?>(?>[[:blank:]])*)(?>\z|(?>(?>\r)?)(?>\n)|(?>;)(?>(?>[^\n])*)))(?>.))*)/) &&
                      @scanner[1]
                    end) &&
                    (r2_0.strip)
                  end || begin
                    @scanner.pos = p2
                    false
                  end
                end
              end) &&
              (property r1_0, r1_1)
            end || begin
              @scanner.pos = p1
              false
            end
          end ||
          begin
            p1 = @scanner.pos
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)(?>\[)/) &&
              (r1_0 = begin
                p2 = @scanner.pos
                begin
                  (r2_0 = begin
                    @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)((?>[[:alnum:]_])+)/) &&
                    @scanner[1]
                  end) &&
                  (r2_0.to_sym)
                end || begin
                  @scanner.pos = p2
                  false
                end
              end) &&
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>[;#])(?>(?>[^\n])*))*)(?>\])/) &&
              @scanner.skip(/(?>(?>[[:blank:]])*)(?>\z|(?>(?>\r)?)(?>\n)|(?>;)(?>(?>[^\n])*))/) &&
              (section r1_0)
            end || begin
              @scanner.pos = p1
              false
            end
          end
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
  
end

if __FILE__ == $0
  require 'rubygems'
  require 'rattler'
  Rattler::Util::GrammarCLI.run(IniGrammar)
end
