require File.dirname(__FILE__) + '/tests_watchr_helper'

watch('spec/.*_spec\.rb')     {|md| rspec_multi md[0] }
watch('lib/(.*\.rb)')         {|md| rspec_multi "spec/#{File.dirname md[1]}" }
watch('spec/.*_examples\.rb') {|md| rspec_multi File.dirname(md[0]) }
watch('spec/support/.*\.rb')  {|md| rspec_multi '.' }

trap_signals

rspec_multi '.'
