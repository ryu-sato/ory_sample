class PhotosService
  include Singleton

  private
  PHOTO_SERVICE_URL_BASE = Settings.photo_service_url_base
  PHOTO_API_PATH = '/api/v1/photos'

  public
  PHOTO_SERVICE_URL = File.join(PHOTO_SERVICE_URL_BASE, PHOTO_API_PATH)

  def index(user = nil)
    urls = own_photos

    urls
  end

  private

  def own_photos(user = nil)
    res = Typhoeus.get(PHOTO_SERVICE_URL, followlocation: true)
    JSON.parse(res.body, symbolize_names: true).map do |photo_attributes|
      pp photo_attributes[:url]
      photo = Photo.new()
      photo.url = photo_attributes[:url]
      p photo.valid?
      p photo.errors
      photo
    end
  end
end
