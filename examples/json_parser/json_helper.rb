module JsonHelper

  def object(members)
    Hash[*members.map {|_| [_[0], decode(_[1])] }.flatten(1)]
  end

  def string(expr)
    eval "%q#{expr}", TOPLEVEL_BINDING
  end

  def number(expr)
    eval expr, TOPLEVEL_BINDING
  end

  def decode_member(key, value)
    [key, decode(value)]
  end

  def decode(v)
    case v
    when :true then true
    when :false then false
    when :null then nil
    when Array then v.map {|_| decode _ }
    else v
    end
  end

end
