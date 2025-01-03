# -*- encoding: utf-8 -*-
# stub: rufus-scheduler 3.9.2 ruby lib

Gem::Specification.new do |s|
  s.name = "rufus-scheduler".freeze
  s.version = "3.9.2".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/jmettraux/rufus-scheduler/issues", "changelog_uri" => "https://github.com/jmettraux/rufus-scheduler/blob/master/CHANGELOG.md", "homepage_uri" => "https://github.com/jmettraux/rufus-scheduler", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/jmettraux/rufus-scheduler" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["John Mettraux".freeze]
  s.date = "2024-09-04"
  s.description = "Job scheduler for Ruby (at, cron, in and every jobs). Not a replacement for crond.".freeze
  s.email = ["jmettraux@gmail.com".freeze]
  s.homepage = "https://github.com/jmettraux/rufus-scheduler".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9".freeze)
  s.rubygems_version = "3.4.19".freeze
  s.summary = "job scheduler for Ruby (at, cron, in and every jobs)".freeze

  s.installed_by_version = "3.5.20".freeze if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<fugit>.freeze, ["~> 1.1".freeze, ">= 1.11.1".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.7".freeze])
  s.add_development_dependency(%q<chronic>.freeze, ["~> 0.10".freeze])
end
