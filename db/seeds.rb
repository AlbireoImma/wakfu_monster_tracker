# Create default monsters with different respawn times

# Reset tables
puts "Cleaning database..."
TrackedMonster.destroy_all
Monster.destroy_all
User.destroy_all

# Create monsters
puts "Creating monsters..."

# 60-minute respawn monsters
Monster.create!(
  name: "Forest Troll",
  respawn_time: 60,
  location: "Western Forest - Near the old bridge",
  status: "active"
)

Monster.create!(
  name: "Cave Bat",
  respawn_time: 60,
  location: "Northern Caves - Entrance chamber",
  status: "active"
)

# 150-minute respawn monsters
Monster.create!(
  name: "Mountain Giant",
  respawn_time: 150,
  location: "Eastern Mountains - Summit peak",
  status: "active"
)

Monster.create!(
  name: "Swamp Beast",
  respawn_time: 150,
  location: "Southern Swamps - Deep in the marshes",
  status: "active"
)

# 240-minute respawn monsters
Monster.create!(
  name: "Ancient Dragon",
  respawn_time: 240,
  location: "Volcano Crater - Central island",
  status: "active"
)

Monster.create!(
  name: "Frost Wyrm",
  respawn_time: 240,
  location: "Frozen Peaks - Ice cavern",
  status: "active"
)

# Create admin user
puts "Creating admin user..."
admin = User.create!(email: "admin@example.com")

# Create a regular user
puts "Creating regular user..."
user = User.create!(email: "user@example.com")

# Track some monsters for testing
puts "Creating tracked monsters..."
TrackedMonster.create!(
  user: user,
  monster: Monster.find_by(name: "Forest Troll"),
  next_spawn_time: Time.current + 10.minutes
)

TrackedMonster.create!(
  user: user,
  monster: Monster.find_by(name: "Mountain Giant"),
  next_spawn_time: Time.current + 3.minutes
)

puts "Seed data created successfully!"
