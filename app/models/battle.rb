class Battle < ActiveRecord::Base
  belongs_to :player, :foreign_key => :player_id, class_name: 'User'
  belongs_to :enemy, :foreign_key => :enemy_id, class_name: 'User'
  
  has_many :messages, dependent: :destroy
  
  validates_uniqueness_of :player_id, :scope => :enemy_id
end
