Gem::Specification.new do |s|
  s.name	= 'telegramAPI'
  s.version	= '1.0.10'
  s.date	= '2015-07-010'
  s.summary	= "Telegram API for Bots"
  s.description	= "A lightweight Ruby API for Telegram Bots"
  s.add_runtime_dependency 'rest-client', '~> 0'
  s.authors	= ["Benedetto Nespoli"]
  s.email	= 'benedetto.nespoli@gmail.com'
  s.files	= ["lib/telegramAPI.rb", "lib/telegramObjects.rb", "README.md"]
  s.homepage	= 'https://github.com/bennesp/telegramAPI'
  s.documentation = 'https://cdn.rawgit.com/bennesp/telegramAPI/master/doc/TelegramAPI.html'
  s.required_ruby_version = '>=1.9.2'
  s.license	= 'MIT'
end
