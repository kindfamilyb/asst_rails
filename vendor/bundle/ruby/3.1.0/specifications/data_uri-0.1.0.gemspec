# -*- encoding: utf-8 -*-
# stub: data_uri 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "data_uri".freeze
  s.version = "0.1.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Donald Ball".freeze]
  s.date = "2014-02-18"
  s.description = "URI class for parsing data URIs".freeze
  s.email = "donald.ball@gmail.com".freeze
  s.extra_rdoc_files = ["README.rdoc".freeze]
  s.files = ["README.rdoc".freeze]
  s.homepage = "http://github.com/dball/data_uri".freeze
  s.rubygems_version = "1.8.24".freeze
  s.summary = "A URI class for parsing data URIs as per RFC2397".freeze

  s.installed_by_version = "3.5.20".freeze if s.respond_to? :installed_by_version

  s.specification_version = 3

  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<minitest>.freeze, [">= 0".freeze])
end
