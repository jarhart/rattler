source :rubygems

group :development do
  gem "bundler", "~> 1.1"
  gem "ruby-graphviz", "~> 1.0"
  gem "jeweler", "~> 1.8"
  gem "rspec", "~> 2.10"
  gem "cucumber", "~> 1.2"
  gem "aruba"
  gem "rcov", :platforms => [:mri_18, :mingw_18]
  gem "yard"
  gem "guard"
  gem "guard-rspec"
  gem "guard-cucumber"

  # uncomment to test the CLI
  # gem "rattler", :path => "."

  # uncomment one of the following for guard notifications on OS X
  # gem "growl"
  # gem "growl_notify"
  # gem "ruby_gntp"

  # uncomment for guard notifications on Linux
  # gem "libnotify"

  platforms :mswin, :mingw do
    gem "rb-notifu"
    gem "win32console"
  end
end
