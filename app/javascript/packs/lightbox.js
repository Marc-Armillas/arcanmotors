// Full-screen photo viewer for the car page: opens on the clicked photo, arrows/keys/swipe move
// between photos (wrapping around), Esc, the close button or a click on the backdrop closes it.
document.addEventListener("turbolinks:load", function() {
  document.querySelectorAll(".js-lightbox").forEach(function(gallery) {
    const dialog = gallery.querySelector(".js-lightbox-dialog");
    const image = gallery.querySelector(".js-lightbox-image");
    const counter = gallery.querySelector(".js-lightbox-count");
    const openers = Array.from(gallery.querySelectorAll(".js-lightbox-open"));
    const track = gallery.querySelector(".strip__track");
    if (!dialog || !image || openers.length === 0 || typeof dialog.showModal !== "function") return;

    let current = 0;

    const preload = (index) => {
      const opener = openers[(index + openers.length) % openers.length];
      if (opener) new Image().src = opener.dataset.full;
    };

    const show = (index) => {
      current = (index + openers.length) % openers.length;
      const opener = openers[current];
      const thumb = opener.querySelector("img");
      image.src = opener.dataset.full;
      image.alt = thumb ? thumb.alt : "";
      if (counter) counter.textContent = `${current + 1} / ${openers.length}`;
      preload(current + 1);
      preload(current - 1);
    };

    const close = () => dialog.close();

    openers.forEach((opener, index) => {
      opener.addEventListener("click", () => {
        show(index);
        dialog.showModal();
        document.body.classList.add("menu-locked");
      });
    });

    dialog.addEventListener("close", () => {
      document.body.classList.remove("menu-locked");
      // Leave the strip on the photo the visitor was last looking at
      const slide = openers[current].closest(".strip__slide");
      if (track && slide) track.scrollTo({ left: slide.offsetLeft - track.offsetLeft });
    });

    const prev = gallery.querySelector(".js-lightbox-prev");
    const next = gallery.querySelector(".js-lightbox-next");
    if (prev) prev.addEventListener("click", () => show(current - 1));
    if (next) next.addEventListener("click", () => show(current + 1));
    gallery.querySelector(".js-lightbox-close").addEventListener("click", close);

    dialog.addEventListener("keydown", (event) => {
      if (event.key === "ArrowRight") { event.preventDefault(); show(current + 1); }
      if (event.key === "ArrowLeft") { event.preventDefault(); show(current - 1); }
    });

    // A click on the dark area around the photo (the dialog itself or its figure) closes the viewer
    dialog.addEventListener("click", (event) => {
      if (event.target === dialog || event.target.classList.contains("lightbox__figure")) close();
    });

    let touchX = null;
    dialog.addEventListener("touchstart", (event) => { touchX = event.touches[0].clientX; }, { passive: true });
    dialog.addEventListener("touchend", (event) => {
      if (touchX === null) return;
      const dx = event.changedTouches[0].clientX - touchX;
      if (Math.abs(dx) > 50 && openers.length > 1) show(current + (dx < 0 ? 1 : -1));
      touchX = null;
    });

    // Don't let Turbolinks cache the page with the viewer open
    document.addEventListener("turbolinks:before-cache", () => { if (dialog.open) close(); }, { once: true });
  });
});
