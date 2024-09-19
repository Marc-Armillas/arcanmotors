class Car < ApplicationRecord
  belongs_to :categories
  belongs_to :makes
  belongs_to :country

  has_many_attached :images
  validate :image_count_within_limit

  enum :condition => { km0: 0, used: 1 }
  enum :gearbox => [:manual, :automatic, :semi_automatic]
  enum transmission: { front_wheel_drive: 0, rear_wheel_drive: 1, four_wheel_drive: 2 }
  enum fuel: { diesel: 0, petrol: 1, electric: 2, hybrid_petrol: 3, hybrid_diesel: 4, lpg: 5, cng: 6, other: 7 }

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
