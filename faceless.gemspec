require File.expand_path('../lib/faceless/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Alex S"]
  gem.email         = "hlcfan.yan@gmail.com.com"
  gem.description   = %q{Ruby Implementation of UCenter Authcode}
  gem.summary       = %q{A cool implementation of encryption/decryption in Ruby, borrowed from UCenter(comsenz)}
  gem.homepage      = "https://github.com/hlcfan/faceless"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "faceless"
  gem.require_paths = ["lib"]
  gem.version       = Faceless::VERSION

  gem.add_development_dependency "bundler", "~> 1.0"
end
