Gem::Specification.new do |s|
  s.name        = "ts3bot"
  s.version     = "0.1"
  s.author      = "aetaric"
  s.email       = "aetaric@ecs-server.net"
  s.homepage    = "https://github.com/aetaric/ts3bot"
  s.summary     = "Basic Teamspeak Bot"
  s.description = "A bot that connects to a teamspeak3 server via it's query interface and provides basic Idle and Away movement capabilities."
  s.add_dependency('ts3query', '>= 0.4.1')
  s.files        = Dir["lib/**/*", "[A-Z]*"] - ["Gemfile.lock"]
  s.require_path = "lib"
end
