document.addEventListener("turbolinks:load", function() {
  let menuButton = document.getElementById("mobile-menu-button");
  let mobileMenu = document.getElementById("mobile-menu");

  if (menuButton && mobileMenu) {
    menuButton.addEventListener("click", function() {
      mobileMenu.classList.toggle("hidden");
    });
  } else {
    console.log("Using desktop layout");
  }
});
