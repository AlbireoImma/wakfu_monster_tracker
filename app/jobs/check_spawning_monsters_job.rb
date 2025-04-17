class CheckSpawningMonstersJob < ApplicationJob
  queue_as :default

  def perform
    # Find all monsters that will spawn in the next 3 minutes
    notifiable_monsters = TrackedMonster.notifiable.includes(:monster, :user)
    
    # In a real application, we would send actual notifications here
    # (email, push notifications, etc.)
    notifiable_monsters.each do |tracked|
      log_notification(tracked)
      
      # Here you would send notifications via email, push, etc.
      # Example:
      # NotificationMailer.monster_spawning_soon(tracked).deliver_now
      # or
      # send_push_notification(tracked)
    end
    
    # Re-schedule the job to run again in 1 minute
    CheckSpawningMonstersJob.set(wait: 1.minute).perform_later
  end
  
  private
  
  def log_notification(tracked)
    Rails.logger.info(
      "NOTIFICATION: Monster #{tracked.monster.name} will spawn in #{tracked.time_until_spawn} minutes " +
      "at #{tracked.monster.location}. User: #{tracked.user.email}"
    )
  end
  
  # Example push notification method (not implemented)
  def send_push_notification(tracked)
    # This would interface with a push notification service
    # Like Firebase Cloud Messaging, OneSignal, etc.
  end
end
