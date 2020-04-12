lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'command_line/version'

Gem::Specification.new do |spec|
  spec.name    = 'command_line'
  spec.version = CommandLine::VERSION
  spec.authors = ['Aaron Lasseigne']
  spec.email   = ['aaron.lasseigne@dragonruby.org']

  spec.summary     = 'An easier way execute command line applications and get all of the output.'
  spec.description = spec.summary
  spec.homepage    = 'https://github.com/DragonRuby/command_line'
  spec.license     = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/DragonRuby/command_line'
    spec.metadata['changelog_uri'] = 'https://github.com/DragonRuby/command_line/blob/master/CHANGELOG.md'
  end

  spec.required_ruby_version = '>= 2.4'

  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.81.0'
  spec.add_development_dependency 'yard', '~> 0.9.20'
  spec.add_development_dependency 'redcarpet', '~> 3.5.0'
end
