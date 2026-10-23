document.addEventListener("turbolinks:load", function() {
  if (typeof Swiper === "undefined") return;

  document.querySelectorAll(".js-gallery").forEach(function(gallery) {
    const thumbsEl = gallery.querySelector(".js-gallery-thumbs");
    const thumbs = thumbsEl && new Swiper(thumbsEl, {
      slidesPerView: "auto",
      spaceBetween: 8,
      watchSlidesProgress: true,
    });

    new Swiper(gallery.querySelector(".js-gallery-main"), {
      loop: false,
      keyboard: { enabled: true },
      a11y: { prevSlideMessage: "Foto anterior", nextSlideMessage: "Foto siguiente" },
      pagination: { el: gallery.querySelector(".swiper-pagination"), type: "fraction" },
      navigation: {
        nextEl: gallery.querySelector(".swiper-button-next"),
        prevEl: gallery.querySelector(".swiper-button-prev"),
      },
      thumbs: thumbs ? { swiper: thumbs } : undefined,
    });
  });
});
