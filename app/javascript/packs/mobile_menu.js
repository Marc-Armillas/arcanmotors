document.addEventListener("turbolinks:load", function() {
  const header = document.getElementById("site-header");
  const button = document.getElementById("mobile-menu-button");
  const drawer = document.getElementById("menu-drawer");
  if (!header || !button || !drawer) return;

  // Menu drawer slides in from the left, like a flyout navigation
  const setOpen = (open) => {
    button.setAttribute("aria-expanded", String(open));
    document.body.classList.toggle("menu-locked", open);
    if (open) {
      drawer.hidden = false;
      requestAnimationFrame(() => drawer.classList.add("is-open"));
      const firstLink = drawer.querySelector(".menu-drawer__link");
      if (firstLink) firstLink.focus();
    } else {
      drawer.classList.remove("is-open");
      setTimeout(() => { drawer.hidden = true; }, 300);
      button.focus();
    }
  };
  button.addEventListener("click", () => setOpen(true));
  drawer.querySelectorAll(".js-menu-close").forEach((el) => el.addEventListener("click", () => setOpen(false)));
  drawer.addEventListener("keydown", (event) => { if (event.key === "Escape") setOpen(false); });
  document.addEventListener("turbolinks:before-cache", () => { drawer.hidden = true; drawer.classList.remove("is-open"); document.body.classList.remove("menu-locked"); }, { once: true });

  // Over a hero photo the header starts transparent and turns solid once you scroll
  if (window.arcanHeaderScroll) window.removeEventListener("scroll", window.arcanHeaderScroll);
  window.arcanHeaderScroll = () => header.classList.toggle("is-scrolled", window.scrollY > 40);
  window.arcanHeaderScroll();
  window.addEventListener("scroll", window.arcanHeaderScroll, { passive: true });
});
