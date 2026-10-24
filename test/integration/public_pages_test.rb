require "test_helper"

class PublicPagesTest < ActionDispatch::IntegrationTest
  test "home shows published featured cars and hides sold or hidden ones" do
    get root_path
    assert_response :success
    assert_select "h1", /Porsche/
    assert_select ".car-card__title", text: "911 Carrera 4S"
    assert_select ".car-card__title", text: "Macan GTS"
    assert_select ".car-card__title", text: "718 Cayman Vendido", count: 0
    assert_select ".car-card__title", text: "Boxster Oculto", count: 0
  end

  test "home includes core SEO tags" do
    get root_path
    assert_select "html[lang=es]"
    assert_select "link[rel=canonical]", 1
    assert_select "meta[name=description][content]", 1
    assert_select "meta[property='og:image']", 1
    assert_select "script[type='application/ld+json']", /AutoDealer/
  end

  test "stock page lists only published cars and marks reserved ones" do
    get cars_path
    assert_response :success
    assert_select ".car-card", 2
    assert_select ".chip--status", text: "Reservado", count: 1
    assert_select "title", /Porsche de ocasión en venta/
  end

  test "stock page filters by body type" do
    get cars_path(categoria: "suv")
    assert_response :success
    assert_select ".car-card", 1
    assert_select ".car-card__title", text: "Macan GTS"
    assert_select "link[rel=canonical][href$='categoria=suv']"
  end

  test "model page lists that range's cars with its own SEO" do
    get model_line_path(slug: "911")
    assert_response :success
    assert_select "h1", "Porsche 911 de ocasión"
    assert_select ".car-card__title", text: "911 Carrera 4S"
    assert_select ".car-card__title", text: "Macan GTS", count: 0
    assert_select "link[rel=canonical][href$='/porsche-911-de-ocasion']"
    assert_select "script[type='application/ld+json']", /BreadcrumbList/
  end

  test "model page without stock invites the visitor to get in touch" do
    get model_line_path(slug: "taycan")
    assert_response :success
    assert_select ".empty-state a[data-umami-event-lugar=modelo-sin-stock]"
  end

  test "unknown model slugs are not found" do
    get "/porsche-carrera-gt-de-ocasion"
    assert_response :not_found
  end

  test "stock page links to the model pages that have stock" do
    get cars_path
    assert_select ".filter a[href='/porsche-911-de-ocasion']"
    assert_select ".filter a[href='/porsche-macan-de-ocasion']"
    assert_select ".filter a[href='/porsche-taycan-de-ocasion']", count: 0
  end

  test "car page renders details, gallery and structured data" do
    car = cars(:carrera)
    get car_path(car)
    assert_response :success
    assert_select "h1", "911 Carrera 4S"
    assert_select ".vehicle__price", "139.900 €"
    assert_select ".js-lightbox-open", 1
    assert_select "script[type='application/ld+json']", /"@type":"Car"/
    assert_select "meta[name=robots][content^='index']"
  end

  test "contact buttons are tracked in analytics with place and car" do
    get car_path(cars(:carrera))
    assert_select "a[data-umami-event=whatsapp][data-umami-event-lugar=ficha][data-umami-event-coche='Porsche 911 Carrera 4S']"
    assert_select "a[data-umami-event=whatsapp][data-umami-event-lugar=boton-flotante]"
  end

  test "old car URLs redirect permanently to the canonical slug" do
    car = cars(:carrera)
    get "/coches/#{car.id}"
    assert_redirected_to car_path(car)
    assert_equal 301, response.status
  end

  test "sold cars stay reachable but are not indexed" do
    get car_path(cars(:sold))
    assert_response :success
    assert_select "meta[name=robots][content^='noindex']"
  end

  test "static pages respond" do
    [ about_us_path, legal_path, cookies_policy_path, contact_request_path ].each do |path|
      get path
      assert_response :success, "#{path} should render"
    end
  end

  test "contact form stores the request" do
    assert_difference "ContactRequest.count", 1 do
      post contact_request_path, params: { contact_request: { name: "Ana", email: "ana@example.com", subject: "911", message: "Me interesa", car_id: cars(:carrera).id } }
    end
    assert_redirected_to root_path
    assert_equal cars(:carrera), ContactRequest.last.car
  end
end
