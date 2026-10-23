module CarsHelper
  STATUS_LABELS = { "on_sale" => "En venta", "sold" => "Vendido", "reserved" => "Reservado" }.freeze
  CONDITION_LABELS = { "km0" => "Km 0", "used" => "Ocasión" }.freeze
  GEARBOX_LABELS = { "manual" => "Manual", "automatic" => "Automático", "semi_automatic" => "Semiautomático" }.freeze
  TRANSMISSION_LABELS = { "front_wheel_drive" => "Delantera", "rear_wheel_drive" => "Trasera", "four_wheel_drive" => "Total" }.freeze
  FUEL_LABELS = {
    "diesel" => "Diésel", "petrol" => "Gasolina", "electric" => "Eléctrico", "hybrid_petrol" => "Híbrido gasolina",
    "hybrid_diesel" => "Híbrido diésel", "lpg" => "GLP", "cng" => "GNC", "other" => "Otro"
  }.freeze

  # Schema.org values for the vehicle JSON-LD
  SCHEMA_FUEL = { "diesel" => "Diesel", "petrol" => "Gasoline", "electric" => "Electric", "hybrid_petrol" => "Hybrid", "hybrid_diesel" => "Hybrid" }.freeze
  SCHEMA_GEARBOX = { "manual" => "ManualTransmission", "automatic" => "AutomaticTransmission", "semi_automatic" => "AutomaticTransmission" }.freeze

  def car_price(car)
    return "Consultar" if car.price.blank?

    number_to_currency(car.price, unit: "€", format: "%n %u", precision: 0, delimiter: ".", separator: ",")
  end

  def car_km(car)
    "#{number_with_delimiter(car.kilometers, delimiter: '.')} km" if car.kilometers
  end

  def car_status_label(car)
    STATUS_LABELS[car.status]
  end

  def car_image_url(image, size)
    variant = case size
    when :card then image.variant(resize_to_fill: [ 960, 720 ])
    when :gallery then image.variant(resize_to_limit: [ 1800, 1350 ])
    when :thumb then image.variant(resize_to_fill: [ 240, 180 ])
    when :og then image.variant(resize_to_fill: [ 1200, 630 ], format: :jpg)
    end
    url_for(variant)
  end

  def car_image_alt(car, index = 0)
    alt = "#{car.get_full_name} #{car.year}".strip
    index.zero? ? alt : "#{alt}, foto #{index + 1}"
  end

  # Ordered [label, value] pairs for the spec sheet, skipping empty fields
  def car_specs(car)
    [
      [ "Año", car.year ],
      [ "Kilómetros", car_km(car) ],
      [ "Potencia", car.cv.present? ? "#{car.cv} CV#{" (#{car.power} kW)" if car.power.present?}" : nil ],
      [ "Cambio", GEARBOX_LABELS[car.gearbox] ],
      [ "Tracción", TRANSMISSION_LABELS[car.transmission] ],
      [ "Combustible", FUEL_LABELS[car.fuel] ],
      [ "Cilindrada", car.cubic_capacity.present? ? "#{number_with_delimiter(car.cubic_capacity.to_i, delimiter: '.')} cc" : nil ],
      [ "Estado", CONDITION_LABELS[car.condition] ],
      [ "Primera matriculación", car.first_registration&.strftime("%m/%Y") ],
      [ "Propietarios anteriores", car.previous_owners ],
      [ "Color exterior", [ car.exterior_color, car.manufacturer_color_name ].compact_blank.uniq.join(", ").presence ],
      [ "Interior", [ car.interior_color, car.interior_material ].compact_blank.join(", ").presence ],
      [ "Puertas", car.doors ],
      [ "Plazas", car.seats ],
      [ "Consumo combinado", car.consumption_combined.present? ? "#{car.consumption_combined.to_s.sub('.', ',')} l/100 km" : nil ],
      [ "Categoría", car.category&.name ]
    ].select { |_, value| value.present? }
  end

  def car_whatsapp_url(car)
    whatsapp_url("Hola, me interesa el #{car.get_full_name} (#{car.year}): #{car_url(car)}")
  end

  def car_json_ld(car)
    data = {
      "@context": "https://schema.org",
      "@type": "Car",
      name: car.get_full_name,
      url: car_url(car),
      brand: { "@type": "Brand", name: car.make&.name },
      model: car.name,
      vehicleModelDate: car.year&.to_s,
      itemCondition: car.km0? ? "https://schema.org/NewCondition" : "https://schema.org/UsedCondition",
      image: car.images.first(5).map { |image| polymorphic_url(image.variant(resize_to_limit: [ 1800, 1350 ])) },
      description: (car.description.presence || car.model_description).to_s.squish.truncate(500),
      offers: {
        "@type": "Offer",
        price: car.price&.to_f,
        priceCurrency: "EUR",
        availability: car.sold? ? "https://schema.org/SoldOut" : "https://schema.org/InStock",
        url: car_url(car),
        seller: { "@type": "AutoDealer", name: SeoHelper::SITE_NAME, url: root_url }
      }
    }
    data[:mileageFromOdometer] = { "@type": "QuantitativeValue", value: car.kilometers, unitCode: "KMT" } if car.kilometers
    data[:fuelType] = SCHEMA_FUEL[car.fuel] if SCHEMA_FUEL[car.fuel]
    data[:vehicleTransmission] = SCHEMA_GEARBOX[car.gearbox] if SCHEMA_GEARBOX[car.gearbox]
    data[:color] = car.exterior_color if car.exterior_color.present?
    data[:numberOfPreviousOwners] = car.previous_owners if car.previous_owners
    data[:dateVehicleFirstRegistered] = car.first_registration.iso8601 if car.first_registration
    data[:vehicleIdentificationNumber] = car.vin if car.vin.present?
    if car.cv.present?
      data[:vehicleEngine] = { "@type": "EngineSpecification", enginePower: { "@type": "QuantitativeValue", value: car.cv, unitCode: "BHP" } }
    end
    json_ld_tag(data.compact)
  end
end
