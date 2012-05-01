WINDOWS  = RUBY_PLATFORM.match(/(win|w)32$/)
LINUX = RUBY_PLATFORM.match(/linux/)
DARWIN = RUBY_PLATFORM.match(/darwin/)

source "http://rubygems.org"
source "http://gem.thinkwell.com/"

# Specify your gem's dependencies in yolk-client.gemspec
gemspec

group :test do
  gem 'rspec'
  gem 'rr'
  gem 'autotest'
  gem 'test_notifier'
  gem 'forgery'
  gem 'webmock'
  gem 'vcr'
  if DARWIN
    gem 'rb-fsevent'
    gem 'growl'
  end
  if LINUX
    gem 'rb-inotify'
    gem 'libnotify'
  end
end
