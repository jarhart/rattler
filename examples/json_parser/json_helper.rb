module JsonHelper

  def object(members)
    Hash[*members.map do |_|
      case _.last
      when :true then [_.first, true]
      when :false then [_.first, false]
      when :null then [_.first, nil]
      else _
      end
    end.flatten(1)]
  end

  def string(expr)
    eval expr, TOPLEVEL_BINDING
  end

end
