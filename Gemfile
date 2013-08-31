source 'https://rubygems.org'

gemspec

group :development do
  gem 'ruby-graphviz', '~> 1.0'
  gem 'jeweler', '~> 1.8'
  gem 'rspec', '~> 2.10'
  gem 'cucumber', '~> 1.2'
  gem 'aruba', '~> 0.5'
  gem 'rcov', :platforms => [:mri_18, :mingw_18]
  gem 'yard'
  gem 'guard-rspec'
  gem 'guard-cucumber'

  gem 'rattler', :path => '.'

  gem 'coolline', :require => false

  # uncomment one of the following for guard notifications on OS X
  # gem "growl"
  # gem "growl_notify"
  # gem "ruby_gntp"
  # gem 'terminal-notifier-guard'
  gem 'rb-fsevent', :require => false

  gem 'libnotify', :require => false
  gem 'rb-inotify', :require => false

  platforms :mswin, :mingw do
    gem 'rb-notifu'
    gem 'win32console'
    # gem 'ruby_gntp'
    gem 'wdm'
  end
end
