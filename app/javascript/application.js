// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Skrypt do wyśrodkowania przycisku na zdjęciu
document.addEventListener("DOMContentLoaded", function() {
  const headerImage = document.querySelector(".header-image");
  const createTournamentButton = document.querySelector(".create-tournament-button");
  
  if (headerImage && createTournamentButton) {
    createTournamentButton.style.top = `${headerImage.clientHeight / 2}px`;
  }
});
