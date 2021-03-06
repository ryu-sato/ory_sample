module Api
  module V1
    class PhotosController < Api::ApiController
      before_action :authorization_for_index!, only: :index
      before_action :authorization_for_show!, only: :show

      # GET /api/v1/photos
      def index
        @photos = Photo.where(user: current_user)
      end

      # GET /api/v1/photos/:id
      def show
        photo = Photo.find_by(id: params[:id], user: current_user)
        render_not_found and return if photo.blank?

        data = photo.attachment.download
        send_data data, type: photo.attachment.content_type, disposition: 'inline'
      end

      private

      def authorization_for_index!
        authorization!('photos.index')
      end

      def authorization_for_show!
        authorization!('photos.show')
      end
    end
  end
end
