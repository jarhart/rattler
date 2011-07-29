module JsonHelper

  def object(members)
    Hash[*members.map {|k, v| [k, decode(v)] }.flatten(1)]
  end

  def string(expr)
    eval "%q#{expr}", TOPLEVEL_BINDING
  end

  def number(expr)
    eval expr, TOPLEVEL_BINDING
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
