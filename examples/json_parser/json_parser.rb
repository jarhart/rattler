
# @private
class JsonParser < Rattler::Runtime::PackratParser #:nodoc:
  
  include JsonHelper
  
  # @private
  def start_rule #:nodoc:
    :object
  end
  
  # @private
  def match_object #:nodoc:
    p0 = @scanner.pos
    begin
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>\{)/) &&
      (r0_0 = match(:members)) &&
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>\})/) &&
      (object r0_0)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_members #:nodoc:
    p0 = @scanner.pos
    begin
      (r0_0 = begin
        a0 = []
        while r = begin
          p1 = @scanner.pos
          begin
            (r1_0 = match(:pair)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>,)/) &&
            r1_0
          end || begin
            @scanner.pos = p1
            false
          end
        end
          a0 << r
        end
        a0
      end) &&
      (r0_1 = ((r = match(:pair)) ? [r] : [])) &&
      (r0_0 + r0_1)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_pair #:nodoc:
    p0 = @scanner.pos
    begin
      (r0_0 = match(:string)) &&
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>:)/) &&
      (r0_1 = match(:value)) &&
      select_captures([r0_0, r0_1])
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_array #:nodoc:
    p0 = @scanner.pos
    begin
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>\[)/) &&
      (r0_0 = match(:elements)) &&
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>\])/) &&
      r0_0
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_elements #:nodoc:
    p0 = @scanner.pos
    begin
      (r0_0 = begin
        a0 = []
        while r = begin
          p1 = @scanner.pos
          begin
            (r1_0 = match(:value)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>,)/) &&
            r1_0
          end || begin
            @scanner.pos = p1
            false
          end
        end
          a0 << r
        end
        a0
      end) &&
      (r0_1 = ((r = match(:value)) ? [r] : [])) &&
      (r0_0 + r0_1)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_value #:nodoc:
    match(:string) ||
    begin
      p0 = @scanner.pos
      begin
        (r0_0 = match(:number)) &&
        begin
          p1 = @scanner.pos
          r = !begin
            @scanner.skip(/(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*/) &&
            @scanner.skip(/[[:digit:]]/)
          end
          @scanner.pos = p1
          r
        end &&
        r0_0
      end || begin
        @scanner.pos = p0
        false
      end
    end ||
    match(:object) ||
    match(:array) ||
    begin
      p0 = @scanner.pos
      begin
        @scanner.skip(/(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*/) &&
        (r0_0 = @scanner.scan(/(?>true)(?>(?![[:alnum:]_]))/)) &&
        (:true )
      end || begin
        @scanner.pos = p0
        false
      end
    end ||
    begin
      p0 = @scanner.pos
      begin
        @scanner.skip(/(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*/) &&
        (r0_0 = @scanner.scan(/(?>false)(?>(?![[:alnum:]_]))/)) &&
        (:false )
      end || begin
        @scanner.pos = p0
        false
      end
    end ||
    begin
      p0 = @scanner.pos
      begin
        @scanner.skip(/(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*/) &&
        (r0_0 = @scanner.scan(/(?>null)(?>(?![[:alnum:]_]))/)) &&
        (:null )
      end || begin
        @scanner.pos = p0
        false
      end
    end ||
    (fail! { "value expected" })
  end
  
  # @private
  def match_string #:nodoc:
    p0 = @scanner.pos
    begin
      @scanner.skip(/(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*/) &&
      (r0_0 = @scanner.scan(/(?>")(?>(?>(?>\\)(?>.)|[^"])*)(?>")/)) &&
      (string r0_0)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_number #:nodoc:
    p0 = @scanner.pos
    begin
      @scanner.skip(/(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?>(?!\*\/))(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*/) &&
      (r0_0 = @scanner.scan(/(?>(?>\-)?)(?>0|(?>[1-9])(?>(?>[[:digit:]])*))(?>(?>(?>\.)(?>(?>[[:digit:]])+))?)(?>(?>(?>[eE])(?>(?>[+-])?)(?>(?>[[:digit:]])+))?)/)) &&
      (r0_0.to_f)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
end
