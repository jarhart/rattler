Given /grammar with:$/ do |source|
  @parser_class = Rattler.compile_parser(source)
end

Given /grammar called "([^\"]*)" with:$/ do |name, source|
  Rattler.compile((::Grammars[name.to_sym] = Module.new), source)
end

Given /class definition:$/ do |source|
  eval(source, TOPLEVEL_BINDING)
end

When /parse ([^[:alpha:]].*)$/ do |expr|
  @parser = @parser_class.new(eval(expr, TOPLEVEL_BINDING))
end

When /parse position is (.+)$/ do |expr|
  @parser.pos = eval(expr, TOPLEVEL_BINDING)
end

Then /parse result should be (?!FAIL)(.+)$/ do |expr|
  @parser.parse.should == eval(expr, TOPLEVEL_BINDING)
end

Then /parse should fail/ do
  @parser.parse.should be_false
end

Then /parse result should be FAIL$/ do
  Then "parse should fail"
end

Then /parse position should be (.+)$/ do |expr|
  @parser.pos.should == eval(expr, TOPLEVEL_BINDING)
end

Then /failure message should be (.+)$/ do |expr|
  @parser.failure.message.should == eval(expr, TOPLEVEL_BINDING)
end

Then /failure position should be (.+)$/ do |expr|
  @parser.failure.pos.should == eval(expr, TOPLEVEL_BINDING)
end

Then /^\$x should be (.+)$/ do |expr|
  $x.should == eval(expr, TOPLEVEL_BINDING)
end
