module SeoHelper
  SITE_NAME = "ArCan Motors".freeze
  CANONICAL_HOST = "https://arcanmotors.es".freeze
  DEFAULT_TITLE = "ArCan Motors | Porsche de ocasión revisados en taller".freeze
  DEFAULT_DESCRIPTION = "Especialistas en Porsche de ocasión: 911, Cayman, Boxster, Macan, Cayenne y Panamera " \
                        "seleccionados y revisados en nuestro taller. Consulta el stock y pregunta por WhatsApp.".freeze

  # Called from views: <% seo title: "...", description: "...", image: url, noindex: true %>
  def seo(title: nil, description: nil, image: nil, canonical: nil, noindex: false, type: nil)
    content_for(:seo_title, title) if title
    content_for(:seo_description, description) if description
    content_for(:seo_image, image) if image
    content_for(:seo_canonical, canonical) if canonical
    content_for(:seo_robots, "noindex, follow") if noindex
    content_for(:seo_type, type) if type
  end

  def seo_title
    content_for?(:seo_title) ? "#{content_for(:seo_title)} | #{SITE_NAME}" : DEFAULT_TITLE
  end

  def seo_description
    (content_for?(:seo_description) ? content_for(:seo_description) : DEFAULT_DESCRIPTION).to_s.squish.truncate(160)
  end

  def seo_canonical
    content_for?(:seo_canonical) ? content_for(:seo_canonical) : "#{site_base_url}#{request.path}"
  end

  def seo_image
    content_for?(:seo_image) ? content_for(:seo_image) : default_share_image
  end

  def default_share_image
    "#{site_base_url}#{image_path('hero_911_niebla.jpg')}"
  end

  def site_base_url
    Rails.env.production? ? CANONICAL_HOST : request.base_url
  end

  def json_ld_tag(data)
    tag.script(json_escape(data.to_json).html_safe, type: "application/ld+json")
  end

  def organization_json_ld
    data = {
      "@context": "https://schema.org",
      "@type": "AutoDealer",
      "@id": "#{site_base_url}/#dealer",
      name: SITE_NAME,
      url: "#{site_base_url}/",
      image: default_share_image,
      description: DEFAULT_DESCRIPTION,
      email: "info@arcanemotors.com",
      telephone: whatsapp_phone.present? ? "+#{whatsapp_phone}" : nil,
      address: { "@type": "PostalAddress", addressRegion: "Cataluña", addressCountry: "ES" },
      brand: { "@type": "Brand", name: "Porsche" }
    }
    json_ld_tag(data.compact)
  end

  def breadcrumbs_json_ld(items)
    json_ld_tag(
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      itemListElement: items.each_with_index.map do |(name, url), index|
        { "@type": "ListItem", position: index + 1, name: name, item: url }
      end
    )
  end

  # Umami counts clicks on elements carrying data-umami-event; each data-umami-event-* attribute becomes
  # an event property, so the dashboard shows contacts by channel, place on the site and car.
  def track_contact(channel, place, car = nil)
    attributes = { "data-umami-event" => channel, "data-umami-event-lugar" => place }
    attributes["data-umami-event-coche"] = car.get_full_name if car
    tag.attributes(attributes)
  end

  def whatsapp_phone
    Rails.application.credentials.dig(:whatsapp, :phone_number).to_s.delete("^0-9")
  end

  def whatsapp_url(text = nil)
    url = "https://wa.me/#{whatsapp_phone}"
    text ? "#{url}?text=#{ERB::Util.url_encode(text)}" : url
  end

  # "34612345678" -> "+34 612 345 678"
  def whatsapp_phone_display
    phone = whatsapp_phone
    return phone if phone.blank?

    local = phone.delete_prefix("34")
    "+34 #{local.scan(/\d{1,3}/).join(' ')}"
  end
end
