group 'spec' do
  guard 'rspec', :all_on_start => true, :all_after_pass => true, :failed_mode => :keep do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+\.rb)$})       { |m| "spec/#{File.dirname m[1]}" }
    watch(%r{spec/.*_examples\.rb}) { |m| File.dirname(m[0]) }
    watch(%r{spec/support/.*\.rb})  { 'spec' }
    watch('spec/spec_helper.rb')    { 'spec' }
  end
end

group 'cucumber' do
  guard 'cucumber', :cli => '--profile guard' do
    watch(%r{^features/.+\.feature$})
    watch(%r{^lib/(.+\.rb)$})                             { 'features' }
    watch(%r{^features/support/.+$})                      { 'features' }
    watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
  end
end
