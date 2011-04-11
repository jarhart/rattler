require File.expand_path('json_helper', File.dirname(__FILE__))

# @private
class JsonParser < Rattler::Runtime::PackratParser #:nodoc:
  
  include JsonHelper
  
  # @private
  def start_rule #:nodoc:
    :json_text
  end
  
  # @private
  def match_json_text #:nodoc:
    p0 = @scanner.pos
    begin
      (r0_0 = begin
        match(:object) ||
        match(:array)
      end) &&
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)\z/) &&
      r0_0
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_object #:nodoc:
    memoize :match_object!
  end
  
  # @private
  def match_object! #:nodoc:
    p0 = @scanner.pos
    begin
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>\{)/) &&
      (r0_0 = match(:members)) &&
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>\})/) &&
      (object r0_0)
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_members #:nodoc:
    memoize :match_members!
  end
  
  # @private
  def match_members! #:nodoc:
    a0 = []
    ep0 = nil
    while r = match(:pair)
      ep0 = @scanner.pos
      a0 << r
      break unless @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>,)/)
    end
    @scanner.pos = ep0 unless ep0.nil?
    a0
  end
  
  # @private
  def match_pair #:nodoc:
    memoize :match_pair!
  end
  
  # @private
  def match_pair! #:nodoc:
    p0 = @scanner.pos
    begin
      (r0_0 = begin
        @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)((?>")(?>(?>(?!"|\\|[[:cntrl:]])(?>.)|(?>\\)(?>["\\\/bfnrt]|(?>u)(?>[[:xdigit:]])(?>[[:xdigit:]])(?>[[:xdigit:]])(?>[[:xdigit:]])))*)(?>"))/) &&
        (string @scanner[1])
      end) &&
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>:)/) &&
      (r0_1 = match(:value)) &&
      select_captures([r0_0, r0_1])
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_array #:nodoc:
    memoize :match_array!
  end
  
  # @private
  def match_array! #:nodoc:
    p0 = @scanner.pos
    begin
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>\[)/) &&
      (r0_0 = match(:elements)) &&
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>\])/) &&
      r0_0
    end || begin
      @scanner.pos = p0
      false
    end
  end
  
  # @private
  def match_elements #:nodoc:
    memoize :match_elements!
  end
  
  # @private
  def match_elements! #:nodoc:
    a0 = []
    ep0 = nil
    while r = match(:value)
      ep0 = @scanner.pos
      a0 << r
      break unless @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)(?>,)/)
    end
    @scanner.pos = ep0 unless ep0.nil?
    a0
  end
  
  # @private
  def match_value #:nodoc:
    memoize :match_value!
  end
  
  # @private
  def match_value! #:nodoc:
    match(:object) ||
    match(:array) ||
    begin
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)((?>(?>(?>\-)?)(?>(?>0)(?![[:digit:]])|(?>[1-9])(?>(?>[[:digit:]])*)))(?>(?>(?>\.)(?>(?>[[:digit:]])+))?)(?>(?>(?>[eE])(?>(?>[+-])?)(?>(?>[[:digit:]])+))?))/) &&
      (number @scanner[1])
    end ||
    begin
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)((?>")(?>(?>(?!"|\\|[[:cntrl:]])(?>.)|(?>\\)(?>["\\\/bfnrt]|(?>u)(?>[[:xdigit:]])(?>[[:xdigit:]])(?>[[:xdigit:]])(?>[[:xdigit:]])))*)(?>"))/) &&
      (string @scanner[1])
    end ||
    begin
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)((?>true)(?![[:alnum:]_]))/) &&
      (:true)
    end ||
    begin
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)((?>false)(?![[:alnum:]_]))/) &&
      (:false)
    end ||
    begin
      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\/\*)(?>(?>(?!\*\/)(?>.))*)(?>\*\/)|(?>\/\/)(?>(?>[^\n])*))*)((?>null)(?![[:alnum:]_]))/) &&
      (:null)
    end ||
    (fail! { "value expected" })
  end
  
end
