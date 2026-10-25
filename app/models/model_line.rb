# A Porsche model range (911, 718, Macan...) with its own landing page. Cars are matched to a range from
# their "Modelo" field and name, so no extra data entry is needed in the admin.
class ModelLine
  Line = Struct.new(:slug, :name, :pattern, :tagline, :intro, keyword_init: true)

  LINES = [
    Line.new(slug: "911", name: "911", pattern: "\\m911\\M|\\m9[69]\\d\\M", # 911 or a generation code: 964, 993, 996, 997, 991, 992
             tagline: "El deportivo de motor trasero, desde 1963.",
             intro: "El 911 es el Porsche por excelencia: motor bóxer trasero, 2+2 plazas en la mayoría de versiones y una evolución continua desde 1963. " \
                    "En el mercado de ocasión conviven generaciones muy distintas, de los clásicos refrigerados por aire a los 992 actuales, " \
                    "así que el historial de mantenimiento y el estado real de cada unidad pesan tanto como el año o los kilómetros."),
    Line.new(slug: "718", name: "718 Cayman y Boxster", pattern: "\\m718\\M|cayman|boxster",
             tagline: "Motor central, biplaza, coupé o descapotable.",
             intro: "Cayman (coupé) y Boxster (descapotable) comparten plataforma de motor central y son biplazas. " \
                    "Son la forma más directa de conducir un Porsche, y en ocasión ofrecen una relación entre prestaciones y precio difícil de igualar."),
    Line.new(slug: "macan", name: "Macan", pattern: "macan",
             tagline: "El SUV compacto de Porsche.",
             intro: "El Macan es el SUV compacto de Porsche, a la venta desde 2014. Combina tracción total y comportamiento deportivo " \
                    "con el espacio de un coche familiar, y es una de las puertas de entrada más habituales a la marca."),
    Line.new(slug: "cayenne", name: "Cayenne", pattern: "cayenne",
             tagline: "El SUV grande, en versión SUV o Coupé.",
             intro: "El Cayenne, presente desde 2002, es el SUV grande de Porsche. Hay versiones de gasolina e híbridas enchufables, " \
                    "y desde 2019 también carrocería Coupé. Es el Porsche para viajar y para el día a día con cinco plazas."),
    Line.new(slug: "panamera", name: "Panamera", pattern: "panamera",
             tagline: "La berlina de cuatro puertas.",
             intro: "El Panamera, lanzado en 2009, lleva el carácter de Porsche a una berlina de cuatro puertas, con versiones Sport Turismo " \
                    "e híbridas enchufables. Es una alternativa deportiva a las grandes berlinas de lujo."),
    Line.new(slug: "taycan", name: "Taycan", pattern: "taycan",
             tagline: "El Porsche eléctrico.",
             intro: "El Taycan, a la venta desde 2019, es el primer Porsche 100 % eléctrico, en carrocerías berlina, Sport Turismo y Cross Turismo. " \
                    "En ocasión conviene revisar el estado de la batería y la garantía que le queda.")
  ].freeze

  SLUGS = LINES.map(&:slug).freeze

  def self.find(slug)
    LINES.find { |line| line.slug == slug }
  end

  def self.for(car)
    text = "#{car.model} #{car.name}"
    LINES.find { |line| Regexp.new(line.pattern.gsub("\\m", "\\b").gsub("\\M", "\\b"), Regexp::IGNORECASE).match?(text) }
  end

  # Postgres regex (\m and \M are word boundaries) over the "Modelo" field and the car name
  def self.cars(line, scope = Car.all)
    scope.where("concat_ws(' ', cars.model, cars.name) ~* ?", line.pattern)
  end

  # Ranges with at least one car in the given scope, in catalogue order
  def self.with_stock(scope = Car.published)
    LINES.select { |line| cars(line, scope).exists? }
  end
end
