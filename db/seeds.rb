if Country.find_by(code: 'AT').blank?
  # Create Countries
  {
    "AT" => "Austria ",
    "BE" => "Belgium",
    "BG" => "Bulgaria ",
    "HR" => "Croatia",
    "CY" => "Cyprus ",
    "CZ" => "Czech Republic",
    "DK" => "Denmark ",
    "EE" => "Estonia",
    "FI" => "Finland ",
    "FR" => "France",
    "DE" => "Germany ",
    "GR" => "Greece",
    "HU" => "Hungary ",
    "IE " => "Ireland, Republic of (EIRE)",
    "IT" => "Italy ",
    "LV" => "Latvia",
    "LT" => "Lithuania ",
    "LU" => "Luxembourg",
    "MT" => "Malta ",
    "NL" => "Netherlands",
    "PL" => "Poland ",
    "PT" => "Portugal",
    "RO" => "Romania ",
    "SK" => "Slovakia",
    "SI" => "Slovenia ",
    "ES" => "Spain",
    "SE" => "Sweden "
  }.each { |code, name| Country.create(code: code, name: name, is_eu: true) }

  {
    "GB" => "United Kingdom (Great Britain)",
    "JP" => "Japan",
    "KR" => "South Korea",
    "CN" => "China",
    "IN" => "India",
    "US" => "United States",
  }.each { |code, name| Country.create(code: code, name: name, is_eu: false) }

  # Create Makes
  {
   "Audi" => Country.find_by(code: 'DE').id,
   "BMW" => Country.find_by(code: 'DE').id,
   "Mercedes-Benz" => Country.find_by(code: 'DE').id,
   "Volkswagen" => Country.find_by(code: 'DE').id,
   "Porsche" => Country.find_by(code: 'DE').id,
   "Opel" => Country.find_by(code: 'DE').id,
   "Ferrari" => Country.find_by(code: 'IT').id,
   "Lamborghini" => Country.find_by(code: 'IT').id,
   "Maserati" => Country.find_by(code: 'IT').id,
   "Fiat" => Country.find_by(code: 'IT').id,
   "Peugeot" => Country.find_by(code: 'FR').id,
   "Citroën" => Country.find_by(code: 'FR').id,
   "Renault" => Country.find_by(code: 'FR').id,
   "DS Automobiles" => Country.find_by(code: 'FR').id,
   "Bugatti" => Country.find_by(code: 'FR').id,
   "Rolls-Royce" => Country.find_by(code: 'GB').id,
   "Bentley" => Country.find_by(code: 'GB').id,
   "McLaren" => Country.find_by(code: 'GB').id,
   "Aston Martin" => Country.find_by(code: 'GB').id,
   "Jaguar" => Country.find_by(code: 'GB').id,
   "Land Rover" => Country.find_by(code: 'GB').id,
   "Volvo" => Country.find_by(code: 'SE').id,
   "Saab" => Country.find_by(code: 'SE').id,
   "Skoda" => Country.find_by(code: 'CZ').id,
   "Seat" => Country.find_by(code: 'ES').id,
   "Dacia" => Country.find_by(code: 'RO').id,
   "Alfa Romeo" => Country.find_by(code: 'IT').id,
   "Lancia" => Country.find_by(code: 'IT').id,
   "Lotus" => Country.find_by(code: 'GB').id,
   "Smart" => Country.find_by(code: 'DE').id,
   "Koenigsegg" => Country.find_by(code: 'SE').id,
   "Pagani" => Country.find_by(code: 'IT').id,
   "Rimac" => Country.find_by(code: 'HR').id,

   "Toyota" => Country.find_by(code: 'JP').id,
   "Nissan" => Country.find_by(code: 'JP').id,
   "Honda" => Country.find_by(code: 'JP').id,
   "Mazda" => Country.find_by(code: 'JP').id,
   "Subaru" => Country.find_by(code: 'JP').id,
   "Suzuki" => Country.find_by(code: 'JP').id,
   "Mitsubishi" => Country.find_by(code: 'JP').id,
   "Lexus" => Country.find_by(code: 'JP').id,
   "Infiniti" => Country.find_by(code: 'JP').id,
   "Acura" => Country.find_by(code: 'JP').id,

   "Hyundai" => Country.find_by(code: 'KR').id,
   "Kia" => Country.find_by(code: 'KR').id,
   "Genesis" => Country.find_by(code: 'KR').id,

   "Ford" => Country.find_by(code: 'US').id,
   "Chevrolet" => Country.find_by(code: 'US').id,
   "Cadillac" => Country.find_by(code: 'US').id,
   "Tesla" => Country.find_by(code: 'US').id,
   "Dodge" => Country.find_by(code: 'US').id,
   "Jeep" => Country.find_by(code: 'US').id,
   "Chrysler" => Country.find_by(code: 'US').id,
   "Buick" => Country.find_by(code: 'US').id,
   "Lincoln" => Country.find_by(code: 'US').id,
   "GMC" => Country.find_by(code: 'US').id,
   "Fisker" => Country.find_by(code: 'US').id,

   "Geely" => Country.find_by(code: 'CN').id,
   "BYD" => Country.find_by(code: 'CN').id,
   "NIO" => Country.find_by(code: 'CN').id,
   "XPeng" => Country.find_by(code: 'CN').id,
   "Great Wall" => Country.find_by(code: 'CN').id,
   "Chery" => Country.find_by(code: 'CN').id,

   "Tata" => Country.find_by(code: 'IN').id,
   "Mahindra" => Country.find_by(code: 'IN').id,
  }.each { |make, country_id| Make.create(name: make, country_id: country_id) }

  # Create Categories
  %w[SmallCar SUV EstateCar Saloon Cabrio Sedan Convertible Coupe Van Pickup OffRoad Other].each do |name|
    Category.create(name: name)
  end

  if Rails.env.development?
    User.create(email: 'test@gmail.com', password: '123undostres', role: 1)
  end

  EmissionSticker.all.each do |s|
    image_path = "tmp/emission_imgs/#{s.name}.jpg"

    s.image.attach(
      io: File.open(image_path),
      filename: "#{s.name.downcase.gsub(' ', '_')}.jpg",
      content_type: 'image/jpeg'
    )
  end
end
