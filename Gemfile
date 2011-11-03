source :rubygems

group :development do
  gem "bundler", "~> 1.0.0"
  gem "ruby-graphviz", "~> 1.0.0"
  gem "jeweler", "~> 1.6.0"
  gem "rspec", "~> 2.6.0"
  gem "cucumber", "~> 1.1.0"
  gem "aruba", "~> 0.4.0"
  gem "rcov", "~> 0.9.10", :platforms => [:mri_18, :mingw_18]
  gem "yard", "~> 0.7.0"
  gem "guard", "~> 0.8.0"
  gem "guard-rspec", "~> 0.5.0"
  gem "guard-cucumber", "~> 0.7.0"

  # uncomment to test the CLI
  # gem "rattler", :path => "."

  # uncomment for guard FSEvent support on OS X
  # gem "rb-fsevent"

  # uncomment one of the following for guard notifications on OS X
  # gem "ruby_gntp"
  # gem "growl_notify"
  # gem "growl"

  # uncomment for guard inotify support on Linux
  # gem "rb-inotify"

  # uncomment for guard notifications on Linux
  # gem "libnotify"

  platforms :mswin, :mingw do
    gem "rb-fchange"
    gem "rb-notifu"
    gem "win32console"
  end
end
