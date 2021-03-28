module Api
  module V1
    class PhotosController < ApplicationController
      # GET /api/v1/photos
      def index
        @photos = Photo.all
      end

      # GET /api/v1/photos/:id
      def show
        photo = Photo.find(params[:id])
        data = photo.attachment.download
        send_data data, type: photo.attachment.content_type, disposition: 'inline'
      end
    end
  end
end
