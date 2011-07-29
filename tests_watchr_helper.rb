def rspec(arg='.')
  run("rspec #{arg}") ? tests_passed : tests_failed
end

def cucumber
  run 'rake features'
end

def run(cmd)
  puts cmd
  result = system cmd
  raise "command #{cmd.inspect} failed" if result.nil?
  result
end

def tests_passed
  fixed = @failed_last
  @failed_last = false
  tests_fixed if fixed
end

def tests_failed
  @failed_last = true
end

def tests_fixed
  reload
end

def trap_signals
  Signal.trap 'INT' do
    if @sent_an_int
      abort "\n"
    else
      @sent_an_int = true
      puts ' Ctrl-C again to exit'
      sleep 1.5
      reload
      @sent_an_int = false
    end
  end
  Signal.trap('QUIT') { reload }
rescue
end
