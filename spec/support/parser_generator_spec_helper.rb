module ParserGeneratorSpecHelper
  
  def generated_code(*args)
    Rattler::BackEnd::RubyGenerator.code do |g|
      yield described_class.new(g, *args)
    end
  end
  
  def nested_code(opts = {})
    args = opts[:choice_level], opts[:sequence_level], opts[:repeat_level]
    Rattler::BackEnd::RubyGenerator.code do |g|
      yield described_class.nested(g, *args)
    end
  end
  
  def top_level_code(opts = {})
    args = opts[:choice_level], opts[:sequence_level], opts[:repeat_level]
    Rattler::BackEnd::RubyGenerator.code do |g|
      yield described_class.top_level(g, *args)
    end
  end
  
end
