source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "bundler", "~> 1.0.0"
  gem "ruby-graphviz", "~> 1.0.0"
  gem "jeweler", "~> 1.5.0"
  gem "rspec", "~> 2.6.0"
  gem "cucumber", "~> 1.0.0"
  gem "aruba", "~> 0.4.0"
  gem "rcov", "~> 0.9.10", :platforms => [:ruby_18, :mingw_18]
  gem "yard", "~> 0.7.0"
  gem "guard", "~> 0.6.3"
  gem "guard-rspec", "~> 0.4.3"
  gem "guard-cucumber", "~> 0.6.1"

  # uncomment to test the CLI
  # gem "rattler", :path => "."

  # uncomment for guard FSEvent support on OS X
  # gem "rb-fsevent"

  # uncomment one of the following for guard notifications on OS X
  # gem "growl_notify"
  # gem "growl"

  # uncomment for guard inotify support on Linux
  # gem "rb-inotify"

  # uncomment for guard notifications on Linux
  # gem "libnotify"

  platforms :mswin, :mingw do
    gem "rb-fchange"
    gem "rb-notifu"
  end
end
