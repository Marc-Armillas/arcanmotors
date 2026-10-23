document.addEventListener("turbolinks:load", function() {
  document.querySelectorAll(".js-rail").forEach(function(section) {
    const track = section.querySelector(".rail");
    const prev = section.querySelector(".js-rail-prev");
    const next = section.querySelector(".js-rail-next");
    if (!track || !prev || !next) return;

    const step = () => (track.firstElementChild ? track.firstElementChild.getBoundingClientRect().width + 20 : 400);
    const update = () => {
      prev.disabled = track.scrollLeft <= 4;
      next.disabled = track.scrollLeft + track.clientWidth >= track.scrollWidth - 4;
    };

    prev.addEventListener("click", () => track.scrollBy({ left: -step() }));
    next.addEventListener("click", () => track.scrollBy({ left: step() }));
    track.addEventListener("scroll", update, { passive: true });
    update();
  });
});
