# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "keyword_params/version"

Gem::Specification.new do |s|
  s.name        = "keyword_params"
  s.version     = KeywordParams::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Avdi Grimm"]
  s.email       = ["avdi@avdi.org"]
  s.homepage    = ""
  s.summary     = %q{Declarative keyword arguments for methods}
  s.description = %q{Declarative keyword arguments for methods}

  s.rubyforge_project = "keyword_params"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rcodetools'
end
