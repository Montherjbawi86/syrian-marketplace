// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
// إذا كنت تستخدم Turbo (Rails 7)
document.addEventListener('turbo:load', function() {
  // يمكنك إضافة كود هنا إذا لزم الأمر
});

// أو إذا كنت تستخدم jQuery
$(document).on('click', '.favorite-btn', function(e) {
  e.preventDefault();
  e.stopPropagation();
});
// app/javascript/application.js
document.addEventListener('click', function(e) {
  const button = e.target.closest('[data-confirm]');
  if (button && !confirm(button.dataset.confirm)) {
    e.preventDefault();
    e.stopPropagation();
  }
});
