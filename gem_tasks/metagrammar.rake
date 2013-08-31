require 'rattler/rake_task'

desc 'Regenerate Metagrammar module from rattler.rtlr'
task :metagrammar => [:archive_metagrammar, :generate_metagrammar]

require 'rattler/rake_task'
Rattler::RakeTask.new :generate_metagrammar do |t|
  t.grammar = File.join *%w(lib rattler compiler rattler.rtlr)
  t.rtlr_opts = ['-l', 'lib', '-f']
end

task :archive_metagrammar do
  source_file = File.join *%w(lib rattler compiler metagrammar.rb)
  timestamp = Time.now.strftime '%Y%m%d_%H%M%S'
  target_file = File.join 'archive', "metagrammar_#{timestamp}.rb"
  mkdir_p File.dirname(target_file)
  cp source_file, target_file
end
