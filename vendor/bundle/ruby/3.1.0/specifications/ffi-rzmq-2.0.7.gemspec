# -*- encoding: utf-8 -*-
# stub: ffi-rzmq 2.0.7 ruby lib

Gem::Specification.new do |s|
  s.name = "ffi-rzmq".freeze
  s.version = "2.0.7".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Chuck Remes".freeze]
  s.date = "2019-01-05"
  s.description = "This gem wraps the ZeroMQ networking library using the ruby FFI (foreign\nfunction interface). It's a pure ruby wrapper so this gem can be loaded\nand run by any ruby runtime that supports FFI. That's all of the major ones - MRI, Rubinius and JRuby.".freeze
  s.email = ["git@chuckremes.com".freeze]
  s.homepage = "http://github.com/chuckremes/ffi-rzmq".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.3".freeze
  s.summary = "This gem wraps the ZeroMQ (0mq) networking library using Ruby FFI (foreign function interface).".freeze

  s.installed_by_version = "3.5.20".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<ffi-rzmq-core>.freeze, [">= 1.0.7".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.7".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
end
