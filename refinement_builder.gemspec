require_relative './lib/version.rb'
Gem::Specification.new do |s|
  s.name        = "refinement_builder"
  s.version     = RefinementBuilder::VERSION
  s.date        = "2017-11-18"
  s.summary     = "refinement builder class/dsl"
  s.description = ""
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["max pleaner"]
  s.email       = 'maxpleaner@gmail.com'
  s.required_ruby_version = '~> 2.3'
  s.homepage    = "http://github.com/maxpleaner/refinement_builder"
  s.files       = Dir["lib/**/*.rb", "bin/*", "**/*.md", "LICENSE"]
  s.require_path = 'lib'
  s.required_rubygems_version = ">= 2.5.1"
  s.executables = Dir["bin/*"].map &File.method(:basename)
  s.add_dependency 'gemmyrb'
  s.license     = 'MIT'
end
