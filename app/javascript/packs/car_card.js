document.addEventListener("turbolinks:load", function() {
  function changeImage(carId, direction) {
    const images = document.querySelectorAll(`.car-images[data-car-id='${carId}'] .car-image`);
    let currentIndex = Array.from(images).findIndex(image => !image.classList.contains('hidden'));

    images[currentIndex].classList.add('hidden');
    if (direction === 'next') {
      currentIndex = (currentIndex + 1) % images.length;
    } else {
      currentIndex = (currentIndex - 1 + images.length) % images.length;
    }
    images[currentIndex].classList.remove('hidden');
  }

  document.querySelectorAll('.next-btn').forEach(button => {
    button.addEventListener('click', () => {
      const carId = button.getAttribute('data-car-id');
      changeImage(carId, 'next');
    });
  });

  document.querySelectorAll('.prev-btn').forEach(button => {
    button.addEventListener('click', () => {
      const carId = button.getAttribute('data-car-id');
      changeImage(carId, 'prev');
    });
  });
});
