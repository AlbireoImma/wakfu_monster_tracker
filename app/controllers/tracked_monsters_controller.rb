class TrackedMonstersController < ApplicationController
  before_action :set_tracked_monster, only: [:destroy, :reset_timer, :lost_track]
  
  def index
    @tracked_monsters = tracked_monsters_scope.includes(:monster)
    @upcoming_monsters = @tracked_monsters.upcoming.order(:next_spawn_time)
    @spawned_monsters = @tracked_monsters.spawned.order(:next_spawn_time)
    
    # Check for monsters that are about to spawn (within 3 minutes)
    @notifiable_monsters = @tracked_monsters.notifiable
  end

  def create
    @monster = Monster.find(params[:monster_id])
    
    @tracked_monster = if current_user
      current_user.tracked_monsters.build(
        monster: @monster,
        next_spawn_time: Time.current + @monster.respawn_time.minutes
      )
    else
      TrackedMonster.new(
        monster: @monster,
        next_spawn_time: Time.current + @monster.respawn_time.minutes,
        anonymous_id: anonymous_id
      )
    end
    
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
    @tracked_monster = tracked_monsters_scope.find(params[:id])
  end
  
  def tracked_monsters_scope
    if current_user
      current_user.tracked_monsters
    else
      TrackedMonster.where(anonymous_id: anonymous_id)
    end
  end
end
