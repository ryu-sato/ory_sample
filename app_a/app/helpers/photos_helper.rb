module PhotosHelper
  API_PATH_BASE = '/api/v1/photos'

  def photo_api_path(photo)
    File.join(API_PATH_BASE, photo.id.to_s)
  end
end
