document.addEventListener("turbolinks:load", function() {
  const flashMessage = document.querySelector('.flash-message');
  if (flashMessage) {
    setTimeout(() => {
      flashMessage.style.display = 'none';
    }, 5000); // 5 seconds
  }
});
