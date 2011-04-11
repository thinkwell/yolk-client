WINDOWS  = RUBY_PLATFORM.match(/(win|w)32$/)
LINUX = RUBY_PLATFORM.match(/linux/)
DARWIN = RUBY_PLATFORM.match(/darwin/)

source "http://rubygems.org"
source "http://gem.thinkwell.com/"

# Specify your gem's dependencies in yolk-client.gemspec
gemspec

group :test do
  gem 'autotest', '~> 4.4.5'
  gem 'test_notifier', '~> 0.3.6'
  if DARWIN
    gem 'rb-fsevent', '~> 0.4.0'
    gem 'growl'
  end
  if LINUX
    gem 'rb-inotify', '~> 0.8.4'
    gem 'libnotify'
  end
end