# -*- encoding: utf-8 -*-
# stub: iruby 0.8.0 ruby lib
# stub: ext/Rakefile

Gem::Specification.new do |s|
  s.name = "iruby".freeze
  s.version = "0.8.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "msys2_mingw_dependencies" => "zeromq" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Daniel Mendler".freeze, "The SciRuby developers".freeze]
  s.bindir = "exe".freeze
  s.date = "2024-07-28"
  s.description = "A Ruby kernel for Jupyter environment. Try it at try.jupyter.org.".freeze
  s.email = ["mail@daniel-mendler.de".freeze]
  s.executables = ["iruby".freeze]
  s.extensions = ["ext/Rakefile".freeze]
  s.files = ["exe/iruby".freeze, "ext/Rakefile".freeze]
  s.homepage = "https://github.com/SciRuby/iruby".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.5.11".freeze
  s.summary = "Ruby Kernel for Jupyter".freeze

  s.installed_by_version = "3.5.20".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<data_uri>.freeze, ["~> 0.1".freeze])
  s.add_runtime_dependency(%q<ffi-rzmq>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<irb>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<logger>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<mime-types>.freeze, [">= 3.3.1".freeze])
  s.add_runtime_dependency(%q<multi_json>.freeze, ["~> 1.11".freeze])
  s.add_runtime_dependency(%q<native-package-installer>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<pycall>.freeze, [">= 1.2.1".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<test-unit>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<test-unit-rr>.freeze, [">= 0".freeze])
end
