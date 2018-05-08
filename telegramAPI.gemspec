Gem::Specification.new do |s|
  s.name	= 'telegramAPI'
  s.version	= '1.4'
  s.date	= '2016-12-30'
  s.summary	= "Telegram API Wrapper for Bots"
  s.description	= "A lightweight wrapper in Ruby for Telegram API Bots"
  s.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.2'
  s.authors	= ["Benedetto Nespoli"]
  s.email	= 'benedetto.nespoli@gmail.com'
  s.files	= ["lib/telegramAPI.rb", "README.md"]
  s.homepage	= 'https://github.com/bennesp/telegramAPI'
  s.required_ruby_version = '>=1.9.2'
  s.license	= 'MIT'
end
