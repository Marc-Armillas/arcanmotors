class Car < ApplicationRecord
  belongs_to :category
  belongs_to :make
  belongs_to :origin_country, class_name: "Country", foreign_key: "origin_country_id", optional: true

  has_many :contact_requests, dependent: :nullify

  has_many_attached :images

  validates :make, presence: true
  validate :image_count_within_limit
  validates :vin, uniqueness: true, allow_nil: true

  enum :status, { on_sale: 0, sold: 1, reserved: 2 }
  enum :condition, { km0: 0, used: 1 }
  enum :gearbox, { manual: 0, automatic: 1, semi_automatic: 2 }
  enum :transmission, { front_wheel_drive: 0, rear_wheel_drive: 1, four_wheel_drive: 2 }
  enum :fuel, { diesel: 0, petrol: 1, electric: 2, hybrid_petrol: 3, hybrid_diesel: 4, lpg: 5, cng: 6, other: 7 }

  before_save :set_vat_price_fields
  before_save :hide_car_if_sold

  def to_param
    "#{self.name.parameterize}-#{self.id}"
  end

  def image_urls
    self.images.map { |image| Rails.application.routes.url_helpers.url_for(image) }
  end

  def medium_image(image)
    image.variant(resize_to_fill: [300, 200], format: :jpg).processed
    # image.variant(resize_to_limit: [300, 200], format: :jpg).processed
  end

  def mediumbig_image(image)
    image.variant(resize_to_fill: [300, 480], format: :jpg).processed
    # image.variant(resize_to_limit: [300, 480], format: :jpg).processed
  end

  def big_image(image)
    image.variant(resize_to_fill: [1000, 1000], format: :jpg).processed
    # image.variant(resize_to_limit: [1000, 1000], format: :jpg).processed
  end

  def tiny_image(image)
    image.variant(resize_to_fill: [30, 30], format: :jpg).processed
    # image.variant(resize_to_limit: [30, 30], format: :jpg).processed
  end

  def get_full_name
    "#{self.make.name} #{self.name}"
  end

  private

  def image_count_within_limit
    if images.count < 1
      errors.add(:images, "must have at least one image")
    end
  end

  def set_vat_price_fields
    if self.new_record? || self.price_changed?
      tax = self.price * 1.21

      self.tax = tax.round(2)
      self.base_price = (self.price - tax).round(2)
    end
  end

  def hide_car_if_sold
    if self.status == "sold"
      self.in_home_page = false
      self.is_public = false
    end
  end
end
