# encoding: utf-8

require File.expand_path('../lib/hexp_ui/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'hexp_ui'
  gem.version     = HexpUI::VERSION
  gem.authors     = [ 'Arne Brasseur' ]
  gem.email       = [ 'arne@arnebrasseur.net' ]
  gem.description = 'Hexp UI'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/plexus/hexp-ui'
  gem.license     = 'MIT'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files`.split($/)
  gem.test_files       = `git ls-files -- spec`.split($/)
  gem.extra_rdoc_files = %w[README.md]

  gem.add_runtime_dependency 'hexp', '>= 0.2.0'
end
