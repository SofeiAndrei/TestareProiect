class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true, length: {maximum: 140, minimum: 5}
  validates :title, presence: true
  validates :user_id, presence: true
  validates :image, content_type: { in: ['image/jpeg', 'image/gif', 'image/png'],
                                    message: 'must be a valid image format' },
                    size: { less_than: 5.megabytes,
                            message: 'must be less than 5MB' }
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
