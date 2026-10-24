# Buying guides. The text of each guide lives in app/views/guides/articles/_<slug>.html.erb.
# Guides are created as drafts (published: false): only signed-in admins can see them and they stay out of
# the sitemap until someone who knows the cars has reviewed the content and flips the flag.
class Guide
  Entry = Struct.new(:slug, :title, :description, :model_line, :published, :updated_on, keyword_init: true)

  ALL = [
    Entry.new(slug: "que-revisar-al-comprar-un-porsche-de-ocasion",
              title: "Qué revisar al comprar un Porsche de ocasión",
              description: "Historial, kilómetros, mecánica, carrocería y papeles: la lista que usamos en el taller antes de comprar un Porsche.",
              model_line: nil, published: false, updated_on: Date.new(2026, 10, 24)),
    Entry.new(slug: "porsche-911-de-ocasion-como-elegir-generacion",
              title: "Porsche 911 de ocasión: cómo elegir generación",
              description: "Del 964 al 992: qué cambia entre generaciones del 911 y qué conviene mirar en cada una antes de comprar.",
              model_line: "911", published: false, updated_on: Date.new(2026, 10, 24)),
    Entry.new(slug: "macan-o-cayenne-cual-elegir",
              title: "Macan o Cayenne: cuál encaja contigo",
              description: "Tamaño, uso diario, versiones y qué revisar en cada SUV de Porsche de segunda mano.",
              model_line: "macan", published: false, updated_on: Date.new(2026, 10, 24))
  ].freeze

  def self.visible(admin: false)
    ALL.select { |guide| guide.published || admin }
  end

  def self.find(slug, admin: false)
    visible(admin: admin).find { |guide| guide.slug == slug }
  end

  def self.for_line(slug)
    ALL.select { |guide| guide.published && guide.model_line == slug }
  end
end
