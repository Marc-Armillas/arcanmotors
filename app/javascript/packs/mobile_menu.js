document.addEventListener("turbolinks:load", function() {
  const header = document.getElementById("site-header");
  const menuButton = document.getElementById("mobile-menu-button");
  const mobileMenu = document.getElementById("mobile-menu");

  if (menuButton && mobileMenu) {
    menuButton.addEventListener("click", function() {
      const open = menuButton.getAttribute("aria-expanded") === "true";
      menuButton.setAttribute("aria-expanded", String(!open));
      mobileMenu.hidden = open;
      if (header) header.classList.toggle("site-header--menu-open", !open);
    });
  }

  // The home header sits transparent over the hero photo and turns solid once you scroll past it
  // Turbolinks keeps window alive between pages, so drop the previous page's listener first
  if (window.arcanHeaderScroll) window.removeEventListener("scroll", window.arcanHeaderScroll);
  window.arcanHeaderScroll = null;
  if (header && header.classList.contains("site-header--overlay")) {
    window.arcanHeaderScroll = () => header.classList.toggle("is-scrolled", window.scrollY > 40);
    window.arcanHeaderScroll();
    window.addEventListener("scroll", window.arcanHeaderScroll, { passive: true });
  }
});
