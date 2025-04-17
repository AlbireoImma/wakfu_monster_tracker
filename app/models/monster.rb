class Monster < ApplicationRecord
  has_many :tracked_monsters
  has_many :users, through: :tracked_monsters
  
  validates :name, presence: true
  validates :respawn_time, presence: true, inclusion: { in: [60, 150, 240] }
  validates :location, presence: true
  
  enum status: { active: 'active', inactive: 'inactive' }, _default: 'active'
  
  # Scopes for filtering monsters by respawn time
  scope :short_respawn, -> { where(respawn_time: 60) }
  scope :medium_respawn, -> { where(respawn_time: 150) }
  scope :long_respawn, -> { where(respawn_time: 240) }
  
  # Simple ordering by respawn time and name
  scope :order_by_level, -> { order(:respawn_time, :name) }
  
  # Search by name, zone, or region (case-insensitive for PostgreSQL)
  scope :search, ->(query) {
    where("name ILIKE ? OR zone ILIKE ? OR region ILIKE ?", 
          "%#{query}%", "%#{query}%", "%#{query}%")
  }
  
  # Method to get minimum level from the level range
  def min_level
    return nil unless level.present?
    
    # Try to extract the first number from the range (e.g., "23-28" => 23)
    match = level.match(/^(\d+)/)
    match ? match[1].to_i : nil
  end
end
