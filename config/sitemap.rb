SitemapGenerator::Sitemap.default_host = "https://arcanmotors.es"

SitemapGenerator::Sitemap.create do
  add "/coches", changefreq: "daily", priority: 0.9
  add "/about_us", changefreq: "monthly", priority: 0.5

  ModelLine::LINES.each do |line|
    add model_line_path(slug: line.slug), changefreq: "daily", priority: 0.8
  end

  Guide.visible.each do |guide|
    add guide_path(slug: guide.slug), lastmod: guide.updated_on, changefreq: "monthly", priority: 0.6
  end

  Car.published.with_attached_images.includes(:make).find_each do |car|
    add car_path(car), lastmod: car.updated_at, changefreq: "weekly", priority: 0.8
  end
end
