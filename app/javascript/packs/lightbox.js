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

    // Touch: a horizontal swipe changes photo; dragging down pulls the photo away and, past a threshold
    // (or with a quick flick), closes the viewer back to the car page. The first few pixels decide which.
    let touch = null;
    const resetDrag = (animate) => {
      image.style.transition = animate ? "transform 0.3s ease" : "";
      dialog.style.transition = animate ? "background-color 0.3s ease" : "";
      image.style.transform = "";
      dialog.style.backgroundColor = "";
      dialog.classList.remove("lightbox--dragging");
    };

    dialog.addEventListener("touchstart", (event) => {
      if (event.touches.length !== 1 || event.target.closest("button")) return;
      const point = event.touches[0];
      touch = { x: point.clientX, y: point.clientY, axis: null, dy: 0, samples: [{ dy: 0, t: performance.now() }] };
      resetDrag(false);
    }, { passive: true });

    dialog.addEventListener("touchmove", (event) => {
      if (!touch) return;
      const point = event.touches[0];
      const dx = point.clientX - touch.x;
      const dy = point.clientY - touch.y;
      if (!touch.axis && Math.hypot(dx, dy) > 10) touch.axis = Math.abs(dy) > Math.abs(dx) ? "y" : "x";
      if (touch.axis !== "y") return;

      event.preventDefault();
      dialog.classList.add("lightbox--dragging");
      touch.dy = Math.max(0, dy);
      touch.samples.push({ dy: touch.dy, t: performance.now() });
      if (touch.samples.length > 8) touch.samples.shift();
      const progress = Math.min(touch.dy / window.innerHeight, 1);
      image.style.transform = `translateY(${touch.dy}px) scale(${1 - progress * 0.25})`;
      dialog.style.backgroundColor = `rgba(8, 9, 8, ${0.97 * (1 - progress * 1.6)})`;
    }, { passive: false });

    dialog.addEventListener("touchend", (event) => {
      if (!touch) return;
      const { axis, dy, x, samples } = touch;
      touch = null;

      if (axis === "y") {
        // Speed over the last ~100 ms, so a slow hold followed by a quick flick still counts
        const now = performance.now();
        const recent = samples.filter((sample) => now - sample.t < 100);
        const from = recent[0] || samples[samples.length - 1];
        const speed = (dy - from.dy) / Math.max(now - from.t, 16);
        const flick = dy > 40 && speed > 0.5;
        if (dy > window.innerHeight * 0.18 || flick) {
          image.style.transition = "transform 0.25s ease-in";
          dialog.style.transition = "background-color 0.25s ease-in";
          image.style.transform = `translateY(${window.innerHeight}px) scale(0.75)`;
          dialog.style.backgroundColor = "rgba(8, 9, 8, 0)";
          setTimeout(() => { close(); resetDrag(false); }, 250);
        } else {
          resetDrag(true);
        }
        return;
      }

      const dx = event.changedTouches[0].clientX - x;
      if (axis === "x" && Math.abs(dx) > 50 && openers.length > 1) show(current + (dx < 0 ? 1 : -1));
    });

    dialog.addEventListener("touchcancel", () => { touch = null; resetDrag(true); });

    // Don't let Turbolinks cache the page with the viewer open
    document.addEventListener("turbolinks:before-cache", () => { if (dialog.open) close(); }, { once: true });
  });
});
