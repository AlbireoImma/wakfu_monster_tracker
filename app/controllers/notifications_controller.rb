class NotificationsController < ApplicationController
  before_action :require_login
  
  def index
    @notifiable_monsters = current_user.tracked_monsters.notifiable.includes(:monster)
    
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
      minutes_remaining: tracked_monster.time_until_spawn
    }
  end
  
  def require_login
    unless current_user
      redirect_to new_user_path, alert: "You must sign in to view notifications."
    end
  end
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user
end
