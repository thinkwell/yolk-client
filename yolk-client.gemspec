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

  s.add_runtime_dependency(%q<john-hancock>, ">= 0.0.2")
  s.add_runtime_dependency(%q<hashie>, '~> 1.0.0')
  s.add_runtime_dependency(%q<multi_json>, '~> 0.0.5')
  s.add_runtime_dependency(%q<faraday>, '~> 0.6.0')
  s.add_runtime_dependency(%q<faraday_middleware>, '~> 0.6.3')
  s.add_runtime_dependency(%q<rash>, '~> 0.3.0')

  s.add_development_dependency(%q<rspec-core>, ">= 2.5.1")
  s.add_development_dependency(%q<rspec-expectations>, ">= 2.5.0")
  s.add_development_dependency(%q<forgery>, ">= 0.2.2")
  s.add_development_dependency(%q<webmock>, ">= 1.6.2")
  s.add_development_dependency(%q<vcr>, ">= 1.8.0")
  s.add_development_dependency(%q<rr>, ">= 1.0.2")
end
