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
  
  // Initialize all countdown timers
  initializeCountdownTimers();
  
  // Initialize Chilean time clock
  initializeChileanClock();
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

// Handle all countdown timers on the page
function initializeCountdownTimers() {
  const countdownElements = document.querySelectorAll('.countdown-timer');
  
  // No countdowns on this page
  if (countdownElements.length === 0) return;
  
  // Initialize each countdown
  countdownElements.forEach(element => {
    const minutesRemaining = parseInt(element.getAttribute('data-minutes'), 10) || 0;
    const secondsRemaining = parseInt(element.getAttribute('data-seconds'), 10) || 0;
    
    // Total seconds for countdown
    let totalSeconds = (minutesRemaining * 60) + secondsRemaining;
    
    // Initial display
    updateTimerDisplay(element, totalSeconds);
    
    // Setup interval for this specific timer
    const timerId = setInterval(() => {
      // Decrement and update
      totalSeconds--;
      
      if (totalSeconds <= 0) {
        // Timer complete
        clearInterval(timerId);
        element.textContent = "00:00";
        element.classList.add('time-elapsed');
        
        // Optionally reload the page when a timer completes
        if (element.hasAttribute('data-reload-on-complete')) {
          setTimeout(() => window.location.reload(), 1000);
        }
      } else {
        // Update display
        updateTimerDisplay(element, totalSeconds);
      }
    }, 1000);
    
    // Store the timer ID with the element
    element.dataset.timerId = timerId;
  });
}

function updateTimerDisplay(element, totalSeconds) {
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  
  // Format as MM:SS with leading zeros
  const displayText = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  element.textContent = displayText;
  
  // Update classes based on time remaining
  if (totalSeconds <= 180) { // 3 minutes or less
    element.classList.add('time-soon');
  } else {
    element.classList.remove('time-soon');
  }
}

// Initialize and update Chilean clock
function initializeChileanClock() {
  const clockTimeElement = document.getElementById('clock-time');
  const clockDateElement = document.getElementById('clock-date');
  
  if (!clockTimeElement || !clockDateElement) return;
  
  // Function to update the clock
  function updateClock() {
    // Create a date object for Santiago, Chile time zone
    const options = { 
      timeZone: 'America/Santiago', 
      hour: '2-digit', 
      minute: '2-digit', 
      second: '2-digit',
      hour12: false 
    };
    
    const dateOptions = { 
      timeZone: 'America/Santiago', 
      year: 'numeric', 
      month: 'short', 
      day: 'numeric',
      weekday: 'short'
    };
    
    const now = new Date();
    const timeString = now.toLocaleTimeString('es-CL', options);
    const dateString = now.toLocaleDateString('es-CL', dateOptions);
    
    // Update the clock elements
    clockTimeElement.textContent = timeString;
    clockDateElement.textContent = dateString;
  }
  
  // Update immediately and then every second
  updateClock();
  setInterval(updateClock, 1000);
}
