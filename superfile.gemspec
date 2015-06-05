#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

Kernel.load(File.expand_path("../lib/superfile/version.rb", __FILE__))

Gem::Specification.new do |s|
  s.name        = "superfile"
  s.version     = SuperFile::VERSION
  s.license     = 'Apache 2.0'
  s.authors     = ["Phil Perret"]
  s.email       = ["phil@atelier-icare.net"]
  s.homepage    = "https://github.com/philippeperret/superfile_v1"
  s.description = %q{
    Rubygem to deal with files.
  }
  s.summary     = %q{
    Rubygem to deal with files.
  }
#   s.post_install_message = <<-MESSAGE
# # In case of problems run the following command to update binstubs:
# gem regenerate_binstubs
#   MESSAGE


  # s.files       = `git ls-files`.split("\n")
  # s.files         = [ "lib/restsite.rb" ]
  s.files         = Dir["lib/**/*"]
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.extensions  = %w( ext/wrapper_installer/extconf.rb )
  # s.executables   = %w( restsite )

  # s.add_development_dependency "tf"
  #s.add_development_dependency "smf-gem"
end
