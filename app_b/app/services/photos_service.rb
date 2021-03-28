class PhotosService
  include Singleton

  PHOTO_SERVICE_URL_BASE = Settings.photo_service_url_base
  PHOTO_API_PATH = '/api/v1/photos'

  def own_photos(user = nil)
    url = File.join(PHOTO_SERVICE_URL_BASE, PHOTO_API_PATH)
    res = Typhoeus.get(url, followlocation: true)
    JSON.parse(res.body, symbolize_names: true).map do |photo_attributes|
      Photo.new(photo_attributes.slice(:id, :path))
    end
  end
end
