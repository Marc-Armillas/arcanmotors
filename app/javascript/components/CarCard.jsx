import React, { useState } from "react";
import PropTypes from "prop-types";

const CarCard = ({ car }) => {
  const [currentImageIndex, setCurrentImageIndex] = useState(0);

  const changeImage = (direction) => {
    const totalImages = car.images.length;
    let newIndex = currentImageIndex;

    if (direction === "next") {
      newIndex = (currentImageIndex + 1) % totalImages;
    } else if (direction === "prev") {
      newIndex = (currentImageIndex - 1 + totalImages) % totalImages;
    }

    setCurrentImageIndex(newIndex);
  };

  return (
    <div className="bg-white shadow-lg rounded-lg overflow-hidden">
      {/* Contenedor de las imágenes con flechas */}
      <div className="relative">
        {/* Imágenes del coche */}
        <div className="car-images" data-car-id={car.id}>
          {car.images.map((imageUrl, idx) => (
            <img
              key={idx}
              src={imageUrl}
              alt={car.name}
              className={`w-full h-48 object-cover car-image ${idx === currentImageIndex ? "" : "hidden"}`}
            />
          ))}
        </div>

        {/* Flecha izquierda */}
        <button
          className="absolute top-1/2 left-2 transform -translate-y-1/2 bg-gray-800 text-white p-2 rounded-full prev-btn"
          onClick={() => changeImage("prev")}
        >
          <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" />
          </svg>
        </button>

        {/* Flecha derecha */}
        <button
          className="absolute top-1/2 right-2 transform -translate-y-1/2 bg-gray-800 text-white p-2 rounded-full next-btn"
          onClick={() => changeImage("next")}
        >
          <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M9 5l7 7-7 7" />
          </svg>
        </button>
      </div>

      {/* Detalles del coche */}
      <div className="p-6">
        <h2 className="text-xl font-semibold text-gray-800">{car.name}</h2>
        <p className="text-gray-600 mt-2">
          Año: {car.year} | Kilómetros: {car.kilometers.toLocaleString()} km
        </p>
        <p className="text-gray-800 font-bold mt-2">Precio: {car.price.toLocaleString()} €</p>

        {/* Enlace para ver detalles */}
        <div className="mt-4">
          <a href={`/cars/${car.id}`} className="inline-block bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700">
            Ver Detalles
          </a>
        </div>
      </div>
    </div>
  );
};

CarCard.propTypes = {
  car: PropTypes.shape({
    id: PropTypes.number.isRequired,
    name: PropTypes.string.isRequired,
    year: PropTypes.number.isRequired,
    kilometers: PropTypes.number.isRequired,
    price: PropTypes.number.isRequired,
    images: PropTypes.arrayOf(PropTypes.string).isRequired, // Array de URLs de imágenes
  }).isRequired,
};

export default CarCard;
