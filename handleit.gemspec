Gem::Specification.new do |s|
  s.author = ["Oleg Saltykov"]
  s.homepage = "https://github.com/nucleom42/handleit"
  s.name = %q{handleit}
  s.version = "1.2.6"
  s.licenses    = ['MIT']
  s.date = %q{2021-10-20}
  s.summary = %q{Handleit - promise like way of handling logic execution with ability of chaining handlers like in js promise, plus some useful additions like guard and rollback}
  s.files = Dir['lib/*']
  s.require_paths = %w(lib)
end