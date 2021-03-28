class PhotosController < ApplicationController
  # GET /photos or /photos.json
  def index
    @photos = PhotosService.instance.own_photos
  end

  # GET /photos/1 or /photos/1.json
  def show
    @photo = PhotosService.instance.own_photos.find { |photo| photo.id == params[:id].to_i }
  end
end
