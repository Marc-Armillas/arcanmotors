// Horizontal photo strip on the car page: buttons step one photo at a time, the counter follows the scroll
document.addEventListener("turbolinks:load", function() {
  document.querySelectorAll(".js-strip").forEach(function(strip) {
    const track = strip.querySelector(".strip__track");
    const prev = strip.querySelector(".js-strip-prev");
    const next = strip.querySelector(".js-strip-next");
    const counter = strip.querySelector(".js-strip-count");
    if (!track) return;

    const slides = Array.from(track.children);
    const current = () => {
      const left = track.scrollLeft + 1;
      let index = 0;
      slides.forEach((slide, i) => { if (slide.offsetLeft - track.offsetLeft <= left) index = i; });
      return index;
    };
    const go = (step) => {
      const target = slides[Math.min(slides.length - 1, Math.max(0, current() + step))];
      if (target) track.scrollTo({ left: target.offsetLeft - track.offsetLeft, behavior: "smooth" });
    };
    const update = () => {
      const index = current();
      if (counter) counter.textContent = `${index + 1} / ${slides.length}`;
      if (prev) prev.disabled = track.scrollLeft <= 2;
      if (next) next.disabled = track.scrollLeft + track.clientWidth >= track.scrollWidth - 2;
    };

    if (prev) prev.addEventListener("click", () => go(-1));
    if (next) next.addEventListener("click", () => go(1));
    track.addEventListener("scroll", update, { passive: true });
    track.addEventListener("keydown", (event) => {
      if (event.key === "ArrowRight") { event.preventDefault(); go(1); }
      if (event.key === "ArrowLeft") { event.preventDefault(); go(-1); }
    });
    update();
  });
});
