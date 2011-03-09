require File.dirname(__FILE__) + '/tests_watchr_helper'

watch('spec/.*_spec\.rb')           {|md| rspec md[0] }
watch('lib/(.*\.rb)')               {|md| test "spec/#{File.dirname md[1]}" }
watch('spec/.*_examples\.rb')       {|md| rspec File.dirname(md[0]) }
watch('spec/support/.*\.rb')        {|md| rspec '.' }
watch('features/.*\.(feature|rb)')  { cucumber }

def test(arg='.')
  rspec arg
  cucumber
end

trap_signals

test '.'
