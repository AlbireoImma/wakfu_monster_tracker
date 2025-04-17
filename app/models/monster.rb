class Monster < ApplicationRecord
  has_many :tracked_monsters
  has_many :users, through: :tracked_monsters
  
  validates :name, presence: true
  validates :respawn_time, presence: true, inclusion: { in: [60, 150, 240] }
  validates :location, presence: true
  
  enum status: { active: 'active', inactive: 'inactive' }, _default: 'active'
end
