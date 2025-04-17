class TrackedMonstersController < ApplicationController
  before_action :require_login
  before_action :set_tracked_monster, only: [:destroy, :reset_timer, :lost_track]
  
  def index
    @tracked_monsters = current_user.tracked_monsters.includes(:monster)
    @upcoming_monsters = @tracked_monsters.upcoming.order(:next_spawn_time)
    @spawned_monsters = @tracked_monsters.spawned.order(:next_spawn_time)
    
    # Check for monsters that are about to spawn (within 3 minutes)
    @notifiable_monsters = @tracked_monsters.notifiable
  end

  def create
    @monster = Monster.find(params[:monster_id])
    @tracked_monster = current_user.tracked_monsters.build(
      monster: @monster,
      next_spawn_time: Time.current + @monster.respawn_time.minutes
    )
    
    if @tracked_monster.save
      redirect_to tracked_monsters_path, notice: "Monster is now being tracked."
    else
      redirect_to monster_path(@monster), alert: "Failed to track monster."
    end
  end

  def destroy
    @tracked_monster.destroy
    redirect_to tracked_monsters_path, notice: "Monster is no longer being tracked."
  end

  def reset_timer
    @tracked_monster.reset_timer
    redirect_to tracked_monsters_path, notice: "Monster respawn timer has been reset."
  end
  
  def lost_track
    @tracked_monster.destroy
    redirect_to tracked_monsters_path, notice: "You've lost track of this monster."
  end
  
  private
  
  def set_tracked_monster
    @tracked_monster = current_user.tracked_monsters.find(params[:id])
  end
  
  def require_login
    unless current_user
      redirect_to new_user_path, alert: "You must sign in to track monsters."
    end
  end
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user
end
