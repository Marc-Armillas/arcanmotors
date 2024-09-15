class Car < ApplicationRecord
  has_and_belongs_to_many :categories

  has_many_attached :images
  validate :image_count_within_limit

  def medium_image(image)
    image.variant(resize_to_limit: [300, 300], format: :jpg).processed
  end

  def mediumbig_image(image)
    image.variant(resize_to_limit: [300, 480], format: :jpg).processed
  end

  def big_image(image)
    image.variant(resize_to_limit: [1000, 1000], format: :jpg).processed
  end

  def tiny_image(image)
    image.variant(resize_to_limit: [30, 30], format: :jpg).processed
  end

  private

  def image_count_within_limit
    if images.count < 1
      errors.add(:images, "must have at least one image")
    end
  end
end
