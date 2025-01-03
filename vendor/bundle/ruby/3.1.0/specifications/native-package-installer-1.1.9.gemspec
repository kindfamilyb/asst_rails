# -*- encoding: utf-8 -*-
# stub: native-package-installer 1.1.9 ruby lib

Gem::Specification.new do |s|
  s.name = "native-package-installer".freeze
  s.version = "1.1.9".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kouhei Sutou".freeze]
  s.date = "2023-12-18"
  s.description = "Users need to install native packages to install an extension library\nthat depends on native packages. It bores users because users need to\ninstall native packages and an extension library separately.\n\nnative-package-installer helps to install native packages on \"gem install\".\nUsers can install both native packages and an extension library by one action,\n\"gem install\".".freeze
  s.email = ["kou@clear-code.com".freeze]
  s.homepage = "https://github.com/ruby-gnome/native-package-installer".freeze
  s.licenses = ["LGPL-3+".freeze]
  s.rubygems_version = "3.5.1".freeze
  s.summary = "native-package-installer helps to install native packages on \"gem install\"".freeze

  s.installed_by_version = "3.5.20".freeze if s.respond_to? :installed_by_version
end
