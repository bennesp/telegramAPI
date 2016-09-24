Gem::Specification.new do |s|
  s.name	= 'telegramAPI'
  s.version	= '1.1'
  s.date	= '2015-09-07'
  s.summary	= "Telegram API Wrapper for Bots"
  s.description	= "A lightweight wrapper in Ruby for Telegram API Bots"
  s.add_runtime_dependency 'rest-client', '~> 1.7', '>=1.7.3'
  s.authors	= ["Benedetto Nespoli"]
  s.email	= 'benedetto.nespoli@gmail.com'
  s.files	= ["lib/telegramAPI.rb", "lib/telegramObjects.rb", "README.md"]
  s.homepage	= 'https://github.com/bennesp/telegramAPI'
  s.required_ruby_version = '>=1.9.2'
  s.license	= 'MIT'
end
