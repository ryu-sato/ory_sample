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
    @access_token = HydraService.instance.issue_token
  end
end
