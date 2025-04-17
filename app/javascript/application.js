// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Monster Tracker specific JavaScript
document.addEventListener("turbo:load", function() {
  // Check for notifications every minute (when user is on the page)
  if (document.body.classList.contains('logged-in')) {
    checkForNotifications();
    setInterval(checkForNotifications, 60000); // Every minute
  }
});

function checkForNotifications() {
  fetch('/notifications.json')
    .then(response => response.json())
    .then(data => {
      if (data.length > 0) {
        showNotification(data);
      }
    })
    .catch(error => console.error('Error checking notifications:', error));
}

function showNotification(monsters) {
  // Only show if browser notifications are supported and permitted
  if (!("Notification" in window)) {
    console.log("This browser does not support desktop notifications");
    return;
  }
  
  if (Notification.permission === "granted") {
    monsters.forEach(monster => {
      const message = `${monster.monster_name} will spawn in ${monster.minutes_remaining} minutes at ${monster.location}`;
      new Notification("Monster Spawning Soon!", { body: message });
    });
  } else if (Notification.permission !== "denied") {
    Notification.requestPermission().then(permission => {
      if (permission === "granted") {
        showNotification(monsters);
      }
    });
  }
}
