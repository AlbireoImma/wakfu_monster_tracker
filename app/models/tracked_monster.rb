class TrackedMonster < ApplicationRecord
  belongs_to :user
  belongs_to :monster
  
  validates :next_spawn_time, presence: true
  
  scope :upcoming, -> { where("next_spawn_time > ?", Time.current) }
  scope :notifiable, -> { where("next_spawn_time BETWEEN ? AND ?", Time.current, 3.minutes.from_now) }
  scope :spawned, -> { where("next_spawn_time <= ?", Time.current) }
  
  def reset_timer
    update(next_spawn_time: Time.current + monster.respawn_time.minutes)
  end
  
  def lost_track
    destroy
  end
  
  def notifiable?
    next_spawn_time.present? && 
    next_spawn_time > Time.current && 
    next_spawn_time <= 3.minutes.from_now
  end
  
  def time_until_spawn
    return 0 if next_spawn_time.nil? || next_spawn_time <= Time.current
    ((next_spawn_time - Time.current) / 60).to_i
  end
end
