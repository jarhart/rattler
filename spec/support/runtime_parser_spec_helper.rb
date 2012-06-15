module RuntimeParserSpecHelper

  include Rattler::Util::ParserSpecHelper

  def rule(name)
    Rule[name, yield]
  end

  def match(arg)
    case arg
    when Regexp   then Match[arg]
    when Symbol   then Apply[arg]
    else match Regexp.new(Regexp.escape(arg.to_s))
    end
  end

  def assert(arg)
    Assert[to_parser(arg)]
  end

  def disallow(arg)
    Disallow[to_parser(arg)]
  end

  def eof
    Eof[]
  end

  def e
    ESymbol[]
  end

  def token(arg)
    Token[to_parser(arg)]
  end

  def skip(arg)
    Skip[to_parser(arg)]
  end

  def label(name, arg)
    Label[name, to_parser(arg)]
  end

  def semantic_action(code)
    SemanticAction[code]
  end

  def node_action(node_class, attrs={})
    NodeAction[node_class, attrs]
  end

  private

  def to_parser(o)
    case o
    when ::Rattler::Parsers::Parser then o
    when nil    then nil
    when false  then nil
    else match(o)
    end
  end

end
