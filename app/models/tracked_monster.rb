class TrackedMonster < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :monster
  
  validates :next_spawn_time, presence: true
  validates :anonymous_id, presence: true, if: -> { user_id.blank? }
  validate :user_or_anonymous_id_present
  
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
  
  def seconds_until_spawn
    return 0 if next_spawn_time.nil? || next_spawn_time <= Time.current
    seconds_total = (next_spawn_time - Time.current).to_i
    seconds_total % 60
  end
  
  # Format the next spawn time in Santiago time zone
  def formatted_spawn_time
    next_spawn_time.in_time_zone('Santiago').strftime("%Y-%m-%d %H:%M:%S")
  end
  
  private
  
  def user_or_anonymous_id_present
    if user_id.blank? && anonymous_id.blank?
      errors.add(:base, "Either user or anonymous_id must be present")
    end
  end
end
