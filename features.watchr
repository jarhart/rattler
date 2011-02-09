require File.dirname(__FILE__) + '/tests_watchr_helper'

watch('features/.*\.(feature|rb)')  { cucumber }
watch('lib/.*\.rb')                 { cucumber }
watch('bin/*')                      { cucumber }

trap_signals

cucumber
