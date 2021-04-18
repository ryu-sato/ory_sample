class PhotosController < ApplicationController
  before_action :set_access_token

  # GET /photos or /photos.json
  def index
    @photos = PhotosService.instance.own_photos(@access_token)
  end

  # GET /photos/1 or /photos/1.json
  def show
    @photo = PhotosService.instance.own_photo(@access_token, params[:id])
  end

  private

  def set_access_token
    authorization = Authorization.find_by(subject: 'test@a.a')
    raise Errors::AuthenticationFailed if authorization.blank?

    @access_token = authorization.access_token
  end

  def authorize_params
    params.permit(:code)
  end
end
