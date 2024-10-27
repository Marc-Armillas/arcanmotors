document.addEventListener("turbolinks:load", function() {
  const swiper = new Swiper('.swiper', {
    direction: 'horizontal',
    loop: true,
    // effect: 'fade',

    pagination: {
      el: '.swiper-pagination',
      clickable: true,
    },

    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },

    scrollbar: {
      el: '.swiper-scrollbar',
      draggable: true,
    },
  });
});