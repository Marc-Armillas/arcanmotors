class SellRequest < ApplicationRecord
  include LeadForm

  MAX_PHOTOS = 8
  PHOTO_TYPES = %w[image/jpeg image/png image/webp image/heic image/heif].freeze

  has_many_attached :photos

  validates :model, presence: { message: "es obligatorio" }, length: { maximum: 120, message: "es demasiado largo" }
  validates :year, numericality: { only_integer: true, greater_than: 1947, less_than_or_equal_to: -> { Date.current.year + 1 }, message: "no es válido" }, allow_nil: true
  validates :kilometers, :asking_price, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "debe ser un número" }, allow_nil: true
  validate :photos_are_valid

  scope :pending, -> { where(handled: false) }

  private

  def photos_are_valid
    errors.add(:photos, "como máximo #{MAX_PHOTOS}") if photos.size > MAX_PHOTOS
    photos.each do |photo|
      errors.add(:photos, "deben ser imágenes (JPG, PNG, WebP o HEIC)") unless PHOTO_TYPES.include?(photo.content_type)
      errors.add(:photos, "no pueden pesar más de 15 MB cada una") if photo.byte_size > 15.megabytes
    end
  end
end
