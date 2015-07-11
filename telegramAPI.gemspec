Gem::Specification.new do |s|
  s.name	= 'telegramAPI'
  s.version	= '1.0.11'
  s.date	= '2015-07-10'
  s.summary	= "Telegram API for Bots"
  s.description	= "A lightweight Ruby API for Telegram Bots"
  s.add_runtime_dependency 'rest-client', '~> 1.7', '>=1.7.3'
  s.authors	= ["Benedetto Nespoli"]
  s.email	= 'benedetto.nespoli@gmail.com'
  s.files	= ["lib/telegramAPI.rb", "lib/telegramObjects.rb", "README.md"]
  s.homepage	= 'https://github.com/bennesp/telegramAPI'
  s.required_ruby_version = '>=1.9.2'
  s.license	= 'MIT'
end
