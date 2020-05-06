require_relative 'lib/dwarftree/version'

Gem::Specification.new do |spec|
  spec.name          = 'dwarftree'
  spec.version       = Dwarftree::VERSION
  spec.authors       = ['Takashi Kokubun']
  spec.email         = ['takashikkbn@gmail.com']

  spec.summary       = %q{A wrapper of `objdump --dwarf=info` to visualize a structure of inlined subroutines}
  spec.description   = %q{A wrapper of `objdump --dwarf=info` to visualize a structure of inlined subroutines}
  spec.homepage      = 'https://github.com/k0kubun/dwarftree'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
