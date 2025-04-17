class MonstersController < ApplicationController
  def index
    # Base query
    @monsters = Monster.all
    
    # Apply filters if provided
    if params[:respawn_time].present?
      case params[:respawn_time].to_i
      when 60
        @monsters = @monsters.short_respawn
      when 150
        @monsters = @monsters.medium_respawn
      when 240
        @monsters = @monsters.long_respawn
      end
    end
    
    # Search by name, zone, or region
    if params[:search].present?
      @monsters = @monsters.search(params[:search])
    end
    
    # First sort by respawn time (60, 150, 240), then by level if possible
    @monsters = @monsters.order(:respawn_time)
    
    # To help with organization, add the level filter
    case params[:level_range]
    when "low"
      @monsters = @monsters.where("level ILIKE '%23%' OR level ILIKE '%38%' OR level ILIKE '%53%'")
    when "mid"
      @monsters = @monsters.where("level ILIKE '%68%' OR level ILIKE '%83%' OR level ILIKE '%98%' OR level ILIKE '%119%'")
    when "high"
      @monsters = @monsters.where("level ILIKE '%128%' OR level ILIKE '%143%' OR level ILIKE '%158%' OR level ILIKE '%173%'")
    when "max"
      @monsters = @monsters.where("level ILIKE '%203%'")
    end
    
    # Final sorting by name for consistent display
    @monsters = @monsters.order(:name)
  end

  def show
    @monster = Monster.find(params[:id])
    
    @tracked_monster = if current_user
      current_user.tracked_monsters.find_by(monster: @monster)
    else
      TrackedMonster.find_by(monster: @monster, anonymous_id: anonymous_id)
    end
  end
  
  def new
    @monster = Monster.new
  end
  
  def create
    # Only allow admin to create monsters
    unless current_user&.email == "admin@example.com"
      redirect_to monsters_path, alert: "Only admin can create new monsters"
      return
    end
    
    @monster = Monster.new(monster_params)
    
    if @monster.save
      redirect_to monsters_path, notice: "Monster was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def monster_params
    params.require(:monster).permit(:name, :respawn_time, :location, :status, :level, :zone, :region, :tips)
  end
end
