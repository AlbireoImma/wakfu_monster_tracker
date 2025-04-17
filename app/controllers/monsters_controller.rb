class MonstersController < ApplicationController
  def index
    @monsters = Monster.all
  end

  def show
    @monster = Monster.find(params[:id])
    @tracked_monster = current_user&.tracked_monsters&.find_by(monster: @monster)
  end
  
  def new
    @monster = Monster.new
  end
  
  def create
    @monster = Monster.new(monster_params)
    
    if @monster.save
      redirect_to monsters_path, notice: "Monster was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  private
  
  def monster_params
    params.require(:monster).permit(:name, :respawn_time, :location, :status)
  end
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user
end
