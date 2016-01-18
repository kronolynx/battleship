class Message < ActiveRecord::Base
  belongs_to :battle
  belongs_to :user
  
  validates_presence_of :body, :conversation_id, :user_id
end
