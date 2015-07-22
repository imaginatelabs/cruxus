# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "radial"
  s.version     = "0.1.1"
  s.licenses    = ["GNU 3.0"]
  s.summary     = "Build and manage code across multiple micro services"
  s.description = "Radial provides a workflow to build and manage source code across multiple "\
                  "micro services"
  s.authors     = ["ImaginateWayne"]
  s.email       = "wayne.allan@imaginatelabs.com"
  s.homepage    = "http://rubygems.org/gems/radial"
  s.metadata    = { "issue_tracker" => "https://github.com/imaginatelabs/radial/issues" }
  s.files       = `git ls-files lib`.split "\n"
  s.executables << "rad"
end
