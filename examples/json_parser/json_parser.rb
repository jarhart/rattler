
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
    a0 = []
    lp0 = nil
    while r = match(:pair)
      lp0 = @scanner.pos
      a0 << r
      break unless @scanner.skip(/,/)
    end
    @scanner.pos = lp0 unless lp0.nil?
    a0
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
    a0 = []
    lp0 = nil
    while r = match(:value)
      lp0 = @scanner.pos
      a0 << r
      break unless @scanner.skip(/,/)
    end
    @scanner.pos = lp0 unless lp0.nil?
    a0
  end
  
  # @private
  def match_value #:nodoc:
    ((r = match(:string)) && (string r)) ||
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
        (r0_0.to_f)
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
        (:true)
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
        (:false)
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
        (:null)
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
      @scanner.scan(/(?>")(?>(?>(?>\\)(?>.)|[^"])*)(?>")/)
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
      @scanner.scan(/(?>(?>\-)?)(?>0|(?>[1-9])(?>(?>[[:digit:]])*))(?>(?>(?>\.)(?>(?>[[:digit:]])+))?)(?>(?>(?>[eE])(?>(?>[+-])?)(?>(?>[[:digit:]])+))?)/)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
end
