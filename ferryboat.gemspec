# frozen_string_literal: true

require_relative "lib/ferryboat/version"

# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "ferryboat"
  spec.version       = Ferryboat::VERSION
  spec.authors       = ["21tycoons"]
  spec.email         = ["liroy@tycooncrm.com"]

  spec.summary       = "Lightweight zero-downtime deployment tool."
  spec.description   = <<~DESC
    Ferryboat is a deployment solution focused on simplicity and reliability.
    It supports zero-downtime rollouts, staging environments, and basic volume
    backups. Designed to work with Docker and SSH, it helps teams deliver code
    safely to production without unnecessary complexity.
  DESC

  spec.homepage      = "https://github.com/21tycoons/ferryboat"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "exe/*", "README.md", "LICENSE.txt"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.3"
  spec.add_dependency "kamal", "~> 1.0"
end
