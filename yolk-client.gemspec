# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yolk-client/version"

Gem::Specification.new do |s|
  s.name        = "yolk-client"
  s.version     = Yolk::Client::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paul Strong"]
  s.email       = ["pauls@thinkwell.com"]
  s.homepage    = ""
  s.summary     = %q{REST Client for Yolk}
  s.description = %q{REST Client for Yolk. Uses john hancock for auth.}

  s.rubyforge_project = "yolk-client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<john-hancock>, [">= 0.0.7", "< 0.1.0"])
  s.add_runtime_dependency(%q<hashie>, '>= 1.0.0')
  s.add_runtime_dependency(%q<yajl-ruby>, '>= 0.8.2')
  s.add_runtime_dependency(%q<multi_json>, '>= 1.0.0')
  s.add_runtime_dependency(%q<faraday>, '>= 0.6.0')
  s.add_runtime_dependency(%q<faraday_middleware>, '>= 0.6.3')
  s.add_runtime_dependency(%q<rash>, '>= 0.3.0')

  s.add_development_dependency(%q<bundler>, [">= 1.0.21"])
  s.add_development_dependency(%q<rake>, [">= 0"])
end
