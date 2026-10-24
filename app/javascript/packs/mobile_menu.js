document.addEventListener("turbolinks:load", function() {
  const header = document.getElementById("site-header");
  const menuButton = document.getElementById("mobile-menu-button");
  if (!header || !menuButton) return;

  menuButton.addEventListener("click", function() {
    const open = menuButton.getAttribute("aria-expanded") === "true";
    menuButton.setAttribute("aria-expanded", String(!open));
    header.classList.toggle("sidebar--open", !open);
    document.body.classList.toggle("menu-locked", !open);
  });
});
