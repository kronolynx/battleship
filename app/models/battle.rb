class Battle < ActiveRecord::Base
  belongs_to :player, :foreign_key => :player_id, class_name: 'User'
  belongs_to :enemy, :foreign_key => :enemy_id, class_name: 'User'
  
  has_many :messages, dependent: :destroy
  
  validates_uniqueness_of :player_id, :scope => :enemy_id
  
  # check if player is involved in a battle
  scope :involving, -> (user) do
    where("battles.player_id =? OR battles.enemy_id =?",user.id,user.id)
  end

  # to check in the database if a battle between player_id and enemy_id exist
  scope :between, -> (player_id,enemy_id) do
    where("(battles.player_id = ? AND battles.enemy_id = ?) OR (battles.player_id = ? AND battles.enemy_id = ?)", player_id,enemy_id, enemy_id, player_id)
  end
end
