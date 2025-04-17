class ApplicationController < ActionController::Base
  helper_method :current_user, :anonymous_id, :chilean_time
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def anonymous_id
    session[:anonymous_id] ||= SecureRandom.uuid
  end
  
  # Helper method to get current time in Chilean time zone
  def chilean_time
    Time.current.in_time_zone('Santiago')
  end
end
