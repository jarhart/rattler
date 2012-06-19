module JsonHelper

  def object(members)
    Hash[members.map {|k, v| [k, decode(v)] }]
  end

  def array(a)
    a.map {|_| decode _ }
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
    else v
    end
  end

end
