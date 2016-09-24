require 'json'
require 'net/http'
require 'net/https'
require 'uri'
require 'rest-client'
require 'ostruct'

# This library provides an easy way to access to the Telegram Bot API
# Author:: Benedetto Nespoli
# License:: MIT

class TelegramAPI
  @@core = "https://api.telegram.org/bot"

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

    params.each do |param| p << param.join("=") end
    params_s = "?#{p.join("&")}" if p.length!=0

    JSON.parse(RestClient.get(@@core+@token+"/"+api+params_s).body)
  end

  def post api, name, path, to, options={}
    JSON.parse(RestClient.post(@@core+@token+api, {name=>File.new(path,'rb'), :chat_id=>to.to_s}.merge(parse_hash(options))).body, object_class: OpenStruct)["result"]
  end

  def getUpdates options={"timeout"=>0, "limit"=>100}
    r=self.query "getUpdates", {"offset"=>@last_update.to_s}.merge(parse_hash(options))
    if r['ok']!=true then return nil end
    if r['result'][-1]!=nil then @last_update=r['result'][-1]['update_id']+1 end
    return r['result']
  end

  def getMe
    self.query("getMe")
  end

  def sendMessage to, text, options={}
    if options.has_key?"reply_markup" then
      options["reply_markup"]=options["reply_markup"].to_json
    end
    self.query("sendMessage", {"chat_id"=>to.to_s, "text"=>URI::encode(text)}.merge(parse_hash(options)))["result"]
  end

  def forwardMessage to, from, msg
    self.query("forwardMessage", {"chat_id"=>to, "from_chat_id"=>from, "message_id"=>msg})["result"]
  end

  def sendPhoto to, path, options={}
    self.post "/sendPhoto", :photo, path, to, options
  end

  def sendAudio to, path, options={}
    self.post "/sendAudio", :audio, path, to, options
  end

  # Send a general document (file, image, audio)
  # @param (see #sendPhoto)
  # @return (see #sendPhoto)
  def sendDocument to, path, options={}
    self.post "/sendDocument", :document, path, to, options
  end

  # Send a Sticker from File
  # @param (see #sendPhoto)
  # @return (see #sendSticker)
  def sendStickerFromFile to, path, options={}
    self.post "/sendSticker", :sticker, path, to, options
  end

  # Send a Sticker through its ID
  # @param to (see #sendPhoto)
  # @param id [Integer] the ID of the sticker to send
  # @param options (see #sendPhoto)
  # @return (see #sendPhoto)
  def sendSticker to, id, options={}
    JSON.parse(RestClient.post(@@core+@token+"/sendSticker", {:sticker=>id, :chat_id=>to.to_s}.merge(parse_hash(options))).body)["result"]
  end

  # Send a video file in mp4 format of max 50MB
  # @param (see #sendPhoto)
  # @return (see #sendPhoto)
  def sendVideo to, path, options={}
    self.post "/sendVideo", :video, path, to, options
  end
  
  # Send a location
  # @param to (see #sendPhoto)
  # @param lat [Float] Latitude
  # @param long [Float] Longitude
  # @param options (see #sendPhoto)
  # @return (see #sendPhoto)
  def sendLocation to, lat, long, options={}
    self.query("sendLocation", {"chat_id"=>to, "latitude"=>lat, "longitude"=>long}.merge(parse_hash(options)))["result"]
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
    self.query("getUserProfilePhotos", {"user_id"=>id}.merge(parse_hash(options)))["result"]
  end
  
  # Kick the user user_id from the chat chat_id
  # @param chat_id [Integer or String] ID of the chat, or @publicname
  # @param user_id [Integer] ID of the user to kick
  def kickChatMember chat_id, user_id
    self.query "kickChatMember", {"chat_id"=>chat_id, "user_id"=>user_id}
  end
  
  # Unban user_id from chat_id
  # see kickChatMember
  def unbanChatMember chat_id, user_id
    self.query "unbanChatMember", {"chat_id"=>chat_id, "user_id"=>user_id}
  end

  protected :query, :parse_hash, :post
end
