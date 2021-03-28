module PhotosHelper
  def photo_url(photo)
    File.join(Settings.photo_service_url_base, photo.path)
  end
end
