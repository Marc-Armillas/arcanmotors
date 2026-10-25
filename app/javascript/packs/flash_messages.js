document.addEventListener("turbolinks:load", function() {
  document.querySelectorAll(".flash-message").forEach(function(flashMessage) {
    setTimeout(() => {
      flashMessage.style.display = "none";
    }, 6000);
  });
});
