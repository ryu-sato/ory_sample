class PhotosController < ApplicationController
  before_action :set_photo, only: %i[ show edit update destroy ]

  # GET /photos or /photos.json
  def index
    @photos = PhotosService.instance.index
  end

  # GET /photos/1 or /photos/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def photo_params
      params.fetch(:photo, {})
    end
end
