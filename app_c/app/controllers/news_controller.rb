class NewsController < ApplicationController
  def index
    logger.debug(request.headers['Authorization'])
  end
end
