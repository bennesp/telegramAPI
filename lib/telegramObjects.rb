class Update
  attr_accessor :update_id, :message
  def initialize json
    return if !json
    @update_id = json["update_id"]
    @message = Message.new json["message"]
  end
end

# Object describing a Bot or User
class User
  attr_accessor :id, :first_name, :last_name, :username
  def initialize json
    return if !json
    @id = json["id"]
    @first_name = json["first_name"]
    @last_name = json["last_name"]
    @username = json["username"]
  end
end

# Object describing a Chat Group
class GroupChat
  attr_accessor :id, :title
  def initialize json
    return if !json
    @id = json["id"]
    @title = json["title"]
  end
end

class ArrayOf
  attr_accessor :array, :type
  def initialize ar, cl
    return if !ar
    @array = []
    @type = cl
    ar.each do |e|
      @array<<cl.new(e)
    end
  end

  def to_a
    @array
  end
end

# Object describing a Message
class Message
  attr_accessor :message_id, :from, :date, :chat, :forward_from, :forward_date,
    :reply_to_message, :text, :audio, :document, :photo, :sticker, :video,
    :contact, :location, :new_chat_participant, :left_chat_participant,
    :new_chat_title, :new_chat_photo, :delete_chat_photo, :group_chat_create

  def initialize json
    return if !json
    @message_id = json["message_id"]
    @from = User.new json["from"]
    @date = json["date"]
    @chat = !json["chat"] ? nil : (json["chat"].has_key?("title") ? GroupChat.new(json["chat"]) : User.new(json["chat"]))
    @forward_from = User.new json["forward_from"]
    @forward_date = json["forward_date"]
    @reply_to_message = Message.new json["reply_to_message"]
    @text = json["text"]
    @audio = Audio.new json["audio"]
    @document = Document.new json["document"]
    @photo = ArrayOf.new(json["photo"], PhotoSize).to_a
    @sticker = Sticker.new json["sticker"]
    @video = Video.new json["video"]
    @contact = Contact.new json["contact"]
    @location = Location.new json["location"]
    @new_chat_participant = User.new json["new_chat_participant"]
    @left_chat_participant = User.new json["left_chat_participant"]
    @new_chat_title = json["new_chat_title"]
    @new_chat_photo = ArrayOf.new(json["new_chat_photo"],PhotoSize).to_a
    @delete_chat_photo = json["delete_chat_photo"]
    @group_chat_create = json["group_chat_create"]
  end
end

# Object Describing a Photo or Sticker
class PhotoSize
  attr_accessor :file_id, :width, :height, :file_size
  def initialize json
    return if !json
    @file_id = json["file_id"]
    @width = json["width"]
    @height = json["height"]
    @file_size = json["file_size"]
  end
end

class Audio
  attr_accessor :file_id, :duration, :mime_type, :file_size
  def initialize json
    return if !json
    @file_id = json["file_id"]
    @duration = json["duration"]
    @mime_type = json["mime_type"]
    @file_size = json["file_size"]
  end
end

class Document
  attr_accessor :file_id, :thumb, :file_name, :mime_type, :file_size
  def initialize json
    return if !json
    @file_id = json["file_id"]
    @thumb = PhotoSize.new json["thumb"]
    @file_name = json["file_name"]
    @mime_type = json["mime_type"]
    @file_size = json["file_size"]
  end
end

class Sticker
  attr_accessor :file_id, :width, :height, :thumb, :file_size
  def initialize json
    return if !json
    @file_id = json["file_id"]
    @width = json["width"]
    @height = json["height"]
    @thumb = PhotoSize.new json["thumb"]
    @file_size = json["file_size"]
  end
end

class Video
  attr_accessor :file_id, :width, :height, :duration, :thumb, :mime_type, :file_size, :caption
  def initialize json
    return if !json
    @file_id = json["file_id"]
    @width = json["width"]
    @height = json["height"]
    @duration = json["duration"]
    @thumb = PhotoSize.new json["thumb"]
    @mime_type = json["mime_type"]
    @file_size = json["file_size"]
    @caption = json["caption"]
  end
end

class Contact
  attr_accessor :phone_number, :first_name, :last_name, :user_id
  def initialize json
    return if !json
    @phone_number = json["phone_number"]
    @first_name = json["first_name"]
    @last_name = json["last_name"]
    @user_id = json["user_id"]
  end
end

class Location
  attr_accessor :latitude, :longitude
  def initialize json
    return if !json
    @latitute = json["latitude"]
    @longitude = json["longitude"]
  end
end

# Object describing a list of photos in up to 4 sizes each
class UserProfilePhotos
  attr_accessor :total_count, :photos
  def initialize json
    return if !json
    @total_count = json["total_count"]
    @photos = []
    json["photos"].each do |p|
      @photos<<ArrayOf.new(p).to_a
    end
  end
end

class ReplyKeyboardMarkup
  attr_accessor :keyboard, :resize_keyboard, :one_time_keyboard, :selective
  def initialize json
    return if !json
    @keyboard = json["keyboard"]
    @resize_keyboard = json["resize_keyboard"]
    @one_time_keyboard = json["one_time_keyboard"]
    @selective = json["selective"]
  end

  def to_json
    "{\"keyboard\":" + @keyboard.to_json  + ", \"resize_keyboard\":" + (!@resize_keyboard ? "false" : "true") + ", \"one_time_keyboard\":" + (!@one_time_keyboard ? "false" : "true") + ", \"selective\":" + (!@selective ? "false" : "true") + "}"
  end
end

class ReplyKeyboardHide
  attr_accessor :hide_keyboard, :selective
  def initialize json
    return if !json
    @hide_keyboard = json["hide_keyboard"]
    @selective = json["selective"]
  end

  def to_json
    "{\"hide_keyboard\":true, \"selective\":"+(!@selective ? "false" : "true")+"}"
  end
end

class ForceReply
  attr_accessor :force_reply, :selective
  def initialize json
    return if !json
    @force_reply = json["force_reply"]
    @selective = json["selective"]
  end

  def to_json
    "{\"force_reply\":true, \"selective\":"+(!@selective ? "false" : "true")+"}"
  end
end
