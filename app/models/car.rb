class Car < ApplicationRecord
  belongs_to :category
  belongs_to :make
  belongs_to :origin_country, class_name: "Country", foreign_key: "origin_country_id", optional: true

  has_many :contact_requests, dependent: :nullify

  has_many_attached :images

  validates :make, presence: true
  validates :vin, uniqueness: true, allow_nil: true

  validate :image_count_within_limit

  enum :condition, { km0: 0, used: 1 }
  enum :gearbox, { manual: 0, automatic: 1, semi_automatic: 2 }
  enum :transmission, { front_wheel_drive: 0, rear_wheel_drive: 1, four_wheel_drive: 2 }
  enum :fuel, { diesel: 0, petrol: 1, electric: 2, hybrid_petrol: 3, hybrid_diesel: 4, lpg: 5, cng: 6, other: 7 }

  before_save :set_vat_price_fields
  after_commit :process_images, on: [:create, :update], if: -> { self.processed_at.blank? || self.processed_at < 1.minute.ago }

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
    if self.images.count < 1
      self.errors.add(:images, "must have at least one image")
    end
  end

  def set_vat_price_fields
    if self.new_record? || self.price_changed?
      tax = self.price * 1.21

      self.tax = tax.round(2)
      self.base_price = (self.price - tax).round(2)
    end
  end

  def process_images
    self.update_column(:processed_at, Time.current)

    self.images.each do |image|
      image.analyze
      filename = image.blob.filename.to_s.split(".").first

      Tempfile.open([filename, ".jpg"]) do |temp_file|
        begin
          temp_file.binmode
          temp_file.write(image.download)
          temp_file.rewind

          processed_image = ImageProcessing::Vips.source(temp_file.path)
                                                 .resize_to_limit(800, 800)
                                                 .convert("jpg")
                                                 .saver(quality: 85)
                                                 .call

          original_size = File.size(temp_file.path)
          compressed_size = File.size(processed_image.path)

          if compressed_size <= original_size
            # saved_kb = ((original_size - compressed_size) / 1024.0).round(2)
            # saved_percent = ((original_size - compressed_size) * 100.0 / original_size).round(2)
            # puts "original size #{original_size / 1024} KB compressed size #{compressed_size / 1024} KB reduction #{saved_kb} KB (#{saved_percent}%)"

            image.purge
            self.images.attach(io: File.open(processed_image.path), filename: "#{filename}.jpg", content_type: "image/jpeg")
          end
        ensure
          temp_file.close
          temp_file.unlink
        end
      end
    end
  end
end
