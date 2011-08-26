guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+\.rb)$})       { |m| "spec/#{File.dirname m[1]}" }
  watch(%r{spec/.*_examples\.rb}) { |m| File.dirname(m[0]) }
  watch(%r{spec/support/.*\.rb})  { 'spec' }
  watch('spec/spec_helper.rb')    { 'spec' }
end
