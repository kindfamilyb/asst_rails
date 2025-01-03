# -*- encoding: utf-8 -*-
# stub: redis-rails 5.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "redis-rails".freeze
  s.version = "5.0.2".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Luca Guidi".freeze, "Ryan Bigg".freeze]
  s.date = "2017-04-06"
  s.description = "Redis for Ruby on Rails".freeze
  s.email = ["me@lucaguidi.com".freeze, "me@ryanbigg.com".freeze]
  s.homepage = "http://redis-store.org/redis-rails".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.10".freeze
  s.summary = "Redis for Ruby on Rails".freeze

  s.installed_by_version = "3.5.20".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<redis-store>.freeze, [">= 1.2".freeze, "< 2".freeze])
  s.add_runtime_dependency(%q<redis-activesupport>.freeze, [">= 5.0".freeze, "< 6".freeze])
  s.add_runtime_dependency(%q<redis-actionpack>.freeze, [">= 5.0".freeze, "< 6".freeze])
  s.add_development_dependency(%q<rake>.freeze, ["~> 10".freeze])
  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.3".freeze])
  s.add_development_dependency(%q<mocha>.freeze, ["~> 0.14.0".freeze])
  s.add_development_dependency(%q<minitest>.freeze, [">= 4.2".freeze, "< 6".freeze])
  s.add_development_dependency(%q<redis-store-testing>.freeze, [">= 0".freeze])
end
