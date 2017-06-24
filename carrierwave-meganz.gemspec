# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave/meganz/version'

Gem::Specification.new do |spec|
  spec.name          = 'carrierwave-meganz'
  spec.version       = Carrierwave::Meganz::VERSION
  spec.authors       = ["Tomasz 'Kulisz' Kulik"]
  spec.email         = ['kulisz@kulisz.eu']

  spec.summary       = 'Carrierwave storage for Mega.nz'
  spec.description   = 'Mega.nz integration with Carrierwave'
  spec.homepage      = 'https://github.com/kulisz/carrierwave-meganz'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://github.com/kulisz/carrierwave-meganz'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'carrierwave'
  spec.add_development_dependency 'rmega'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
end
