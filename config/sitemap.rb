SitemapGenerator::Sitemap.default_host = "https://arcanmotors.es"

SitemapGenerator::Sitemap.create do
  add "/cars", changefreq: "daily", priority: 0.9
  add "/about", changefreq: "monthly"
  add "/contact", changefreq: "monthly"
  # Añade más rutas aquí
end
