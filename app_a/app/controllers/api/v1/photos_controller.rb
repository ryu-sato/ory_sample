module Api
  module V1
    class PhotosController < ApplicationController
      # GET /api/v1/photos
      def index
        @photos = Photo.all
      end
    end
  end
end
