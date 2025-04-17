class NotificationsController < ApplicationController
  def index
    if current_user
      @notifiable_monsters = current_user.tracked_monsters.notifiable.includes(:monster)
    else
      @notifiable_monsters = TrackedMonster.where(anonymous_id: anonymous_id).notifiable.includes(:monster)
    end
    
    respond_to do |format|
      format.html
      format.json { render json: @notifiable_monsters.map { |tm| notification_data(tm) } }
    end
  end
  
  private
  
  def notification_data(tracked_monster)
    {
      id: tracked_monster.id,
      monster_name: tracked_monster.monster.name,
      location: tracked_monster.monster.location,
      next_spawn_time: tracked_monster.next_spawn_time,
      minutes_remaining: tracked_monster.time_until_spawn,
      seconds_remaining: tracked_monster.seconds_until_spawn
    }
  end
end
