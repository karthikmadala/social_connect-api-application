class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :content, presence: true
  has_one_attached :image

  validates :image, content_type: [ "image/png", "image/jpeg" ]

  def liked_users
    likes.includes(:user).map(&:user)
  end

  after_commit :update_image_url, if: -> { image.attached? }

  def update_image_url
    update_column(:image_url, Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true))
  end
end
