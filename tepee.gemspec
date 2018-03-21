# encoding: utf-8

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'tepee/version'

Gem::Specification.new do |s|
  s.name = 'tepee'
  s.version = Tepee::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2.0'
  s.authors = ['Alexandre Ignjatovic', 'Robin Sfez', 'Benoit Tigeot', 'Christophe Valentin']
  s.description = <<-EOF
    A ruby configuration helper for the braves.

    Organize your configuration into sections.

    Easily override your configuration value by updating your enviroment variables (heroku friendly).

    Self contained, and with a very light memory footprint.
  EOF

  s.email = 'alexandre.ignjatovic@gmail.com'
  s.files = `git ls-files`.split($RS).reject do |file|
    file =~ %r{^(?:
    spec/.*
    |Gemfile
    |Rakefile
    |\.rspec
    |\.gitignore
    |\.rubocop.yml
    |\.rubocop_todo.yml
    |.*\.eps
    )$}x
  end
  s.test_files = []
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.extra_rdoc_files = ['LICENSE', 'README.md']
  s.homepage = 'http://github.com/appaloosa-store/tepee'
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.rubygems_version = '1.8.23'

  s.summary = 'A ruby configuration helper for the braves'

  s.add_development_dependency('rspec', '~> 3.4')
end
