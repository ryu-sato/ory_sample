class PhotosService
  include Singleton

  PHOTO_SERVICE_URL_BASE = Settings.photo_service_url_base
  PHOTO_API_PATH_BASE = '/api/v1/photos'

  def own_photos(access_token)
    res = http_request(access_token, :get, PHOTO_API_PATH_BASE).run
    raise Errors::AuthorizationFailed if res.response_code == 403
    JSON.parse(res.body, symbolize_names: true).map do |photo_attributes|
      Photo.new(photo_attributes.slice(:id, :path))
    end
  end

  def own_photo(access_token, photo_id)
    res = http_request(access_token, :get, File.join(PHOTO_API_PATH_BASE, photo_id)).run
    raise Errors::AuthorizationFailed if res.response_code == 403
    Photo.new(id: photo_id, data: res.body)
  end

  private

  def http_request(access_token, method, path, body = nil)
    url = File.join(PHOTO_SERVICE_URL_BASE, path)
    Typhoeus::Request.new(
      url,
      method: method,
      body: body,
      headers: {
        Authorization: "Bearer #{access_token}"
      },
      followlocation: true
    )
  end
end
