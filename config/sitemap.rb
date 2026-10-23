SitemapGenerator::Sitemap.default_host = "https://arcanmotors.es"

SitemapGenerator::Sitemap.create do
  add "/coches", changefreq: "daily", priority: 0.9
  add "/about_us", changefreq: "monthly", priority: 0.5

  Category.where(id: Car.published.select(:category_id)).find_each do |category|
    add cars_path(categoria: category.name.parameterize), changefreq: "daily", priority: 0.7
  end

  Car.published.with_attached_images.includes(:make).find_each do |car|
    add car_path(car), lastmod: car.updated_at, changefreq: "weekly", priority: 0.8
  end
end
