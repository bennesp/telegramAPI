require 'open-uri'
require 'json'
require 'net/http'
require 'net/https'
require 'uri'
require 'rest_client'
require 'telegramObjects'

# This library provides an easy way to access to the Telegram Bot API
# Author:: Benedetto Nespoli
# License:: MIT

class TelegramAPI
  @@core = "https://api.telegram.org/bot"

  # Create a new instance of TelegramAPI
  #
  # @param token [String] the access token, obtained thanks to {https://telegram.me/botfather @BotFather} on Telegram.
  def initialize token
    @token = token
    @last_update = 0
  end

  def parse_hash hash
    ret = {}
    hash.map do |k,v|
      ret[k]=URI::encode(v.to_s.gsub("\\\"", "\""))
    end
    return ret
  end

  def query api, params={}
    p=[]
    params_s=""

    params.each do |param| p<<param.join("=") end
    params_s="?"+p.join("&") if p.length!=0

    JSON.parse(open(@@core+@token+"/"+api+params_s).read)
  end

  # Provide information about the bot itself
  # @return [User] Information about the bot
  def getMe
    User.new self.query("getMe")
  end

  # Get last updates, including last received messages
  # @param options [Hash<String, String>] Optional settings
  # @return [Array<Update>] List of all updates
  def getUpdates options={"timeout"=>0, "limit"=>100}
    r=self.query "getUpdates", {"offset"=>@last_update.to_s}.merge(parse_hash(options))
    if r['ok']!=true then return nil end
    up=ArrayOf.new(r['result'],Update).to_a
    if up[-1]!=nil then @last_update=up[-1].update_id+1 end
    return up
  end

  # Send a message to the user with id +to+, with the text +text+
  # @param to [Integer] chat_id to which send the message. Usually message.chat.id
  # @param text [String] The text to send
  # @param options (see #getUpdates)
  # @return [Message] Message with the Photo sent
  def sendMessage to, text, options={}
    if options.has_key?"reply_markup" then
      options["reply_markup"]=options["reply_markup"].to_json
    end
    Message.new self.query("sendMessage", {"chat_id"=>to.to_s, "text"=>URI::encode(text)}.merge(parse_hash(options)))["result"]
  end

  # Send a message as forwarded
  # @param to (see #sendMessage)
  # @param from [Integer] chat_id of the original message.
  # @param msg [Integer] The message_id of the original message
  # @return (see #sendPhoto)
  def forwardMessage to, from, msg
    Message.new self.query("forwardMessage", {"chat_id"=>to, "from_chat_id"=>from, "message_id"=>msg})["result"]
  end

  # Send a local file containing a photo
  # @param to (see #sendMessage)
  # @param path [String] The path of the file to send
  # @param options (see #sendMessage)
  # @return (see #sendMessage)
  def sendPhoto to, path, options={}
    Message.new JSON.parse(RestClient.post(@@core+@token+"/sendPhoto", {:photo=>File.new(path,'rb'), :chat_id=>to.to_s}.merge(parse_hash(options))).body)["result"]
  end

  # Send an audio file in Ogg OPUS format of max 50MB
  # @param (see #sendPhoto)
  # @return (see #sendPhoto)
  def sendAudio to, path, options={}
    Message.new JSON.parse(RestClient.post(@@core+@token+"/sendAudio", {:audio=>File.new(path, 'rb'), :chat_id=>to.to_s}.merge(parse_hash(options))).body)["result"]
  end

  # Send a general document (file, image, audio)
  # @param (see #sendPhoto)
  # @return (see #sendPhoto)
  def sendDocument to, path, options={}
    Message.new JSON.parse(RestClient.post(@@core+@token+"/sendDocument", {:document=>File.new(path,'rb'), :chat_id=>to.to_s}.merge(parse_hash(options))).body)["result"]
  end

  # Send a Sticker from File
  # @param (see #sendPhoto)
  # @return (see #sendSticker)
  def sendStickerFromFile to, path, options={}
    Message.new JSON.parse(RestClient.post(@@core+@token+"/sendStiker", {:sticker=>File.new(path,'rb'), :chat_id=>to.to_s}.merge(parse_hash(options))).body)["result"]
  end

  # Send a Sticker through its ID
  # @param to (see #sendPhoto)
  # @param id [Integer] the ID of the sticker to send
  # @param options (see #sendPhoto)
  # @return (see #sendPhoto)
  def sendSticker to, id, options={}
    Message.new JSON.parse(RestClient.post(@@core+@token+"/sendSticker", {:sticker=>id, :chat_id=>to.to_s}.merge(parse_hash(options))).body)["result"]
  end

  # Send a video file in mp4 format of max 50MB
  # @param (see #sendPhoto)
  # @return (see #sendPhoto)
  def sendVideo to, path, options={}
    Message.new JSON.parse(RestClient.post(@@core+@token+"/sendVideo", {:video=>File.new(path,'rb'), :chat_id=>to.to_s}.merge(parse_hash(options))).body)["result"]
  end
  
  # Send a location
  # @param to (see #sendPhoto)
  # @param lat [Float] Latitude
  # @param long [Float] Longitude
  # @param options (see #sendPhoto)
  # @return (see #sendPhoto)
  def sendLocation to, lat, long, options={}
    Message.new self.query("sendLocation", {"chat_id"=>to, "latitude"=>lat, "longitude"=>long}.merge(parse_hash(options)))["result"]
  end

  # Send a Chat Action
  # @param to (see #sendPhoto)
  # @param act [String] One of: typing, upload_photo, record_video, record_audio, upload_audio, upload_document, find_location
  def sendChatAction to, act
    self.query "sendChatAction", {"chat_id"=>to, "action"=>act}
  end

  # Get a list of user profile photos, in up to 4 sizes each
  # @param id [Integer] ID user whom getting the photos
  # @param options (see #sendPhoto)
  # @return [UserProfilePhotos]
  def getUserProfilePhotos id, options={}
    UserProfilePhotos.new self.query("getUserProfilePhotos", {"user_id"=>id}.merge(parse_hash(options)))["result"]
  end

  protected :query, :parse_hash
end
