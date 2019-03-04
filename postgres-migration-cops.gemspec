Gem::Specification.new do |s|
  s.name        = 'postgres-migration-cops'
  s.version     = '0.0.1'
  s.date        = '2019-02-23'
  s.summary     = 'postgres-migration-cops!'
  s.description = 'postgres-migration-cops'
  s.authors     = ['G Batterbee']
  s.files       = ['lib/postgres-migration-cops.rb',
                   'lib/cops/cop1.rb',
                   'lib/cops/add-indexes-concurrently.rb']
  s.homepage    = 'http://'
  s.license     = 'MIT'
  s.executables << 'postgres-migrations-cop'
end
