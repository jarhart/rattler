require File.dirname(__FILE__) + '/tests_watchr_helper'

watch('spec/.*_spec\.rb')           {|md| rspec_multi md[0] }
watch('lib/(.*\.rb)')               {|md| test "spec/#{File.dirname md[1]}" }
watch('spec/.*_examples\.rb')       {|md| rspec_multi File.dirname(md[0]) }
watch('spec/support/.*\.rb')        {|md| rspec_multi '.' }
watch('features/.*\.(feature|rb)')  { cucumber_multi }

def test(arg='.')
  rspec_multi arg
  cucumber_multi
end

trap_signals

test '.'
