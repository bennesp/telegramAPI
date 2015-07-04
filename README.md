# TelegramAPI

This is a simple and lightweight Ruby API for Telegram Bots.

With this tiny library you can create awesome Telegram Bot!

## Installation

```
sudo gem install telegramAPI
```

## Use

Import the library in your script with:

```ruby
require 'telegramAPI'
```

Obtain a token, if you haven't yet, talking with [@BotFather](https://telegram.me/botfather)

## Getting Started

To test your access token, you can use the *getMe* method
```ruby
require 'telegramAPI'

token = "******"
api = TelegramAPI.new token
bot = api.getMe
puts "I'm bot #{bot.first_name} with id #{bot.id}"
puts "But you can call me @#{bot.username}"
```

## Documentation

Here you can find the complete [documentation](https://cdn.rawgit.com/bennesp/telegramAPI/master/doc/TelegramAPI.html)


## Examples

### Echo Server

```ruby
token = "******"
api = TelegramAPI.new token
while true do
  # Get last messages if there are, or wait 180 seconds for new messages
  u=api.getUpdates {timeout=>180}
  u.each do |m|
    api.sendMessage(m.message.chat.id, m.message.text)
  end
end
```

### Send Media

```ruby
api.sendSticker m.message.chat.id, sticker_id

api.sendPhoto m.message.chat.id, "/home/path-of-image/image.jpg"

api.sendDocument m.message.chat.id, "/home/path-of-document/doc.gif"

api.sendAudio m.message.chat.id, "/home/path-of-audio/audio.opus"

api.sendVideo m.message.chat.id, "/home/path-of-video/video.mp4"

api.sendLocation m.message.chat.id, 45.462781, 9.177732
```
**Note:** According to Telegram, each audio must be encoded in **Ogg OPUS**, and each video must be encoded in **mp4**.
