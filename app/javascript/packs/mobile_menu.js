document.addEventListener("turbolinks:load", function() {
  const menuButton = document.getElementById("mobile-menu-button");
  const mobileMenu = document.getElementById("mobile-menu");
  if (!menuButton || !mobileMenu) return;

  menuButton.addEventListener("click", function() {
    const open = menuButton.getAttribute("aria-expanded") === "true";
    menuButton.setAttribute("aria-expanded", String(!open));
    mobileMenu.hidden = open;
    const header = document.getElementById("site-header");
    if (header) header.classList.toggle("site-header--menu-open", !open);
  });
});
