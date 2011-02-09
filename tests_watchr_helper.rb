def rspec(arg='.', opts={})
  cmd = "rspec #{arg}"
  if opts[:multiruby]
    run cmd, opts
  else
    run(cmd, opts) ? tests_passed : tests_failed
  end
end

def cucumber(opts={})
  run 'rake features', opts
end

def rspec_multi(arg)
  rspec arg, :multiruby => true
end

def cucumber_multi
  cucumber :multiruby => true
end

def run(cmd, opts={})
  cmdline = opts[:multiruby] ? multiruby(cmd) : cmd
  puts cmdline
  result = system cmdline 
  raise "command #{cmdline.inspect} failed" if result.nil?
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

def multiruby(cmd)
  if command_works? 'rvm --version'
    "rvm exec #{cmd}"
  elsif command_works? 'pik --version'
    "pik run #{cmd}"
  else
    raise 'I need rvm or pik to test with multiple rubies'
  end
end

def command_works?(cmd)
  @__command_works_cache__ ||= Hash.new {|h, cmd| begin
    `#{cmd}`
    h[cmd] = true
  rescue
    h[cmd] = false
  end }
  @__command_works_cache__[cmd]
end