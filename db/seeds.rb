require 'csv'

# Reset tables
puts "Cleaning database..."
TrackedMonster.destroy_all
Monster.destroy_all
User.destroy_all

# Create monsters from CSV
puts "Creating monsters from CSV file..."
csv_file_path = Rails.root.join('data.csv')

if File.exist?(csv_file_path)
  CSV.foreach(csv_file_path, headers: true) do |row|
    # Skip if any required field is missing
    next if row['Archmonster Name'].blank? || row['Respawn Time (Minutes)'].blank?
    
    respawn_time = row['Respawn Time (Minutes)'].to_i
    
    # Only accept respawn times of 60, 150, or 240 minutes
    next unless [60, 150, 240].include?(respawn_time)
    
    # Create the monster
    Monster.create!(
      name: row['Archmonster Name'],
      respawn_time: respawn_time,
      location: "#{row['Zone']}#{', ' + row['Region'] unless row['Region'].blank?}",
      status: "active",
      level: row['Level'],
      zone: row['Zone'],
      region: row['Region'],
      tips: row['Tips']
    )
    
    puts "Created #{row['Archmonster Name']} (#{respawn_time} min respawn)"
  end
  puts "CSV import completed."
else
  puts "CSV file not found at #{csv_file_path}!"
end

# Create admin user
puts "Creating admin user..."
admin = User.create!(email: "admin@example.com")

puts "Seed data created successfully!"
