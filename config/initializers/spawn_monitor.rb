# Start the monster spawn monitoring job when the application starts
# Only in production and development environments, not in test

Rails.application.config.after_initialize do
  if defined?(Rails::Server) && Rails.env.in?(%w[development production])
    # Give the server a moment to fully start before scheduling the job
    # This prevents issues during development reloads
    Rails.logger.info("Scheduling initial CheckSpawningMonstersJob...")
    CheckSpawningMonstersJob.set(wait: 1.minute).perform_later
  end
end