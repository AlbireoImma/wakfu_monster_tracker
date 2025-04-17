# Monster Tracker

A Rails application for tracking monsters with different respawn times. This application allows users to:

- Track monsters with specific respawn times (60, 150, or 240 minutes)
- Receive notifications 3 minutes before a monster respawns
- Reset timers for monsters
- Mark monsters as "lost track" when they can no longer be tracked

## Features

- No sign up required - track monsters anonymously using session storage
- Optional user registration for persistent tracking
- Monster listing with respawn times and locations
- Personal tracking of monsters
- Automated notifications for upcoming spawns
- Timer reset functionality
- Lost track functionality

## Technical Details

- Rails 7.1.5
- PostgreSQL database
- Background job for checking monster respawn times
- Browser notifications for monster respawns
- Anonymous tracking with session-based identifiers

## Setup

1. Clone the repository
```
git clone <repository_url>
cd monster_tracker
```

2. Install dependencies
```
bundle install
```

3. Set up the database
```
rails db:create db:migrate db:seed
```

4. Start the server
```
rails server
```

5. Visit `http://localhost:3000` in your browser

## User Types

- Anonymous users: Can track monsters without signing up
- Registered users: Can sign up for persistent tracking across sessions
- Admin: Can add new monsters (admin@example.com in seed data)

## Respawn Times

Monsters can have one of three respawn times:
- 60 minutes
- 150 minutes
- 240 minutes

## Monster Status

Monsters can be:
- Tracked: You are monitoring the monster's respawn timer
- Not tracked: You are not currently tracking this monster
- About to spawn: The monster will spawn in the next 3 minutes (notification will appear)

## Notifications

The application will automatically notify you 3 minutes before a monster respawns:
- In-app notifications on the tracking page
- Browser notifications (if permitted)

## Development

To run the background job locally:
```
rails jobs:work
```

## License

This project is licensed under the MIT License.
