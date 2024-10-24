SitemapGenerator::Sitemap.default_host = "https://arcanmotors.es"

SitemapGenerator::Sitemap.create do
  add "/cars", changefreq: "daily", priority: 0.9
  add "/about", changefreq: "monthly"
  add "/contact", changefreq: "monthly"

  Car.find_each { |car| add car_path(car), lastmod: car.updated_at, changefreq: "weekly", priority: 0.8 }
end
