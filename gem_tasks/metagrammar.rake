require 'rattler/rake_task'

METAGRAMMAR_SRC = 'lib/rattler/compiler/rattler.rtlr'
METAGRAMMAR_DST = 'lib/rattler/compiler/metagrammar.rb'

desc 'Generate Metagrammar module from rattler.rtlr'
task :metagrammar => METAGRAMMAR_DST

Rattler.file METAGRAMMAR_DST => METAGRAMMAR_SRC do |t|
  t.before { archive_metagrammar }
end

def archive_metagrammar
  source_file = 'lib/rattler/compiler/metagrammar.rb'
  timestamp = Time.now.strftime '%Y%m%d_%H%M%S'
  target_file = "archive/metagrammar_#{timestamp}.rb"
  mkdir_p File.dirname(target_file)
  cp source_file, target_file
end
