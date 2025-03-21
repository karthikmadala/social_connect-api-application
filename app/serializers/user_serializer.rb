class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :username, :email, :phone, :profile_picture_url

  def profile_picture_url
    object.profile_picture_url.presence || (object.profile_picture.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.profile_picture, only_path: true) : nil)
  rescue StandardError => e
    nil
  end
end
