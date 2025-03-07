# -*- encoding: utf-8 -*-
# stub: ffi-rzmq-core 1.0.7 ruby lib

Gem::Specification.new do |s|
  s.name = "ffi-rzmq-core".freeze
  s.version = "1.0.7".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Chuck Remes".freeze]
  s.date = "2019-01-05"
  s.description = "This gem provides only the FFI wrapper for the ZeroMQ (0mq) networking library.\n    Project can be used by any other zeromq gems that want to provide their own high-level Ruby API.".freeze
  s.email = ["git@chuckremes.com".freeze]
  s.homepage = "http://github.com/chuckremes/ffi-rzmq-core".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.3".freeze
  s.summary = "This gem provides only the FFI wrapper for the ZeroMQ (0mq) networking library.".freeze

  s.installed_by_version = "3.5.20".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<ffi>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
end
